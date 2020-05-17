import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._privateConstructor();

  UserRepository._privateConstructor();

  static UserRepository get instance => _instance;

  Future<User> getUserByAuthId(String authId) async {
    Results res = await DbConnection.query('SELECT * FROM user WHERE authid = ?', [authId]);
    if (res.length > 0) {
      return User(id: res.single[0], name: res.single[1], branchName: res.single[3], phone: res.single[2], code: res.single[4], image: res.single[5]);
    } else {
      return null;
    }
  }

  Future<User> getUserByPhoneNumber(String phone) async {
    if (phone.startsWith('+90')) {
      phone = phone.replaceAll('+90', '');
    }
    Results res = await DbConnection.query('SELECT * FROM user WHERE phone = ?', [phone]);
    if (res.length > 0) {
      return User(id: res.single[0], name: res.single[1], branchName: res.single[3], phone: res.single[2], code: res.single[4], image: res.single[5]);
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
