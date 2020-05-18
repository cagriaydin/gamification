// To parse this JSON data, do
//
//     final feedType = feedTypeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FeedType feedTypeFromJson(String str) => FeedType.fromMap(json.decode(str));

String feedTypeToJson(FeedType data) => json.encode(data.toMap());

class FeedType {
    String id;
    String title;

    FeedType({
        @required this.id,
        @required this.title,
    });

    factory FeedType.fromMap(Map<String, dynamic> json) => FeedType(
        id: json["id"],
        title: json["title"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
    };
}
