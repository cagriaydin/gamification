
import 'dart:convert';

Reward rewardFromJson(String str) => Reward.fromJson(json.decode(str));

String rewardToJson(Reward data) => json.encode(data.toJson());

List<Reward> rewardListFromJson(List<dynamic> listOfString) =>
    (listOfString).map((e) => Reward.fromJson(e)).toList();

class Reward {
  final String id;
  final String title;
  final String imageId;
  final int point;
  final String itemType;
  int likeCount;

  Reward({
    this.id,
    this.title,
    this.imageId,
    this.point,
    this.likeCount,
    this.itemType,
  });

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
        id: json["id"],
        title: json["title"],
        imageId: json["image"],
        point: json["point"],
        itemType: json["type"],
        likeCount: json["likecount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": imageId,
        "point": point,
        "type": itemType,
        "likecount": likeCount,
      };
}
