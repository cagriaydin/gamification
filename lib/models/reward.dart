enum RewardType {forPeople, forAnimals, forSelf}

class Reward {
  final String imageId;
  final int point;
  RewardType type;

  final int likeCount;

  Reward({this.imageId, this.point, this.likeCount = 112, this.type});
}
