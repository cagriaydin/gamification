import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/widgets/gradient_text.dart';

class UserPoint extends StatelessWidget {
  const UserPoint({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
    var selectUserPoint = context.select((User value) => value.point);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GradientText(
          (selectUserPoint ?? 0).toString(),
          fontWeight: FontWeight.w500,
          fontSize: size.width < 400 ? 23 : 28,
        ),
        Text(
          'puan',
          style: TextStyle(
              fontSize: size.width < 400 ? 15 : 18,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
