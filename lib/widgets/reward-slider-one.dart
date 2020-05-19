import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yorglass_ik/repositories/reward-repository.dart';
import 'package:yorglass_ik/widgets/flag_avatar.dart';
import 'package:yorglass_ik/widgets/reward_cards.dart';
import 'package:yorglass_ik/widgets/reward_cards2.dart';

import 'image_widget.dart';

class RewardSliderOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 200,
          child: Container(
            child: FutureBuilder(
              future: rewardList[index].image64.future,
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                if (snapshot.hasData) {
                  // return Image.memory(snapshot.data);
                  return RewardCards2(
                    reward: rewardList[index],
                    decodedImage: snapshot.data,
                  );
                } else
                  return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        );
      },
      itemCount: rewardList.length,
      itemWidth: 200,
      pagination: new SwiperPagination(builder: SwiperPagination.rect),
      layout: SwiperLayout.STACK,
    );
  }
}
