import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yorglass_ik/repositories/reward-repository.dart';

import 'image_widget.dart';

class RewardSliderOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Swiper(
          itemBuilder: (BuildContext context, int index) {
            return new ImageWidget(
                      id: rewardList[index].imageId,
                    );
          },
          autoplay: true,
          itemCount: rewardList.length,
          itemWidth: 200,
          pagination: new SwiperPagination(),
          control: new SwiperControl(),
          layout: SwiperLayout.STACK,
        );
  }
}
