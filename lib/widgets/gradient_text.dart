import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;

  const GradientText(
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
        foreground: Paint()
          ..shader = LinearGradient(
            colors: <Color>[
              Color(0xff2FB4C2),
              Color(0xff2FB4C2),
              Color(0xff2FB4C2),
              Color(0xff26315F),
              Color(0xff26315F),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          ).createShader(Rect.fromLTWH(
            0.0,
            0.0,
            300.0,
            300.0,
          )),
      ),
    );
  }
}
