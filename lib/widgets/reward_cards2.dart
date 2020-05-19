import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';

class RewardCards2 extends StatelessWidget {
  final Reward reward;

  const RewardCards2({Key key, this.reward});

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
        child: FutureBuilder(
          future: reward.image64.future,
          builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
            if (snapshot.hasData) {
              // return Image.memory(snapshot.data);
              return Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    FlagAvatar(
                      name: reward.title,
                      point: reward.point,
                      image64: snapshot.data,
                      titleColor: Color(0xff26315F),
                    ),
                  ]);
            } else
              return Center(child: CircularProgressIndicator());
          },
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
