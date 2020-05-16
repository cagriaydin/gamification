import 'package:flutter/material.dart';

class PointBuilder extends StatelessWidget {
  final String point;

  PointBuilder({@required this.point});

  final color = Color(0xFF2FB4C2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "+ " + point,
          style: TextStyle(
            shadows: <Shadow>[
              Shadow(
                blurRadius: 10.0,
                color: color,
              )
            ],
            fontWeight: FontWeight.w500,
            fontSize: 40,
          ),
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
