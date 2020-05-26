import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:yorglass_ik/models/buyed-reward.dart';

class UserReward extends ChangeNotifier {
  int point;
  List<BuyedReward> rewards;
  List<String> liked;

  UserReward({
    @required this.point,
    @required this.rewards,
    @required this.liked,
  });

  update({
    int point,
    List<BuyedReward> rewards,
    List<String> liked,
  }) {
    this.point = point ?? this.point;
    this.rewards = rewards ?? this.rewards;
    this.liked = liked ?? this.liked;
    notifyListeners();
  }

  UserReward copyWith({
    int point,
    List<BuyedReward> rewards,
    List<String> liked,
  }) {
    return new UserReward(
      point: point ?? this.point,
      rewards: rewards ?? this.rewards,
      liked: liked ?? this.liked,
    );
  }

  void addReward(BuyedReward buyedReward) {
    rewards.add(buyedReward);
    notifyListeners();
  }
}
