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
  String code;
  String image;
  List<String> likedFeeds;
  List<String> deletedFeeds;

  User({
    this.id,
    @required this.name,
    @required this.branchName,
    @required this.code,
    @required this.image,
    @required this.likedFeeds,
    @required this.deletedFeeds,
  });

  User copyWith({
    String id,
    String name,
    String branchName,
    String code,
    String image,
    List<String> likedFeeds,
    List<String> deletedFeeds,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        branchName: branchName ?? this.branchName,
        code: code ?? this.code,
        image: image ?? this.image,
        likedFeeds: likedFeeds ?? this.likedFeeds,
        deletedFeeds: deletedFeeds ?? this.deletedFeeds,
      );

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        branchName: json["branchName"] == null ? null : json["branchName"],
        code: json["code"] == null ? null : json["code"],
        image: json["image"] == null ? null : json["image"],
        likedFeeds: List<String>.from(json["likedFeeds"].map((x) => x)),
        deletedFeeds: List<String>.from(json["deletedFeeds"].map((x) => x)),
      );

  factory User.fromSnapshot(DocumentSnapshot snapshot) => User(
        id: snapshot.data["id"] == null ? null : snapshot.data["id"],
        name: snapshot.data["name"] == null ? null : snapshot.data["name"],
        branchName: snapshot.data["branchName"] == null ? null : snapshot.data["branchName"],
        code: snapshot.data["code"] == null ? null : snapshot.data["code"],
        image: snapshot.data["image"] == null ? null : snapshot.data["image"],
        likedFeeds: List<String>.from(snapshot.data["likedFeeds"].map((x) => x)),
        deletedFeeds: List<String>.from(snapshot.data["deletedFeeds"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "branchName": branchName == null ? null : branchName,
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
//"extraInfo":{},
//"model": "hex",
//"brand":"",
//"os":"",
//"phoneNumber":""
//}
