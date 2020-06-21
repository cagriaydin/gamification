// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

List<Task> taskListFromJson(List<dynamic> listOfString) =>
    (listOfString).map((e) => Task.fromJson(e)).toList();

class Task {
  String id;
  String name;
  int point;
  int interval;
  double renewableTime;
  int count;

  Task({
    @required this.id,
    @required this.name,
    @required this.point,
    @required this.interval,
    @required this.renewableTime,
    @required this.count,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        name: json["name"],
        point: json["point"],
        interval: json["taskinterval"],
        renewableTime: json["renwableday"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "point": point,
        "taskinterval": interval,
        "renwableday": renewableTime,
        "count": count,
      };
}

//{
//  "id":"id",
//  "name": "",
//  "point": 1,
//  "interval": 1,
//  "counter": 2
//}
