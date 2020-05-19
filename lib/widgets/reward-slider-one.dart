import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yorglass_ik/repositories/reward-repository.dart';
import 'package:yorglass_ik/widgets/reward_cards2.dart';

class RewardSliderOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 200,
          child: Container(
            child: RewardCards2(
              reward: rewardList[index],
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
