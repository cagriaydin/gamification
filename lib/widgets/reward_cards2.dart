import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:provider/provider.dart';
import 'package:yorglass_ik/models/user-reward.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';
import 'package:yorglass_ik/widgets/reward_like_widget.dart';

class RewardCards2 extends StatelessWidget {
  final Reward reward;
  final bool isFirst;

  const RewardCards2({Key key, this.reward, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    final userPoint = context.select((UserReward value) => value.point);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              spreadRadius: 1,
              blurRadius: 2,
              color: const Color(0xffABF3F8),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: FlagAvatar(
                imageId: reward.imageId,
                isLeaderBoard: true,
                split: false,
                name: reward.title,
                radius: 40,
                point: reward.point,
                titleColor: Colors.black54,
              ),
            ),
            Positioned(
              bottom: 8,
              left: 4,
              child: LinearPercentIndicator(
                linearStrokeCap: LinearStrokeCap.roundAll,
                width: 140.0,
                lineHeight: 14.0,
                percent: getPercentage(userPoint),
                backgroundColor: Colors.white,
                linearGradient: LinearGradient(
                  colors: [
                    Color(0xFFABF3F8),
                    Color(0xFF80CEDF),
//                    Color(0xFF26315F),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 0,
              child: LikeRewardWidget(
                reward: reward,
                likedRewards: [],
              ),
            )
          ],
        ),
      ),
    );
  }

  double getPercentage(int userActivePoint) =>
      reward.point < userActivePoint ? 1.0 : userActivePoint / reward.point;
}

LinearGradient getGradient({
  Color firstColor = Colors.white,
  Color lastColor = const Color(0xff80CEDF),
}) {
  return LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      firstColor,
      lastColor,
    ],
  );
}
