// To parse this JSON data, do
//
//     final userLeaderBoard = userLeaderBoardFromJson(jsonString);

import 'dart:convert';

UserLeaderBoard userLeaderBoardFromJson(String str) => UserLeaderBoard.fromJson(json.decode(str));

String userLeaderBoardToJson(UserLeaderBoard data) => json.encode(data.toJson());

List<UserLeaderBoard> leaderBoardListFromJson(List<dynamic> listOfString) =>
    (listOfString).map((e) => UserLeaderBoard.fromJson(e)).toList();

class UserLeaderBoard {
    String userId;
    int point;

    UserLeaderBoard({
        this.userId,
        this.point,
    });

    factory UserLeaderBoard.fromJson(Map<String, dynamic> json) => UserLeaderBoard(
        userId: json["userid"],
        point: json["point"],
    );

    Map<String, dynamic> toJson() => {
        "userid": userId,
        "point": point,
    };
}

// {
//   "id":"",
//   "userId":"",
//   "point": 0
// }
