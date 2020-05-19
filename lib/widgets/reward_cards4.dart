import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/pages/reward_detail.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';
import 'package:yorglass_ik/widgets/reward_cards.dart';

class RewardCards4 extends StatefulWidget {
  final Reward reward;
  const RewardCards4({Key key, this.reward}) : super(key: key);
  @override
  _RewardCards4State createState() => _RewardCards4State();
}

class _RewardCards4State extends State<RewardCards4> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
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
              left: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.reward.title.length > 10 ? widget.reward.title.split(" ").join("\n") : widget.reward.title,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            FutureBuilder(
              future: widget.reward.image64.future,
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: FlagAvatar(
                    split: true,
                    name: "",
                    point: widget.reward.point,
                    titleColor: Color(0xff26315F),
                  ));
                }
                if (snapshot.hasData) {
                  return FlagAvatar(
                    name: "",
                    split: true,
                    point: widget.reward.point,
                    image64: snapshot.data,
                    titleColor: Color(0xff26315F),
                  );
                } else
                  return Center(child: CircularProgressIndicator());
              },
            ),
            Positioned(
              top: 70,
              child: new CircularPercentIndicator(
                radius: 90.0,
                lineWidth: 7.0,
                percent: widget.reward.point / 700 > 1.0
                    ? 1.0
                    : widget.reward.point / 700,
                center: IconShadowWidget(
                  Icon(
                    //user.point
                    widget.reward.point < 700 ? Icons.lock : Icons.lock_open,
                    color: Colors.white,
                    size: 36,
                  ),
                  shadowColor: Colors.lightBlueAccent.shade100,
                ),
                backgroundColor: Colors.black12,
                linearGradient: LinearGradient(
                  colors: [Colors.white, Color(0xff1A8EA7)],
                ),
              ),
            ),
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
