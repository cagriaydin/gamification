// To parse this JSON data, do
//
//     final branchLeaderBoard = branchLeaderBoardFromJson(jsonString);

import 'dart:convert';

BranchLeaderBoard branchLeaderBoardFromJson(String str) =>
    BranchLeaderBoard.fromJson(json.decode(str));

String branchLeaderBoardToJson(BranchLeaderBoard data) =>
    json.encode(data.toJson());

List<BranchLeaderBoard> branchLeaderBoardListFromJson(List<dynamic> listOfString) =>
    (listOfString).map((e) => BranchLeaderBoard.fromJson(e)).toList();

class BranchLeaderBoard {
  String branchId;
  int point;

  BranchLeaderBoard({
    this.branchId,
    this.point,
  });

  factory BranchLeaderBoard.fromJson(Map<String, dynamic> json) =>
      BranchLeaderBoard(
        branchId: json["branchid"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "branchid": branchId,
        "point": point,
      };
}

// {
//   "id":"",
//   "branchId":"",
//   "point": 0
// }
