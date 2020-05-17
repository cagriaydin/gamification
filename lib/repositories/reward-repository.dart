import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/models/reward.dart';

class RewardRepository {
  static final RewardRepository _instance = RewardRepository._privateConstructor();

  RewardRepository._privateConstructor();

  static RewardRepository get instance => _instance;
  Future<List<Reward>> getReward() async {
    List<Reward> rewardItemList = [];
    
    return rewardItemList;
  }

  Future<Reward> getRewardItem(String id) async {
    Reward reward;
    return reward;
  }

  Future<List<RewardType>> getRewardTypes() async {}

}
