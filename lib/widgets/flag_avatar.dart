import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:yorglass_ik/widgets/flag_point.dart';
import 'package:yorglass_ik/widgets/get_circle_avatar.dart';

class FlagAvatar extends StatelessWidget {
  final String imageId;
  final Uint8List image64;
  final int point;
  final int rank;
  final String name;
  final String branchName;
  final Color titleColor;
  final bool split;

  final double radius;

  final bool isLeaderBoard;

  final int rewardPoint;
  final int userActivePoint;

  final Widget centerWidget;

  const FlagAvatar(
      {Key key,
      this.imageId,
      this.point,
      this.rank,
      this.name,
      this.image64,
      this.titleColor,
      this.branchName,
      this.split = true,
      this.radius,
      this.isLeaderBoard = false,
      this.rewardPoint,
      this.userActivePoint,
      this.centerWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          if (name.isNotEmpty)
              Tooltip(
                message: name,
                child: Text(
                  split
                      ? name.length > 10 ? name.split(" ").join("\n") : name
                      : name.length > 20
                          ? name.substring(
                                  0, name.length > 15 ? 15 : name.length) +
                              '...'
                          : name,
                  style: TextStyle(
                    color: titleColor == null ? Colors.white : titleColor,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          if (branchName != null)
            SizedBox(
              height: 10,
            ),
          if (branchName != null)
            Row(
              children: [
                Image.asset(
                  "assets/white_pin.png",
                  width: 12,
                ),
                SizedBox(
                  width: 8,
                ),
                Tooltip(
                  message: branchName,
                  child: Text(
                    branchName.length > 10
                        ? branchName.substring(0, 10) + '...'
                        : branchName,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (point != null)
                Transform.scale(
                    alignment: Alignment.bottomCenter,
                    scale: isLeaderBoard ? .9 : .7,
                    child: FlagPoint(point: point)),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: isLeaderBoard
                        ? const EdgeInsets.fromLTRB(8, 20, 8, 70)
                        : const EdgeInsets.fromLTRB(8, 20, 8, 40),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Material(
                          elevation: 5,
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(90)),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: GetCircleAvatar(
                              radius: radius ?? getRadius(size),
                              imageId: imageId,
                            ),
                          ),
                        ),
                        if (userActivePoint != null && rewardPoint != null)
                          CircularPercentIndicator(
                            radius: (radius ?? getRadius(size)) * 2.2,
                            lineWidth: 7.0,
                            circularStrokeCap: CircularStrokeCap.round,
                            percent: userActivePoint / rewardPoint > 1.0
                                ? 1.0
                                : userActivePoint / rewardPoint,
                            center: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              width: double.infinity,
                              height: double.infinity,
                              child: Center(
                                child: CustomPaint(
                                  painter: CircleBlurPainter(
                                      circleWidth: radius ?? getRadius(size),
                                      blurSigma: 3.0),
                                  child: centerWidget ??
                                      IconShadowWidget(
                                        Icon(
                                          userActivePoint < rewardPoint
                                              ? Icons.lock
                                              : Icons.lock_open,
                                          color: Colors.white,
                                          size: 36,
                                        ),
                                        shadowColor:
                                            Colors.lightBlueAccent.shade100,
                                      ),
                                ),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            linearGradient: LinearGradient(
                              colors: [
                                Color(0xff1A8EA7),
                                Colors.white,
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (rank == 1)
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 85,
                      ),
                      child: Image.asset(
                        'assets/crown.png',
                        scale: 1,
                      ),
                    ),
                  if (rank != null)
                    Positioned(
                      right: name.isNotEmpty ? getRadius(size) / 5 : 8,
                      top: name.isNotEmpty ? getRadius(size) / 5 : 6,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(rank.toString()),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xff26315F),
                                  blurRadius: 2,
                                  offset: Offset(0, 4)),
                              BoxShadow(
                                  color: Color(0xff2DB3C1),
                                  blurRadius: 2,
                                  offset: Offset(0, 2))
                            ]),
                      ),
                    )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  getImagePadding() {
    if (rank == 1 && name.isNotEmpty) {
      return EdgeInsets.fromLTRB(8, 74, 8, 64);
    }
    if ((rank == 2 || rank == 3) && name.isNotEmpty) {
      return EdgeInsets.fromLTRB(8, 74, 8, 44);
    }
    return EdgeInsets.fromLTRB(8, 8, 8, 64);
  }

//  Object backgroundImage() {
//    try {
//      return imageUrl == null
//          ? (image64 == null
//              ? AssetImage("assets/default-profile.png")
//              : MemoryImage(image64))
//          : MemoryImage(base64.decode(imageUrl));
//    } catch (e) {
//      print(e);
//      return AssetImage("assets/default-profile.png");
//    }
//  }

  double getRadius(size) {
    double currentSize = (size.height < 700 || size.width < 400) ? 90 : 70;
    if (rank == 1) {
      return currentSize - 20;
    } else if (rank == 2) {
      return currentSize - 30;
    } else {
      return currentSize - 40;
    }
  }

  double getScale() {
    if (rank == 1) {
      return 2;
    } else if (rank == 2) {
      return 2.3;
    } else {
      return 2.8;
    }
  }
}

class CircleBlurPainter extends CustomPainter {
  CircleBlurPainter({@required this.circleWidth, this.blurSigma});

  double circleWidth;
  double blurSigma;

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = new Offset(size.width / 2, size.height / 2);
    Paint line = new Paint()
      ..color = Colors.lightBlue.withOpacity(.3)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma)
      ..shader = LinearGradient(
        colors: <Color>[Colors.black, Colors.black54, Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCenter(
        center: center,
        width: circleWidth,
        height: circleWidth,
      ));
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
