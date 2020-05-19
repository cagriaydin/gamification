import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:yorglass_ik/repositories/image-repository.dart';

class Reward {
  final String id;
  final String title;
  final String imageId;
  Completer<Uint8List> image64 = Completer();
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
  }){
    setImage64();
  }

  setImage64() async {
    final currentBase64 = await ImageRepository.instance.getImage64(this.imageId);
    Uint8List decoded = base64.decode(currentBase64);
    image64.complete(decoded);
  }
}
