import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:yorglass_ik/models/user.dart';

class BuildUserInfo extends StatelessWidget {
  const BuildUserInfo({
    Key key,
    @required this.user,
    this.radius,
    this.showPercentage = false,
  }) : super(key: key);

  final User user;
  final double radius;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: radius ?? 70,
                backgroundImage: NetworkImage(user.image),
              ),
            ),
            if (showPercentage)
              Positioned.fill(
                child: CircularPercentIndicator(
                  radius: (radius + 70) ?? 160.0,
                  lineWidth: 10.0,
                  animation: true,
                  percent: 0.75,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.white,
                  progressColor: Color(0xff2DB3C1),
                  curve: Curves.easeOut,
                ),
              ),
          ],
        ),
        Text(
          user.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff26315F),
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          children: [
            Image.asset(
              "assets/blue_pin.png",
              scale: 4,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              user.branchName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff3FC1C9),
                fontWeight: FontWeight.w300,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        )
      ],
    );
  }
}
