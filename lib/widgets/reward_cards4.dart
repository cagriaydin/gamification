import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user-reward.dart';
import 'package:yorglass_ik/pages/reward_detail.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';
import 'package:yorglass_ik/widgets/reward_like_widget.dart';
import 'package:provider/provider.dart';

class RewardCards4 extends StatelessWidget {
  final Reward reward;
  const RewardCards4({Key key, this.reward})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userPoint = context.select((UserReward value) => value.point);
    return GestureDetector(
      onTap: () {
        return Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return RewardDetail(
            reward: reward,
          );
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                // offset: Offset(-2, 2),
                spreadRadius: 1,
                blurRadius: 2,
                color: const Color(0xff1A8EA7).withOpacity(.2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  reward.title,
                  style: TextStyle(fontSize: 20, color: Color(0xff26315F)),
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  FlagAvatar(
                    name: "",
                    isLeaderBoard: true,
                    point: reward.point,
                    imageId: reward.imageId,
                    titleColor: Color(0xff26315F),
                    rewardPoint: reward.point,
                    userActivePoint: userPoint,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: LikeRewardWidget(
                      reward: reward,
                      likedRewards: [],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
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
