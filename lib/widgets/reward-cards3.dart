import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/widgets/flag_point.dart';

class RewardCards3 extends StatelessWidget {
  final Reward reward;

  const RewardCards3({Key key, @required this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
          // gradient: getGradient(),
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
                        child: FutureBuilder(
                          future: reward.image64.future,
                          builder: (BuildContext context,
                              AsyncSnapshot<Uint8List> snapshot) {
                            if (snapshot.hasData) {
                              // return Image.memory(snapshot.data);
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.memory(snapshot.data),
                              );
                            } else
                              return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(reward.title),
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
                point: reward.point,
              ),
            ),
            Positioned(
              right: -30,
              bottom: 100,
              child: Transform.rotate(
                angle: 270 * pi / 180,
                child: LinearPercentIndicator(
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  width: 140.0,
                  lineHeight: 14.0,
                  percent: reward.point / 700 > 1.0 ? 1.0 : reward.point / 700,
                  backgroundColor: Colors.black12,
                  
                  linearGradient: LinearGradient(
                    colors: [Color(0xFFABF3F8),Color(0xFF80CEDF),],
                  ),
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
