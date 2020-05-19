import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';
import 'package:yorglass_ik/widgets/reward_cards.dart';

class RewardCards2 extends StatefulWidget {
  final Reward reward;
  final Uint8List decodedImage;
  const RewardCards2({Key key, this.reward, this.decodedImage})
      : super(key: key);
  @override
  _RewardCards2State createState() => _RewardCards2State();
}

class _RewardCards2State extends State<RewardCards2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
          gradient: getGradient(),
          boxShadow: [
            BoxShadow(
              offset: Offset(-2, 2),
              spreadRadius: 1,
              blurRadius: 2,
              color: const Color(0xff1A8EA7).withOpacity(.2),
            ),
          ],
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
                  children: <Widget> [FlagAvatar(
            name: widget.reward.title,
            point: widget.reward.point,
            image64: widget.decodedImage,
            titleColor: Color(0xff26315F),
          ),]
        ),
      ),
    );
  }
}

LinearGradient getGradient({
  Color firstColor = Colors.white,
  Color lastColor = const Color(0xff80CEDF),
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
