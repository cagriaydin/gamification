// To parse this JSON data, do
//
//     final authenticationModel = authenticationModelFromJson(jsonString);

import 'dart:convert';

import 'package:yorglass_ik/models/user.dart';

AuthenticationModel authenticationModelFromJson(String str) => AuthenticationModel.fromJson(json.decode(str));

String authenticationModelToJson(AuthenticationModel data) => json.encode(data.toJson());

class AuthenticationModel {
  AuthenticationModel({
    this.refreshToken,
    this.user,
    this.token,
  });

  String refreshToken;
  User user;
  String token;

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) => AuthenticationModel(
    refreshToken: json["refreshToken"],
    user: User.fromMap(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "refreshToken": refreshToken,
    "user": user.toMap(),
    "token": token,
  };
}