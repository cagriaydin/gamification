import 'package:meta/meta.dart';
import 'package:yorglass_ik/models/buyed-reward.dart';

class UserReward {
    int point;
    List<BuyedReward> rewards;
    List<String> liked;

    UserReward({
        @required this.point,
        @required this.rewards,
        @required this.liked,
    });
}
