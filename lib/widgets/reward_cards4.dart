import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user-reward.dart';
import 'package:yorglass_ik/pages/reward_detail.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';
import 'package:yorglass_ik/widgets/reward_like_widget.dart';
import 'package:provider/provider.dart';

class RewardCards4 extends StatelessWidget {
  final Reward reward;
  const RewardCards4({Key key, this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userPoint = context.select((UserReward value) => value.point);
    return GestureDetector(
      onTap: () {
        return Navigator.push(context, MaterialPageRoute(builder: (_) {
          final provider = Provider.of<UserReward>(context);
          return ChangeNotifierProvider.value(
            value: provider,
            child: RewardDetail(
              reward: reward,
            ),
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
                blurRadius: 3,
                color: const Color(0xffABF3F8),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Text(
                  reward.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(fontSize: 20, color: Color(0xff26315F)),
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
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
