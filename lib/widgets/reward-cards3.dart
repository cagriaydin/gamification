import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';
import 'package:yorglass_ik/widgets/flag_point.dart';
import 'package:yorglass_ik/widgets/reward_cards.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RewardCards3 extends StatefulWidget {
  final Reward reward;
  final Uint8List decodedImage;
  const RewardCards3({Key key, this.reward, this.decodedImage})
      : super(key: key);
  @override
  _RewardCards3State createState() => _RewardCards3State();
}

class _RewardCards3State extends State<RewardCards3> {
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
          children: <Widget>[
            Positioned(
              left: 20,
              top: 0,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 220,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.memory(widget.decodedImage),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.reward.title),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: FlagPoint(
                point: widget.reward.point,
              ),
            ),
            Positioned(
              right: -30,
              bottom: 100,
              child: Transform.rotate(
                angle: 90 * pi/180,
                child: LinearPercentIndicator(
                  width: 140.0,
                  lineHeight: 14.0,
                  percent: widget.reward.point / 350 > 1.0
                      ? 1.0
                      : widget.reward.point / 350,
                  backgroundColor: Colors.grey,
                  progressColor: Colors.blue,
                ),
              ),
            ),
            // FlagAvatar(
            //   name: widget.reward.title,
            //   point: widget.reward.point,
            //   image64: widget.decodedImage,
            //   titleColor: Color(0xff26315F),
            // ),
          ],
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
