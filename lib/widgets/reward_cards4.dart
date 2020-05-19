import 'dart:typed_data';

import 'package:flutter/material.dart';
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
            FutureBuilder(
              future: widget.reward.image64.future,
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                if (snapshot.hasData) {
                  return FlagAvatar(
                    name: widget.reward.title,
                    point: widget.reward.point,
                    image64: snapshot.data,
                    titleColor: Color(0xff26315F),
                  );
                } else
                  return Center(child: CircularProgressIndicator());
              },
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
