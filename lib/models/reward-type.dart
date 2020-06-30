// To parse this JSON data, do
//
//     final rewardType = rewardTypeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RewardType rewardTypeFromJson(String str) => RewardType.fromMap(json.decode(str));

String rewardTypeToJson(RewardType data) => json.encode(data.toMap());

List<RewardType> rewardTypeListFromJson(List<dynamic> listOfString) =>
    (listOfString).map((e) => RewardType.fromMap(e)).toList();
class RewardType {
    String id;
    String title;

    RewardType({
        @required this.id,
        @required this.title,
    });

    factory RewardType.fromMap(Map<String, dynamic> json) => RewardType(
        id: json["id"],
        title: json["title"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
    };
}
