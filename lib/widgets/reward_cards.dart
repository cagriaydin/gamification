import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/pages/rewards_page.dart';
import 'package:yorglass_ik/widgets/blur_widget.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';

class RewardCards extends StatelessWidget {
  final Reward reward;

  const RewardCards({Key key, @required this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double cardPadding = 32.0;
    final size = MediaQuery.of(context).size;
    final width = size.width / 2.2;
    final theme = Theme.of(context);

    LinearGradient getGradient({
      Color firstColor = const Color(0xff1A8EA7),
      Color lastColor = Colors.white,
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

    final child = GestureDetector(
      onTap: () => pushRewardsPage(context),
      child: Stack(
        children: [
          Positioned(
            top: cardPadding + 40,
            left: cardPadding,
            child: Transform.scale(
              scale: 0.8,
              child: Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  gradient: getGradient(
                      firstColor: Color(0xffA7C9CC),
                      lastColor: Color(0xffCFD4D6)),
                ),
              ),
            ),
          ),
          Positioned(
            top: cardPadding + 20,
            left: cardPadding,
            child: Transform.scale(
              scale: 0.9,
              child: Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  gradient: getGradient(
                      firstColor: Color(0xffA7C9CC),
                      lastColor: Color(0xffA7C9CC)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Container(
              width: width,
              height: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                gradient: getGradient(),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(-2, 2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    color: const Color(0xff1A8EA7).withOpacity(.2),
                  ),
                ],
              ),
              child: BlurWidget(
                backgroundChild: Stack(
                  alignment: Alignment.center,
                  children: [
                    FlagAvatar(
                      name: "",
                      point: reward.point,
                      imageId: reward.imageId,
                    ),
                    Positioned(
                      child: Column(
                        children: [
                          Icon(Icons.favorite),
                          Text(
                            reward.likeCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15
                            ),
                          )
                        ],
                      ),
                      bottom: 5,
                      right: 8,
                    ),
                  ],
                ),
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );

    if (size.height < 600) {
      return Transform.scale(
        scale: .9,
        child: child,
      );
    } else
      return child;
  }

  Future pushRewardsPage(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return RewardsPage();
        },
      ),
    );
  }
}
