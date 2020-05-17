import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';

class LeaderBoard extends StatelessWidget {
  final List<User> users;

  const LeaderBoard({
    Key key,
    this.users,
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
            imageUrl: users.elementAt(1).image,
            point: users.elementAt(1).point,
            rank: 2,
          ),
        ),
        Hero(
          tag: '1',
          child: FlagAvatar(
            imageUrl: users.elementAt(0).image,
            point: users.elementAt(0).point,
            rank: 1,
          ),
        ),
        Hero(
          tag: '3',
          child: FlagAvatar(
            imageUrl: users.elementAt(2).image,
            point: users.elementAt(2).point,
            rank: 3,
          ),
        ),
      ],
    );
  }
}
