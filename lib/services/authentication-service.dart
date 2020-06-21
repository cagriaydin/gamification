import 'package:dio/src/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yorglass_ik/models/authentication_model.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/pages/welcome.dart';
import 'package:yorglass_ik/repositories/dio_repository.dart';
import 'package:yorglass_ik/repositories/user_repository.dart';

class AuthenticationService {
  AuthenticationService._privateConstructor();

  static final AuthenticationService _instance =
      AuthenticationService._privateConstructor();

  static AuthenticationService get instance => _instance;

  static User verifiedUser;
  static AuthenticationModel verifiedAuth;

  signOut(BuildContext context) async {
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove('refreshToken');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return WelcomePage();
        },
      ),
      (Route<dynamic> route) => false,
    );
  }

  Future<bool> sendMessage(
    String code,
  ) async {
    Response post = await RestApi.instance.dio.post('/auth/sendMessage/$code');
    return post.statusCode == 200;
  }

  Future<User> authenticate(String userCode, String phoneCode) async {
    Response future = await RestApi.instance.dio
        .post('/auth/', data: {"authCode": phoneCode, "userCode": userCode});
    await fillUser(future);
    await saveToken();
    return verifiedUser;
  }

  Future saveToken() async {
    final sharedPref = await SharedPreferences.getInstance();
    //TODO: this is not safe encrypt it or save locally with another way.
    sharedPref.setString("refreshToken", verifiedAuth.refreshToken);
  }

  Future<void> fillUser(Response future) async {
    verifiedAuth = AuthenticationModel.fromJson(future.data);
    verifiedUser = verifiedAuth.user;
    verifiedUser =
        await UserRepository.instance.fillUserWithRest(verifiedUser, true);
  }

  Future<User> refreshAuthenticate() async {
    final sharedPref = await SharedPreferences.getInstance();
    final refreshToken = sharedPref.getString('refreshToken');
    if (refreshToken == null) return null;
    var response = await RestApi.instance.dio
        .post('/auth/refreshToken', data: refreshToken);
    if (response.statusCode == 200) {
      await fillUser(response);
      return verifiedUser;
    } else {
      return null;
    }
  }
}
