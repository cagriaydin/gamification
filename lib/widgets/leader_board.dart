import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/leader_board_item.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';

class LeaderBoard extends StatelessWidget {
  final List<LeaderBoardItem> list;
  final bool isLeaderBoard;

  const LeaderBoard({
    Key key,
    this.list,
    this.isLeaderBoard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size.height < 600) {
      return Transform(
        transform: Matrix4.identity()..scale(isLeaderBoard ? .85 : .75),
        alignment: isLeaderBoard ? Alignment.topCenter : Alignment.center,
        child: buildLeaderBoard(),
      );
    } else {
      return buildLeaderBoard();
    }
  }

  Widget buildLeaderBoard() {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FlagAvatar(
            imageId: list.elementAt(1).imageId,
            name: list.elementAt(1).name,
            point: list.elementAt(1).point ?? 0,
            rank: 2,
            branchName: list.elementAt(1).branchName,
          ),
          FlagAvatar(
            imageId: list.elementAt(0).imageId,
            name: list.elementAt(0).name,
            point: list.elementAt(0).point ?? 0,
            rank: 1,
            branchName: list.elementAt(0).branchName,
          ),
          FlagAvatar(
            imageId: list.elementAt(2).imageId,
            name: list.elementAt(2).name,
            point: list.elementAt(2).point ?? 0,
            rank: 3,
            branchName: list.elementAt(2).branchName,
          ),
        ],
      ),
    );
  }
}
