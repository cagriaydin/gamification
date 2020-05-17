import 'package:flutter/material.dart';
import 'package:yorglass_ik/widgets/leader_board.dart';

class LeaderBoardPage extends StatelessWidget {
  final LeaderBoard leaderBoard;

  const LeaderBoardPage({Key key, this.leaderBoard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          leaderBoard,
          Text('Leaders')],
      ),
    );
  }
}
