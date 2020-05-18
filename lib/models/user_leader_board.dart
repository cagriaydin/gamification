// To parse this JSON data, do
//
//     final userLeaderBoard = userLeaderBoardFromJson(jsonString);

import 'dart:convert';

UserLeaderBoard userLeaderBoardFromJson(String str) => UserLeaderBoard.fromJson(json.decode(str));

String userLeaderBoardToJson(UserLeaderBoard data) => json.encode(data.toJson());

class UserLeaderBoard {
    String id;
    String userId;
    int point;

    UserLeaderBoard({
        this.id,
        this.userId,
        this.point,
    });

    factory UserLeaderBoard.fromJson(Map<String, dynamic> json) => UserLeaderBoard(
        id: json["id"],
        userId: json["userId"],
        point: json["point"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "point": point,
    };
}

// {
//   "id":"",
//   "userId":"",
//   "point": 0
// }