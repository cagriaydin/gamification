import 'package:yorglass_ik/models/branch.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/models/user_leader_board.dart';
import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/repositories/branch_repository.dart';
import 'package:yorglass_ik/repositories/task-repository.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._privateConstructor();

  UserRepository._privateConstructor();

  static UserRepository get instance => _instance;

  Future<List<UserLeaderBoard>> getUserPointList({int limit, int offset}) async {
    Results res = await DbConnection.query("SELECT * FROM leaderboard, user WHERE enddate IS NULL AND user.id = leaderboard.userid ORDER BY point DESC, user.name" + (limit != null ? (" LIMIT " + limit.toString()) : "") + (offset != null ? (" OFFSET " + offset.toString()) : ""));
    List<UserLeaderBoard> list = [];
    if (res.length > 0) {
      forEach(res, (element) {
        list.add(UserLeaderBoard(userId: element[0], point: element[1]));
      });
    }
    return list;
  }

  Future<List<User>> getUserList({int limit, int offset}) async {
    List<Branch> bList = await BranchRepository.instance.getBranchList();
    Results res = await DbConnection.query("SELECT user.*, lb.point FROM user, leaderboard as lb WHERE user.id = lb.userid AND lb.enddate IS NULL ORDER BY lb.point DESC, user.name" + (limit != null ? (" LIMIT " + limit.toString()) : "") + (offset != null ? (" OFFSET " + offset.toString()) : ""));
    List<User> list = [];
    if (res.length > 0) {
      for (Row element in res) {
        User user = User(
          id: element[0],
          name: element[1],
          branchId: element[3],
          phone: element[2],
          code: element[4],
          image: element[5],
          point: element[7],
        );
        user.branchName = bList.firstWhere((element) => element.id == user.branchId).name;
        list.add(user);
      }
    }
    return list;
  }

  Future<List<User>> getTopUserPointList() async {
    var userList = new List<User>();
    var userPointList = await getUserPointList(limit: 3);
    for (var user in userPointList) {
      userList.add(await getUser(user.userId));
      userList.last.point = user.point;
    }
    return userList;
  }

  Future<User> getUserByAuthId(String authId) async {
    Results res = await DbConnection.query('SELECT * FROM user WHERE authid = ?', [authId]);
    return await _fillUser(res, true);
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

  Future<User> _fillUser(Results res, bool detailed) async {
    if (res.length > 0) {
      User user = User(id: res.single[0], name: res.single[1], branchId: res.single[3], phone: res.single[2], code: res.single[4], image: res.single[5]);
      Branch b = await BranchRepository.instance.getBranch(user.branchId);
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
