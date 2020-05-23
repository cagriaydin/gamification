import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/image.dart' as image;
import 'package:yorglass_ik/repositories/image-repository.dart';

class GetCircleAvatar extends StatelessWidget {
  const GetCircleAvatar({
    Key key,
    @required this.imageId,
    @required this.radius,
  }) : super(key: key);

  final String imageId;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ImageRepository.instance.getImage(imageId),
      builder: (BuildContext context, AsyncSnapshot<image.Image> snapshot) {
        if (snapshot.hasData) {
          try {
            return CircleAvatar(
              radius: radius ?? 70,
              backgroundImage: imageId == null
                  ? AssetImage("assets/default-profile.png")
                  : MemoryImage(snapshot.data.decodedImage),
            );
          } catch (e) {
            print(e);
            return CircleAvatar(
              radius: radius ?? 70,
              backgroundImage: AssetImage("assets/default-profile.png"),
            );
          }
        } else {
          return CircleAvatar(
            radius: radius ?? 70,
            backgroundImage: AssetImage("assets/default-profile.png"),
          );
        }
      },
    );
  }
}
