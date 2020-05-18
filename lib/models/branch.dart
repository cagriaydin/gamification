// To parse this JSON data, do
//
//     final branch = branchFromJson(jsonString);

import 'dart:convert';

Branch branchFromJson(String str) => Branch.fromJson(json.decode(str));

String branchToJson(Branch data) => json.encode(data.toJson());

class Branch {
  String id;
  String name;
  String image;
  int point;
  // LatLng location;
  int employeeCount;
  String color;

  Branch({
    this.id,
    this.name,
    this.point,
    this.image,
    // this.location,
    this.employeeCount,
    this.color,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        name: json["name"],
        point: json["point"],
        image: json["image"],
        // location: json["location"],
        employeeCount: json["employeeCount"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "point": point,
        "image": image,
        // "location": location,
        "employeeCount": employeeCount,
        "color": color,
      };
}

// {
//   "id":"",
//   "name":"",
//   "point":0,
//   "image":"",
//   "location":"",
//   "color",
//   "image",
//   "employeeCount":0
// }
