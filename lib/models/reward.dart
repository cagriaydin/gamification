enum RewardType { forPeople, forAnimals, forSelf }

class Reward {
  final String id;
  final String title;

  final String imageId;
  final int point;
  final String itemType;

  final int likeCount;

  Reward({
    this.id,
    this.title,
    this.imageId,
    this.point,
    this.likeCount = 112,
    this.itemType,
  });
}
