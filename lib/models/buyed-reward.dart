import 'package:yorglass_ik/models/reward.dart';
import 'dart:convert';

BuyedReward buyedRewardFromJson(String str) => BuyedReward.fromJson(json.decode(str));

String buyedRewardToJson(BuyedReward data) => json.encode(data.toJson());

List<BuyedReward> buyedRewardListFromJson(List<dynamic> listOfString) =>
    (listOfString).map((e) => BuyedReward.fromJson(e)).toList();

class BuyedReward extends Reward {
  final DateTime buyDate;
  final int status;

  BuyedReward({
    String id,
    String title,
    String imageId,
    int point,
    int likeCount,
    String itemType,
    this.buyDate,
    this.status,
  }) : super(
          id: id,
          title: title,
          imageId: imageId,
          point: point,
          likeCount: likeCount,
          itemType: itemType,
        );

  factory BuyedReward.fromJson(Map<String, dynamic> json) => BuyedReward(
        id: json["id"],
        title: json["title"],
        imageId: json["image"],
        point: json["point"],
        itemType: json["type"],
        likeCount: json["likeCount"],
        buyDate: json["date"] == null
            ? DateTime.now()
            : DateTime.tryParse(json["date"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": imageId,
        "point": point,
        "type": itemType,
        "likeCount": likeCount,
        "date": iso8601string(buyDate),
        "status": status,
      };

  String iso8601string(value) => value == null ? null : value.toIso8601String();
}
