import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/leader_board_item.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';

class LeaderBoard extends StatelessWidget {
  final List<LeaderBoardItem> list;

  const LeaderBoard({
    Key key,
    this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size.height < 600) {
      return Transform(
        transform: Matrix4.identity()..scale(.9),
        child: buildLeaderBoard(),
      );
    } else {
      return buildLeaderBoard();
    }
  }

  Widget buildLeaderBoard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: '2',
          child: FlagAvatar(
            imageUrl: list.elementAt(1).image,
            name: list.elementAt(1).name,
            point: list.elementAt(1).point ?? 0,
            rank: 2,
            branchName: list.elementAt(1).branchName,
          ),
        ),
        Hero(
          tag: '1',
          child: FlagAvatar(
            imageUrl: list.elementAt(0).image,
            name: list.elementAt(0).name,
            point: list.elementAt(0).point ?? 0,
            rank: 1,
            branchName: list.elementAt(1).branchName,
          ),
        ),
        Hero(
          tag: '3',
          child: FlagAvatar(
            imageUrl: list.elementAt(2).image,
            name: list.elementAt(2).name,
            point: list.elementAt(2).point ?? 0,
            rank: 3,
            branchName: list.elementAt(1).branchName,
          ),
        ),
      ],
    );
  }
}
