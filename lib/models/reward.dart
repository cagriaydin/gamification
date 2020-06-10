import 'dart:async';
import 'dart:typed_data';

class Reward {
  final String id;
  final String title;
  final String imageId;
  Completer<Uint8List> image64 = Completer();
  final int point;
  final String itemType;
  int likeCount;

  Reward({
    this.id,
    this.title,
    this.imageId,
    this.point,
    this.likeCount = 112,
    this.itemType,
  });
}
