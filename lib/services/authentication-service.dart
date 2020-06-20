import 'package:dio/src/response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yorglass_ik/enums/verification-status-enum.dart';
import 'package:yorglass_ik/models/authentication_model.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/repositories/dio_repository.dart';
import 'package:yorglass_ik/repositories/task-repository.dart';
import 'package:yorglass_ik/repositories/user_repository.dart';

class AuthenticationService {
  static final firebaseAuthInstance = FirebaseAuth.instance;

  AuthenticationService._privateConstructor();

  static final AuthenticationService _instance =
      AuthenticationService._privateConstructor();

  static AuthenticationService get instance => _instance;

  static User verifiedUser;
  static AuthenticationModel verifiedAuth;

  Future<User> verifyUser() async {
    FirebaseUser result = await firebaseAuthInstance.currentUser();
    User user = await UserRepository.instance.getUserByAuthId(result.uid);
    if (user == null) {
      user = await UserRepository.instance
          .getUserByPhoneNumber(result.phoneNumber);
      if (user != null) {
        verifiedUser = user;
        await UserRepository.instance.addAuthIdToUser(user.id, result.uid);
      }
    } else {
      verifiedUser = user;
    }
    await TaskRepository.instance.updateUserInfo();
    return user;
  }

  Future<VerificationStatusEnum> signIn(AuthCredential credential) async {
    AuthResult result;
    try {
      result = await firebaseAuthInstance.signInWithCredential(credential);
      if (result != null) {
        User user = await verifyUser();
        if (user != null) {
          return VerificationStatusEnum.ok;
        } else {
          signOut();
          return VerificationStatusEnum.wrongCode;
        }
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case "ERROR_MISSING_VERIFICATION_CODE":
          return VerificationStatusEnum.emptyCode;
          break;
        case "ERROR_INVALID_VERIFICATION_CODE":
          return VerificationStatusEnum.wrongCode;
          break;
        default:
          return VerificationStatusEnum.wrongCode;
      }
    }
  }

  Future<VerificationStatusEnum> signInWithOTP(
      String smsCode, String verId) async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    VerificationStatusEnum status = await signIn(_authCredential);
    return status;
  }

  signOut() async {
    await firebaseAuthInstance.signOut();
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
    final sharedPref = await SharedPreferences.getInstance();
    //TODO: this is not safe encrypt it or save locally with another way.
    sharedPref.setString("refreshToken", verifiedAuth.refreshToken);
    return verifiedUser;
  }

  Future<void> fillUser(Response future) async {
    verifiedAuth = AuthenticationModel.fromJson(future.data);
    verifiedUser = verifiedAuth.user;
    verifiedUser = await UserRepository.instance.fillUserWithRest(verifiedUser, true);
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
