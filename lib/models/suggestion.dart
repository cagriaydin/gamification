// To parse this JSON data, do
//
//     final suggestion = suggestionFromJson(jsonString);

import 'dart:convert';

Suggestion suggestionFromJson(String str) =>
    Suggestion.fromJson(json.decode(str));

String suggestionToJson(Suggestion data) => json.encode(data.toJson());

class Suggestion {
  String id;
  String uid;
  String title;
  String description;
  int type;
  int status;
  String flag;
  DateTime date;

  Suggestion(
      {this.id,
      this.uid,
      this.title,
      this.description,
      this.type,
      this.status,
      this.flag,
      this.date});

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
        id: json["id"],
        uid: json["uid"],
        title: json["title"],
        description: json["description"],
        type: json["type"],
        status: json["status"],
        flag: json["flag"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "title": title,
        "description": description,
        "type": type,
        "status": status,
        "flag": flag,
        "date": iso8601string(date),
      };

  String iso8601string(value) => value == null ? null : value.toIso8601String();
}

// {
//   "id":"",
//   "uid":"",
//   "title":"",
//   "description":"",
//   "type":0,
//   "status":0,
//   "flag":""
// }
