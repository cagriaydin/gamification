import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:yorglass_ik/models/user.dart';

class BuildCircularPercentage extends StatelessWidget {
  const BuildCircularPercentage({
    Key key,
    @required this.radius,
  }) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    final percentage = context.select((User value) => value.percentage);
    return CircularPercentIndicator(
      radius: (radius + 80) ?? 160.0,
      lineWidth: 10.0,
      animation: true,
      percent: (percentage ?? 0) * 1 / 100,
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: Colors.white,
      progressColor: Color(0xff2DB3C1),
      curve: Curves.easeOut,
    );
  }
}
