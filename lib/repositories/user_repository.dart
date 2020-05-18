import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/models/user_leader_board.dart';
import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/repositories/image-repository.dart';
import 'package:yorglass_ik/models/image.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._privateConstructor();

  UserRepository._privateConstructor();

  static UserRepository get instance => _instance;

  List<UserLeaderBoard> getUserPointList() {
    List<UserLeaderBoard> list = List<UserLeaderBoard>();
    list.add(UserLeaderBoard(id: "1", userId: "b83cb5e2-19cd-4f1e-9f4e-cea74677f662", point: 155));
    list.add(UserLeaderBoard(id: "2", userId: "6ac13dec-fa04-4d16-8887-2ffa6d349139", point: 450));
    list.add(UserLeaderBoard(id: "3", userId: "3", point: 300));
    list.add(UserLeaderBoard(id: "4", userId: "ca88ee1f-f508-438e-bee3-8bed49f3c661", point: 400));
    list.add(UserLeaderBoard(id: "5", userId: "5", point: 250));
    list.add(UserLeaderBoard(id: "6", userId: "6", point: 170));
    list.add(UserLeaderBoard(id: "7", userId: "7", point: 170));
    list.add(UserLeaderBoard(id: "8", userId: "8", point: 170));
    list.add(UserLeaderBoard(id: "9", userId: "9", point: 170));
    list.add(UserLeaderBoard(id: "10", userId: "10", point: 170));
    list.add(UserLeaderBoard(id: "11", userId: "11", point: 170));
    list.add(UserLeaderBoard(id: "12", userId: "11", point: 170));
    list.add(UserLeaderBoard(id: "13", userId: "11", point: 170));
    list.add(UserLeaderBoard(id: "14", userId: "11", point: 170));
    list.add(UserLeaderBoard(id: "15", userId: "11", point: 150));
    list.add(UserLeaderBoard(id: "16", userId: "11", point: 150));
    list.add(UserLeaderBoard(id: "17", userId: "11", point: 150));
    list.add(UserLeaderBoard(id: "18", userId: "11", point: 150));
    list.add(UserLeaderBoard(id: "19", userId: "11", point: 150));
    list.add(UserLeaderBoard(id: "20", userId: "11", point: 150));
    list.add(UserLeaderBoard(id: "21", userId: "11", point: 150));
    list.add(UserLeaderBoard(id: "22", userId: "11", point: 150));
    list.sort((a, b) => b.point.compareTo(a.point));
    return list;
  }

  List<User> getUserList() {
    List<User> list = List<User>();
    list.add(User(id: "b83cb5e2-19cd-4f1e-9f4e-cea74677f662", name: "Çağrı Aydın", branchId: "1", image: AuthenticationService.verifiedUser.image, point: 155));
    list.add(User(id: "6ac13dec-fa04-4d16-8887-2ffa6d349139", name: "Oğuz Akpınar", branchId: "2", image: AuthenticationService.verifiedUser.image, point: 450));
    list.add(User(id: "3", name: "Selin Aydın", branchId: "3"));
    list.add(User(id: "ca88ee1f-f508-438e-bee3-8bed49f3c661", name: "Onat Çipli", branchId: "4", image: AuthenticationService.verifiedUser.image, point: 400));
    list.add(User(id: "5", name: "Mustafa Berkay", branchId: "5"));
    list.add(User(id: "6", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "7", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "8", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "9", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "10", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "11", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "12", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "13", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "14", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "15", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "16", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "17", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "18", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "19", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "20", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "21", name: "Ramazan Demir", branchId: "6"));
    list.add(User(id: "22", name: "Ramazan Demir", branchId: "6"));
    return list;
  }

  List<User> getTopUserPointList(){
    var userList = new List<User>();
    var userPointList = getUserPointList().take(3).toList();
    for (var user in userPointList) {
      userList.add(getUser(user.userId));
    }
    return userList;
  }

  User getUser(String id){
    return getUserList().singleWhere((element) => element.id == id);
  }

  Future<User> getUserByAuthId(String authId) async {
    Results res = await DbConnection.query(
        'SELECT * FROM user WHERE authid = ?', [authId]);
    return await _fillUser(res);
  }

  Future<User> getUserByPhoneNumber(String phone) async {
    if (phone.startsWith('+90')) {
      phone = phone.replaceAll('+90', '');
    }
    Results res =
        await DbConnection.query('SELECT * FROM user WHERE phone = ?', [phone]);
    return await _fillUser(res);
  }

  Future<User> _fillUser(Results res) async {
    if (res.length > 0) {
      User user = User(
          id: res.single[0],
          name: res.single[1],
          branchName: res.single[3],
          phone: res.single[2],
          code: res.single[4],
          image: res.single[5]);
      if (user.image != null) {
        Image userImage =
            await ImageRepository.instance.getImage(res.single[5]);
        user.image = userImage.base64;
      }
      Results results = await DbConnection.query(
          'SELECT * FROM feedaction WHERE userid = ?', [user.id]);
      List<String> deletedFeeds = [];
      List<String> likedFeeds = [];
      results.forEach((element) {
        if (element["operation"] == 0) {
          deletedFeeds.add(element["id"]);
        } else {
          likedFeeds.add(element["id"]);
        }
      });
      user.likedFeeds = likedFeeds;
      user.deletedFeeds = deletedFeeds;
      return user;
    } else {
      return null;
    }
  }

  Future<bool> addAuthIdToUser(String id, String authKey) async {
    Results res = await DbConnection.query(
        'UPDATE user SET authid = ? WHERE id = ?', [authKey, id]);
    if (res.affectedRows > 0) {
      return true;
    } else {
      return false;
    }
  }
}
