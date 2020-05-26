import 'dart:math';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:yorglass_ik/models/image.dart' as image;
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user-reward.dart';
import 'package:yorglass_ik/repositories/image-repository.dart';
import 'package:yorglass_ik/widgets/flag_point.dart';

import 'gradient_text.dart';

class RewardCards3 extends StatelessWidget {
  final Reward reward;

  const RewardCards3({Key key, @required this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final size = MediaQuery.of(context).size * pixelRatio;
    final point = context.select((UserReward userReward) => userReward.point);
    final containerHeight = (size.width * 16 / 9) / 3;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: containerHeight,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 13,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        child: FutureBuilder(
                          future:
                              ImageRepository.instance.getImage(reward.imageId),
                          builder: (BuildContext context,
                              AsyncSnapshot<image.Image> snapshot) {
                            if (snapshot.hasError) {
                              return ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(size.width / 25),
                                child:
                                    Image.asset('assets/default-profile.png'),
                              );
                            }
                            if (snapshot.hasData) {
                              // return Image.memory(snapshot.data);
                              return ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(containerHeight / 25),
                                child: Image.memory(snapshot.data.decodedImage),
                              );
                            } else
                              return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ),
                    Text(
                      reward.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FlagPoint(
                    point: reward.point,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GradientText(
                          (point ?? 0).toString(),
                          fontWeight: FontWeight.w500,
                          fontSize: size.width < 400 ? 23 : 28,
                          linearGradient: LinearGradient(
                            colors: [Color(0xFF26315F), Color(0xFF2FB4C2)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 29, 0),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: LinearPercentIndicator(
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              lineHeight: 12.0,
                              percent: point / reward.point > 1.0
                                  ? 1.0
                                  : point / reward.point,
                              backgroundColor: Colors.black12.withOpacity(0.05),
                              linearGradient: LinearGradient(
                                colors: [
                                  Color(0xFFABF3F8).withOpacity(0.5),
                                  Color(0xFF80CEDF),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
