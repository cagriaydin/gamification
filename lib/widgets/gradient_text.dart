import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool disabled;
  final FontWeight fontWeight;

  const GradientText(
    this.text, {
    Key key,
    this.fontSize = 35,
    this.disabled = false,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: <Color>[
           Color(0xff2FB4C2),
            Color(0xff2FB4C2),
            Color(0xff26315F).withOpacity(.7),
            Color(0xff26315F).withOpacity(.7) 
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: fontWeight ?? FontWeight.w500,
          shadows: <Shadow>[
            Shadow(
              blurRadius: 5.0,
              offset: Offset(1, 1),
              color: Color(0xff2FB4C2),
            ),
          ],
        ),
      ),
    );
  }
}
