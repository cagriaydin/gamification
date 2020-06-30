
import 'dart:convert';

UserRewardDTO userRewardFromJson(String str) => UserRewardDTO.fromJson(json.decode(str));

String userRewardToJson(UserRewardDTO data) => json.encode(data.toJson());

List<UserRewardDTO> userRewardListFromJson(List<dynamic> listOfString) =>
    (listOfString).map((e) => UserRewardDTO.fromJson(e)).toList();

class UserRewardDTO {
  String userid;
  String rewardid;
  DateTime date;
  int status;
  int point;

  UserRewardDTO({
  this.userid,
  this.rewardid,
  this.date,
  this.status,
  this.point
  });


  factory UserRewardDTO.fromJson(Map<String, dynamic> json) => UserRewardDTO(
        userid: json["userid"],
        rewardid: json["rewardid"],
        date: json["date"] == null
            ? DateTime.now()
            : DateTime.tryParse(json["date"]),
        status: json["status"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "rewardid": rewardid,
        "date": iso8601string(date),
        "status": status,
        "point": point,
      };

  String iso8601string(value) => value == null ? null : value.toIso8601String();

}