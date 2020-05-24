import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yorglass_ik/models/user.dart';

import 'gradient_text.dart';

class UserPercentage extends StatelessWidget {
  const UserPercentage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final selectPercentage = context.select((User value) => value.percentage);
    return GradientText(
      '%' + (selectPercentage ?? 0).toString(),
      fontSize: size.width < 400 ? 25 : 30,
      fontWeight: FontWeight.w500,
    );
  }
}
