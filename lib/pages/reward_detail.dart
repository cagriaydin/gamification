import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/widgets/image_widget.dart';

class RewardDetail extends StatelessWidget {
  Reward reward;
  RewardDetail({this.reward});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          child: Container(
            width: size.width,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: ImageWidget(
                id: null,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                border: Border.all(color: Colors.white),
                color: Colors.white),
            height: size.height,
            child: Column(
              children: <Widget>[],
            ),
          ),
        )
      ],
    );
  }
}
