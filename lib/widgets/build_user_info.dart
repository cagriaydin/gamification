import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:yorglass_ik/models/user.dart';

class BuildUserInfo extends StatelessWidget {
  const BuildUserInfo({
    Key key,
    this.isTaskPage = false,
    @required this.user,
    this.radius,
    this.showPercentage = false,
  }) : super(key: key);

  final bool isTaskPage;
  final User user;
  final double radius;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: size.height < 600 ? 8 : 36,
        ),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircleAvatar(
                radius: radius ?? 70,
                backgroundImage: user.image == null
                    ? AssetImage("assets/default-profile.png")
                    : MemoryImage(base64.decode(user.image)),
              ),
            ),
            if (showPercentage)
              Positioned.fill(
                child: CircularPercentIndicator(
                  radius: (radius + 80) ?? 160.0,
                  lineWidth: 10.0,
                  animation: true,
                  percent: (user.percentage ?? 0) * 1 / 100,
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
              fontSize: 24),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          children: [
            Image.asset(
              isTaskPage ? "assets/darkblue_pin.png" : "assets/blue_pin.png",
              scale: isTaskPage ? 5 : 4,
            ),
            SizedBox(
              width: 8,
            ),
            Tooltip(
              message: user.branchName,
              child: Text(
                user.branchName.length > 20
                    ? user.branchName.substring(0, 20) + '...'
                    : user.branchName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isTaskPage ? 15 : 18,
                  fontWeight: isTaskPage ? FontWeight.w200 : FontWeight.w400,
                  color: isTaskPage
                      ? Color(0xFF26315F)
                      : Color(0xff4BADBB).withOpacity(.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )
      ],
    );
  }
}
