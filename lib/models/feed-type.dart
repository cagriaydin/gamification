// To parse this JSON data, do
//
//     final feedType = feedTypeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FeedType feedTypeFromJson(String str) => FeedType.fromMap(json.decode(str));

String feedTypeToJson(FeedType data) => json.encode(data.toMap());


List<FeedType> feedTypeListFromJson(List<dynamic> listOfString) =>
    (listOfString).map((e) => FeedType.fromMap(e)).toList();

class FeedType {
    String id;
    String name;

    FeedType({
        @required this.id,
        @required this.name,
    });

    factory FeedType.fromMap(Map<String, dynamic> json) => FeedType(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
    };
}
