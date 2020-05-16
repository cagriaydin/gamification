import 'package:flutter/material.dart';
import 'package:yorglass_ik/pages/rewards_page.dart';
import 'package:yorglass_ik/widgets/blur_widget.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';

class RewardCards extends StatelessWidget {
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

    return GestureDetector(
      onTap: () => pushRewardsPage(context),
      child: Stack(
        children: [
          Positioned(
            top: cardPadding + 30,
            left: cardPadding,
            child: Transform.scale(
              scale: 0.8,
              child: Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  gradient: getGradient(
                      firstColor: Color(0xffA7C9CC),
                      lastColor: Color(0xffCFD4D6)),
                ),
              ),
            ),
          ),
          Positioned(
            top: cardPadding + 16,
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
              ),
              child: BlurWidget(
                backgroundChild: FlagAvatar(
                  point: 500,
                  imageUrl:
                      'https://vrl-eu-cdn.wetransfer.net/ivise/eyJwaXBlbGluZSI6W1sic3JnYiIse31dLFsiYXV0b19vcmllbnQiLHt9XSxbImdlb20iLHsiZ2VvbWV0cnlfc3RyaW5nIjoiNTEyeDUxMj4ifV0sWyJmb3JjZV9qcGdfb3V0Iix7InF1YWxpdHkiOjg1fV0sWyJzaGFycGVuIix7InJhZGl1cyI6MC43NSwic2lnbWEiOjAuNX1dLFsiZXhwaXJlX2FmdGVyIix7InNlY29uZHMiOjYwNDgwMH1dXSwic3JjX3VybCI6InMzOi8vd2V0cmFuc2Zlci1ldS1wcm9kLW91dGdvaW5nL2U2NjQ4MGMzOGY1OTUxOTc2ZDQ0MjRjZjc3NGViMDhlMjAyMDA1MTMxMDUzNTkvYmFmNmIxOWU4MjJlOTc3ZmZiMzJhNDg3MTg4ZGNlMTA5ODcwZDYxYSJ9/24d49e9ef8cb5f1be34bbe1cfd228e6cbb7a247f26aa702ec2b8268bfadadc0f',
                ),
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
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
