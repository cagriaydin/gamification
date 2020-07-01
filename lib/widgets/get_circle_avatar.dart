import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/image.dart' as image;
import 'package:yorglass_ik/repositories/image-repository.dart';

class GetCircleAvatar extends StatelessWidget {
  const GetCircleAvatar({
    Key key,
    @required this.imageId,
    @required this.radius,
    this.fit,
  }) : super(key: key);

  final String imageId;
  final double radius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final circleAvatarWidget = FutureBuilder(
      future: ImageRepository.instance.getImage(imageId),
      builder: (BuildContext context, AsyncSnapshot<image.Image> snapshot) {
        if (ImageRepository.instance.containsKey(imageId)) {
          return CircleAvatar(
            radius: radius ?? 70,
            backgroundImage: MemoryImage(
              ImageRepository.instance.storedImage[imageId].decodedImage,
            ),
          );
        }
        if (snapshot.hasData) {
          try {
            return CircleAvatar(
              radius: radius ?? 70,
              backgroundImage: imageId == null
                  ? AssetImage("assets/default-profile.png")
                  : MemoryImage(snapshot.data.decodedImage),
            );
          } catch (e) {
            return CircleAvatar(
              radius: radius ?? 40,
              backgroundImage: AssetImage("assets/default-profile.png"),
            );
          }
        } else {
          return CircleAvatar(
            radius: radius ?? 40,
            backgroundImage: AssetImage("assets/default-profile.png"),
          );
        }
      },
    );
    if (fit != null) {
      return FittedBox(
        fit: BoxFit.fitWidth,
        child: circleAvatarWidget,
      );
    } else {
      return circleAvatarWidget;
    }
  }
}
