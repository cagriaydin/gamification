import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user-reward.dart';
import 'package:yorglass_ik/pages/reward_detail.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';
import 'package:yorglass_ik/widgets/gradient_text.dart';
import 'package:yorglass_ik/widgets/reward_like_widget.dart';

class RewardCards4 extends StatelessWidget {
  final Reward reward;
  final bool isMyReward;

  const RewardCards4({Key key, this.reward, this.isMyReward = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                spreadRadius: 1,
                blurRadius: 3,
                color: const Color(0xffABF3F8),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                flex: 29,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Text(
                    reward.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 20, color: Color(0xff26315F)),
                  ),
                ),
              ),
              Expanded(
                flex: 110,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    FlagAvatar(
                      radius: size.height < 700 ? 40 : 50,
                      name: "",
                      isLeaderBoard: true,
                      imageId: reward.imageId,
                      titleColor: Color(0xff26315F),
                      centerWidget: GradientText(
                        '%${(reward.point / userPoint).floor()}',
                        linearGradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xff2FB4C2),
                              Colors.white,
                              Colors.white
                            ]),
                        fontSize: size.height < 700 ? 25 : 30,
                      ),
                      point: reward.point,
                      rewardPoint: reward.point,
                      userActivePoint: isMyReward ? null : userPoint,
                    ),
                    if (!isMyReward)
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
