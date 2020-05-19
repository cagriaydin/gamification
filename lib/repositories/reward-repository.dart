import 'package:yorglass_ik/models/reward.dart';

class RewardRepository {
  static final RewardRepository _instance =
      RewardRepository._privateConstructor();

  RewardRepository._privateConstructor();

  static RewardRepository get instance => _instance;

  Future<List<Reward>> getRewards({int type}) async {
    if (type == null) {
      type = RewardType.forAnimals.index;
    }
    List<Reward> rewardItemList = [];
    await Future.delayed(Duration(milliseconds: 300));
    rewardItemList = _rewardList;
    return rewardItemList;
  }

  Future<Reward> getRewardItem(String id) async {
    Reward reward;
    return reward;
  }

  Future<List<RewardType>> getRewardTypes() async {}
}

//"c9a560ac-63f2-401b-8185-2bae139957ad"
List<Reward> _rewardList = [
  Reward(
    id: "1",
    imageId: "c9a560ac-63f2-401b-8185-2bae139957ad",
    itemType: "forAnimals",
    title: "Dostlarımıza Mama",
    point: 400,
  ),
  Reward(
    id: "2",
    imageId: "c9a560ac-63f2-401b-8185-2bae139957ad",
    itemType: "forAnimals",
    title: "Dostlarımıza Mama",
    point: 400,
  ),
  Reward(
    id: "3",
    imageId: "c9a560ac-63f2-401b-8185-2bae139957ad",
    itemType: "forPeople",
    title: "Adına Fidan Dikiyoruz",
    point: 350,
  ),
  Reward(
    id: "4",
    imageId: "c9a560ac-63f2-401b-8185-2bae139957ad",
    itemType: "forSelf",
    title: "Spotify Üyelik",
    point: 1400,
  ),
  Reward(
    id: "5",
    imageId: "c9a560ac-63f2-401b-8185-2bae139957ad",
    itemType: "forSelf",
    title: "Spotify Üyelik",
    point: 1400,
  ),
  Reward(
    id: "6",
    imageId: "c9a560ac-63f2-401b-8185-2bae139957ad",
    itemType: "forSelf",
    title: "Spotify Üyelik",
    point: 1400,
  ),
];
