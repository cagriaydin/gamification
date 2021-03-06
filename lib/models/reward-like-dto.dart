import 'dart:convert';

RewardLikeDTO rewardLikeFromJson(String str) => RewardLikeDTO.fromJson(json.decode(str));

String rewardLikeToJson(RewardLikeDTO data) => json.encode(data.toJson());

List<RewardLikeDTO> rewardLikeListFromJson(List<dynamic> listOfString) =>
    (listOfString).map((e) => RewardLikeDTO.fromJson(e)).toList();

class RewardLikeDTO {
  String id;
  String userid;
  String rewardid;
  DateTime date;

  RewardLikeDTO({
    this.id,
    this.userid,
    this.rewardid,
    this.date,
  });
    factory RewardLikeDTO.fromJson(Map<String, dynamic> json) => RewardLikeDTO(
        id: json["id"],
        userid: json["userid"],
        rewardid: json["rewardid"],
        date: json["date"] == null
            ? DateTime.now()
            : DateTime.tryParse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "rewardid": rewardid,
        "date": iso8601string(date),
      };

  String iso8601string(value) => value == null ? null : value.toIso8601String();
}
