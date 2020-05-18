// To parse this JSON data, do
//
//     final branchLeaderBoard = branchLeaderBoardFromJson(jsonString);

import 'dart:convert';

BranchLeaderBoard branchLeaderBoardFromJson(String str) =>
    BranchLeaderBoard.fromJson(json.decode(str));

String branchLeaderBoardToJson(BranchLeaderBoard data) =>
    json.encode(data.toJson());

class BranchLeaderBoard {
  String id;
  String branchId;
  int point;

  BranchLeaderBoard({
    this.id,
    this.branchId,
    this.point,
  });

  factory BranchLeaderBoard.fromJson(Map<String, dynamic> json) =>
      BranchLeaderBoard(
        id: json["id"],
        branchId: json["branchId"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branchId": branchId,
        "point": point,
      };
}

// {
//   "id":"",
//   "branchId":"",
//   "point": 0
// }
