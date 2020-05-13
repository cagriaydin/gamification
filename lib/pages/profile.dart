import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/widgets/gradient_text.dart';

class ProfilePage extends StatelessWidget {
  final Function menuFunction;
  final User user;

  const ProfilePage({Key key, @required this.menuFunction, @required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => menuFunction(),
          child: Icon(
            Icons.menu,
            color: Color(0xff2DB3C1),
            size: 40,
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 2,
            child: BlurBackgroundImage(
              imageUrl: user.image,
              child: Column(
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GradientText('%75'),
                      UserInfo(user: user),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GradientText(user.point.toString()),
                          GradientText('puan'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              child: Text('below'),
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(user.image),
              ),
            ),
            Positioned.fill(
              child: CircularPercentIndicator(
                radius: 160.0,
                lineWidth: 10.0,
                animation: true,
                percent: 0.75,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.white,
                progressColor: Color(0xff2DB3C1),
                curve: Curves.easeOut,
              ),
            ),
          ],
        ),
        Text(
          user.name,
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Color(0xff26315F), fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            Image.asset(
              "assets/blue_pin.png",
              scale: 4,
            ),
            Text(
              user.branchName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xff3FC1C9), fontWeight: FontWeight.w300),
            ),
          ],
        )
      ],
    );
  }
}

class BlurBackgroundImage extends StatelessWidget {
  const BlurBackgroundImage({
    Key key,
    this.child,
    this.imageUrl,
  }) : super(key: key);

  final Widget child;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: .3,
          child: Image.network(
            imageUrl,
            fit: BoxFit.fill,
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(.3),
                  Colors.white.withOpacity(.1),
                  Colors.white.withOpacity(.3),
                ],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}