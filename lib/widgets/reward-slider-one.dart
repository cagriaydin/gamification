import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/pages/reward_detail.dart';
import 'package:yorglass_ik/repositories/reward-repository.dart';
import 'package:yorglass_ik/widgets/reward_cards2.dart';

class RewardSliderOne extends StatelessWidget {
  final ValueNotifier currentPoint;

  const RewardSliderOne({Key key, this.currentPoint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RewardRepository.instance.getRewards(),
      builder: (BuildContext context, AsyncSnapshot<List<Reward>> snapshot) {
        if (snapshot.hasData) {
          return Swiper(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  return Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return RewardDetail(
                      reward: snapshot.data[index],
                      currentPoint: currentPoint.value,
                    );
                  }));
                },
                child: SizedBox(
                  height: 150,
                  child: Container(
                    child: RewardCards2(
                      reward: snapshot.data[index],
                    ),
                  ),
                ),
              );
            },
            itemCount: snapshot.data.length,
            itemWidth: 200,
            itemHeight: 250,
            pagination: new SwiperPagination(builder: SwiperPagination.rect),
            layout: SwiperLayout.STACK,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
