// To parse this JSON data, do
//
//     final feedAction = feedActionFromJson(jsonString);

import 'dart:convert';

FeedAction feedActionFromJson(String str) =>
    FeedAction.fromJson(json.decode(str));

String feedActionToJson(FeedAction data) => json.encode(data.toJson());

List<FeedAction> feedActionListFromJson(List<dynamic> listOfString) =>
    (listOfString).map((e) => FeedAction.fromJson(e)).toList();

class FeedAction {
  FeedAction({
    this.feedid,
    this.operation,
    this.userid,
  });

  String feedid;
  int operation;
  String userid;

  factory FeedAction.fromJson(Map<String, dynamic> json) => FeedAction(
        feedid: json["feedid"],
        operation: json["operation"],
        userid: json["userid"],
      );

  Map<String, dynamic> toJson() => {
        "feedid": feedid,
        "operation": operation,
        "userid": userid,
      };
}
