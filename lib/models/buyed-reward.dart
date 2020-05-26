import 'package:yorglass_ik/models/reward.dart';

class BuyedReward extends Reward {
  final DateTime buyDate;
  final int status;

  BuyedReward({
    String id,
    String title,
    String imageId,
    int point,
    int likeCount,
    String itemType,
    this.buyDate,
    this.status,
  }) : super(
          id: id,
          title: title,
          imageId: imageId,
          point: point,
          likeCount: likeCount,
          itemType: itemType,
        );
}
