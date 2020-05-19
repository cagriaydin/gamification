// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromMap(json.decode(str));

String userToJson(User data) => json.encode(data.toMap());

class User {
  String id;
  String name;
  String branchName;
  String branchId;
  String phone;
  int code;
  String image;

  int percentage;
  int taskCount;
  int point;
  List<String> likedFeeds;
  List<String> deletedFeeds;

  User({
    this.id,
    @required this.name,
    @required this.point,
    @required this.percentage,
    @required this.taskCount,
    @required this.branchName,
    @required this.phone,
    @required this.code,
    @required this.image,
    @required this.likedFeeds,
    @required this.deletedFeeds,
    this.branchId,
  });

  User copyWith({
    String id,
    String name,
    int point,
    int taskCount,
    int percentage,
    String branchName,
    String branchId,
    String phone,
    int code,
    String image,
    List<String> likedFeeds,
    List<String> deletedFeeds,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        point: point ?? this.point,
        percentage: percentage ?? this.percentage,
        taskCount: taskCount ?? this.taskCount,
        branchName: branchName ?? this.branchName,
        branchId: branchId ?? this.branchId,
        phone: phone ?? this.phone,
        code: code ?? this.code,
        image: image ?? this.image,
        likedFeeds: likedFeeds ?? this.likedFeeds,
        deletedFeeds: deletedFeeds ?? this.deletedFeeds,
      );

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        point: json["point"] == null ? null : json["point"],
        percentage: json["percentage"] == null ? null : json["percentage"],
        taskCount: json["taskCount"] == null ? null : json["taskCount"],
        branchName: json["branchName"] == null ? null : json["branchName"],
        branchId: json["branchId"] == null ? null : json["branchId"],
        phone: json["phone"] == null ? null : json["phone"],
        code: json["code"] == null ? null : json["code"],
        image: json["image"] == null ? null : json["image"],
        likedFeeds: List<String>.from(json["likedFeeds"].map((x) => x)),
        deletedFeeds: List<String>.from(json["deletedFeeds"].map((x) => x)),
      );

  factory User.fromSnapshot(DocumentSnapshot snapshot) => User(
        id: snapshot.data["id"] == null ? null : snapshot.data["id"],
        name: snapshot.data["name"] == null ? null : snapshot.data["name"],
        point: snapshot.data["point"] == null ? null : snapshot.data["point"],
        percentage: snapshot.data["percentage"] == null ? null : snapshot.data["percentage"],
        taskCount: snapshot.data["taskCount"] == null ? null : snapshot.data["taskCount"],
        branchName: snapshot.data["branchName"] == null ? null : snapshot.data["branchName"],
        branchId: snapshot.data["branchId"] == null ? null : snapshot.data["branchId"],
        phone: snapshot.data["phone"] == null ? null : snapshot.data["phone"],
        code: snapshot.data["code"] == null ? null : snapshot.data["code"],
        image: snapshot.data["image"] == null ? null : snapshot.data["image"],
        likedFeeds: List<String>.from(snapshot.data["likedFeeds"].map((x) => x)),
        deletedFeeds: List<String>.from(snapshot.data["deletedFeeds"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "point": point == null ? null : point,
        "percentage": percentage == null ? null : percentage,
        "taskCount": taskCount == null ? null : taskCount,
        "branchName": branchName == null ? null : branchName,
        "branchId": branchId == null ? null : branchId,
        "phone": phone == null ? null : phone,
        "code": code == null ? null : code,
        "image": image == null ? null : image,
        "likedFeeds": List<dynamic>.from(likedFeeds.map((x) => x)),
        "deletedFeeds": List<dynamic>.from(deletedFeeds.map((x) => x)),
      };
}

//{
//"id": "id",
//"name":"",
//"branchName":"",
//"branchId":"",
//"phone":"",
//"extraInfo":{},
//"model": "hex",
//"brand":"",
//"os":"",
//"phoneNumber":""
//}
