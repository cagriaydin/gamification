import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user-reward.dart';
import 'package:yorglass_ik/pages/reward_detail.dart';
import 'package:yorglass_ik/repositories/reward-repository.dart';
import 'package:yorglass_ik/widgets/reward_cards2.dart';

class RewardSliderOne extends StatelessWidget {
  final double height;

  const RewardSliderOne({Key key, @required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: FutureBuilder(
        future: RewardRepository.instance
            .getRewards(type: "65bc7f54-049a-4a1a-93e5-6361e78e959c"),
        builder: (BuildContext context, AsyncSnapshot<List<Reward>> snapshot) {
          if (snapshot.hasData) {
            return Swiper(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    return Navigator.push(context,
                        MaterialPageRoute(builder: (_) {
                      final provider = Provider.of<UserReward>(context);
                      return ChangeNotifierProvider.value(
                        value: provider,
                        child: RewardDetail(
                          reward: snapshot.data[index],
                        ),
                      );
                    }));
                  },
                  child: SizedBox(
                    height: height - 100,
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
      ),
    );
  }
}
