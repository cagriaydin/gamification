import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yorglass_ik/enums/authentication-enum.dart';
import 'package:yorglass_ik/enums/verification-status-enum.dart';
import 'package:yorglass_ik/models/authentication-status.dart';
import 'package:yorglass_ik/models/user.dart';

class AuthenticationService {
  static final instance = FirebaseAuth.instance;
  static User verifiedUser = User(
    code: '20407',
    name: 'ANIL ÇELEBİ',
    branchName: 'ATAŞEHİR',
    image: 'https://lh3.googleusercontent.com/proxy/veLJiq2sZ7100dmk3mqabSkB9rO5ixyVFIztg4_fCSMXdRQJ3fg0JXbk9rkUDSfo86h_8V2mTDTwl4HDTkMPzCEFRGnYwpRMz0UHxzIXebgWwCImdg',
  );

  Future<VerificationStatusEnum> signIn(AuthCredential credential) async {
    AuthResult result;
    try {
      result = await instance.signInWithCredential(credential);
      if (result != null) {
        return VerificationStatusEnum.ok;
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

  Future<VerificationStatusEnum> signInWithOTP(String smsCode, String verId) async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(verificationId: verId, smsCode: smsCode);
    VerificationStatusEnum status = await signIn(_authCredential);
    return status;
  }

  signOut() async {
    await instance.signOut();
  }

  verifyPhone(String phoneNo, BuildContext context, Function callback(AuthenticationStatus authenticationStatus)) async {
    AuthenticationStatus status;
    final PhoneVerificationCompleted verified = (AuthCredential auth) {
      status = AuthenticationStatus(authenticationEnum: AuthenticationEnum.success);
      callback(status);
    };
    final PhoneVerificationFailed verificationFailed = (AuthException authException) {
      status = AuthenticationStatus(authenticationEnum: AuthenticationEnum.fail, exceptionCode: authException.code);
      callback(status);
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      status = AuthenticationStatus(authenticationEnum: AuthenticationEnum.smsSent, verificationId: verId);
      callback(status);
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      status = AuthenticationStatus(authenticationEnum: AuthenticationEnum.timeout, verificationId: verId);
      callback(status);
    };

    await instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(
          seconds: 30,
        ),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
    return status;
  }
}
