import 'package:meta/meta.dart';

import 'package:yorglass_ik/models/reward.dart';

class UserReward {
    int point;
    List<Reward> rewards;
    List<String> liked;

    UserReward({
        @required this.point,
        @required this.rewards,
        @required this.liked,
    });
}
