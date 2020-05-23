import 'package:flutter/material.dart';

class LeaderBoardItem {
  final String imageId;
  final int point;
  final String name;
  final String branchName;

  LeaderBoardItem({
    @required this.imageId,
    @required this.point,
    @required this.name,
    this.branchName,
  });
}
