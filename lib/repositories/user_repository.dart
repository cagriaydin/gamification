import 'package:dio/dio.dart';
import 'package:yorglass_ik/models/branch.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/models/user_leader_board.dart';
import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/repositories/branch_repository.dart';
import 'package:yorglass_ik/repositories/dio_repository.dart';
import 'package:yorglass_ik/repositories/task-repository.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._privateConstructor();

  UserRepository._privateConstructor();

  static UserRepository get instance => _instance;

  Future<List<UserLeaderBoard>> getUserPointList({int limit, int offset}) async {
    List<UserLeaderBoard> list = [];
    Response userLeaderBoardRes = await RestApi.instance.dio.get(
      '/leaderboard/getAllLeaderBoard' + (limit!=null ? '?limit=' + limit.toString() : '') + (offset!=null ? '&offset=' + offset.toString() : '')
    );
    if (userLeaderBoardRes.data != null) {
      list = leaderBoardListFromJson(userLeaderBoardRes.data);
    }
    return list;
  }

  Future<List<User>> getUserList({int limit, int offset}) async {
    List<Branch> bList = await BranchRepository.instance.getBranchList();
    
    List<User> list = [];
    Response userRes = await RestApi.instance.dio.get(
      '/user/getAllUserList' + (limit!=null ? '?limit=' + limit.toString() : '') + (offset!=null ? '&offset=' + offset.toString() : '')
    );
    if (userRes.data != null) {
      list = userListFromJson(userRes.data);
      for (var item in list) {
          item.branchName = bList.firstWhere((element) => element.id == item.branch).name;
        }
    }
    return list;
  }

  Future<List<User>> getTopUserPointList() async {
    var userList = new List<User>();
    var userPointList = await getUserPointList(limit: 3, offset: 0);
    for (var user in userPointList) {
      userList.add(await getUser(user.userId));
      userList.last.point = user.point;
    }
    return userList;
  }

  Future<User> getUserByAuthId(String userCode) async {
    final res = await RestApi.instance.dio.get('/user/byCode/$userCode');
    final user = User.fromMap(res.data);
    return await fillUserWithRest(user, true);
  }

  Future<User> getUser(String id) async {
    Results res = await DbConnection.query('SELECT * FROM user WHERE id = ?', [id]);
    return await _fillUser(res, false);
  }

  Future<User> getUserByPhoneNumber(String phone) async {
    if (phone.startsWith('+90')) {
      phone = phone.replaceAll('+90', '');
    }
    Results res = await DbConnection.query('SELECT * FROM user WHERE phone = ?', [phone]);
    return await _fillUser(res, true);
  }

  Future<User> fillUserWithRest(User user, bool detailed) async {
    if (user != null) {
      Branch b = await BranchRepository.instance.getBranch(user.branch);
      user.branchName = b.name;
      if (detailed) {
        Results results = await DbConnection.query('SELECT * FROM feedaction WHERE userid = ?', [user.id]);
        List<String> deletedFeeds = [];
        List<String> likedFeeds = [];
        forEach(results, (element) {
          if (element["operation"] == 0) {
            deletedFeeds.add(element["feedid"]);
          } else {
            likedFeeds.add(element["feedid"]);
          }
        });
        user.likedFeeds = likedFeeds;
        user.deletedFeeds = deletedFeeds;
      }
      return user;
    } else {
      return null;
    }
  }

  Future<User> _fillUser(Results res, bool detailed) async {
    if (res.length > 0) {
      User user = User(id: res.single[0], name: res.single[1], branch: res.single[3], phone: res.single[2], code: res.single[4], image: res.single[5]);
      Branch b = await BranchRepository.instance.getBranch(user.branch);
      user.branchName = b.name;
      if (detailed) {
        Results results = await DbConnection.query('SELECT * FROM feedaction WHERE userid = ?', [user.id]);
        List<String> deletedFeeds = [];
        List<String> likedFeeds = [];
        forEach(results, (element) {
          if (element["operation"] == 0) {
            deletedFeeds.add(element["feedid"]);
          } else {
            likedFeeds.add(element["feedid"]);
          }
        });
        user.likedFeeds = likedFeeds;
        user.deletedFeeds = deletedFeeds;


      }
      return user;
    } else {
      return null;
    }
  }

  Future<bool> addAuthIdToUser(String id, String authKey) async {
    Results res = await DbConnection.query('UPDATE user SET authid = ? WHERE id = ?', [authKey, id]);
    if (res.affectedRows > 0) {
      return true;
    } else {
      return false;
    }
  }
}
