import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';
import 'package:yorglass_ik/widgets/reward_like_widget.dart';

class RewardCards4 extends StatelessWidget {
  final ValueNotifier currentPoint;

  final Reward reward;
  const RewardCards4({Key key, this.reward, this.currentPoint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
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
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  reward.title,
                  style: TextStyle(fontSize: 20, color: Color(0xff26315F)),
                ),
              ),
            ),
            Flexible(
              flex: 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FlagAvatar(
                    name: "",
                    isLeaderBoard: true,
                    point: reward.point,
                    imageId: reward.imageId,
                    titleColor: Color(0xff26315F),
                  ),
                  Positioned(
                    child: new CircularPercentIndicator(
                      radius: 90.0,
                      lineWidth: 7.0,
                      percent: currentPoint.value / reward.point > 1.0
                          ? 1.0
                          : currentPoint.value / reward.point,
                      center: IconShadowWidget(
                        Icon(
                          currentPoint.value < reward.point
                              ? Icons.lock
                              : Icons.lock_open,
                          color: Colors.white,
                          size: 36,
                        ),
                        shadowColor: Colors.lightBlueAccent.shade100,
                      ),
                      backgroundColor: Colors.black12,
                      linearGradient: LinearGradient(
                        colors: [
                          Color(0xff1A8EA7),
                          Colors.white,
                        ],
                      ),
                    ),
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
