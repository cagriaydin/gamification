import 'package:flutter/material.dart';
import 'package:yorglass_ik/widgets/gradient_text.dart';

class PointBuilder extends StatelessWidget {
  final String point;

  PointBuilder({@required this.point});

  final color = Color(0xFF2FB4C2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GradientText(
          "+ " + point,
          fontSize: 40,
        ),
        Text(
          "puan",
          style: TextStyle(
            shadows: <Shadow>[
              Shadow(
                blurRadius: 10.0,
                color: color,
              )
            ],
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        )
      ],
    );
  }
}
