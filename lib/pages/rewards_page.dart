import 'package:flutter/material.dart';
import 'package:yorglass_ik/widgets/reward-slider-one.dart';
import 'package:yorglass_ik/widgets/reward-slider-two.dart';

class RewardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "İnsanlara Faydam Olsun",
                style: TextStyle(color: Color(0xffAAAAAD),fontSize: 20),
                
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
                style: TextStyle(color: Color(0xffAAAAAD),fontSize: 20),
                
              ),
            ),
            Expanded(
              flex: 3,
              child: RewardSliderTwo(),
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
      ),
    );
  }
}
