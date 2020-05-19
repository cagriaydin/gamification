import 'package:flutter/material.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/widgets/gradient_text.dart';
import 'package:yorglass_ik/widgets/reward-slider-one.dart';
import 'package:yorglass_ik/widgets/reward-slider-two.dart';

class RewardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: ()=> Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              height: 125,
              width: size.width,
              padding: EdgeInsets.only(top: padding.top),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xff54B4BA),
                        offset: Offset(2, 3),
                        blurRadius: 4,
                        spreadRadius: 2)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      Flexible(
                          child: GradientText(
                              (AuthenticationService.verifiedUser.point ?? 0)
                                  .toString())),
                      Flexible(
                        child: GradientText(
                          'puan',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "İnsanlara Faydam Olsun",
                    style: TextStyle(color: Color(0xffAAAAAD), fontSize: 20),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: RewardSliderOne(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Şirin Hayvan Dostlarımıza",
                    style: TextStyle(color: Color(0xffAAAAAD), fontSize: 20),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: RewardSliderTwo(),
                ),
              ],
            ),
          ),
          // Flexible(
          //   child: RewardSliderOne(),
          // ),
          // GridView(
          //   semanticChildCount: 2,
          //   children: <Widget>[],
          // ),
        ],
      ),
    );
  }
}
