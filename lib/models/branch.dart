// To parse this JSON data, do
//
//     final branch = branchFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Branch branchFromJson(String str) => Branch.fromJson(json.decode(str));

String branchToJson(Branch data) => json.encode(data.toJson());

class Branch {
  String id;
  String name;
  Blob image;
  // LatLng location;
  int employeeCount;
  String color;

  Branch({
    this.id,
    this.name,
    // this.location,
    this.employeeCount,
    this.color,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        name: json["name"],
        // location: json["location"],
        employeeCount: json["employeeCount"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        // "location": location,
        "employeeCount": employeeCount,
        "color": color,
      };
}

// {
//   "id":"",
//   "name":"",
//   "location":"",
//   "color",
//   "image",
//   "employeeCount":0
// }
