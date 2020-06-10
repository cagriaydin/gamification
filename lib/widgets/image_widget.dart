import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/image.dart' as image;
import 'package:yorglass_ik/repositories/image-repository.dart';

enum ImageType { image, imageProvider }

class ImageWidget extends StatelessWidget {
  final String id;
  final ImageType imageType;

  final BorderRadius borderRadius;

  ImageWidget({
    this.id,
    this.imageType = ImageType.image,
    this.borderRadius = const BorderRadius.all(Radius.circular(90)),
  });

  @override
  Widget build(BuildContext context) {
    final defaultImage = ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          'assets/default-profile.png',
          gaplessPlayback: true,
        ));

    return FutureBuilder(
      future: ImageRepository.instance.getImage(id),
      builder: (BuildContext context, AsyncSnapshot<image.Image> snapshot) {
        if (ImageRepository.instance.containsKey(id)) {
          return ClipRRect(
            borderRadius: borderRadius,
            child: Image.memory(
              ImageRepository.instance.storedImage[id].decodedImage,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
//            return Center(child: CircularProgressIndicator(),);
            return defaultImage;
          case ConnectionState.active:
          case ConnectionState.done:
            try {
              if (snapshot.data.decodedImage != null) {
                return ClipRRect(
                  borderRadius: borderRadius,
                  child: snapshot.data.base64 == null
                      ? Image.asset("assets/default-profile.png")
                      : Image.memory(
                          snapshot.data.decodedImage,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ),
                );
              } else {
                return defaultImage;
              }
            } catch (e) {
              return defaultImage;
            }
            break;
          default:
            return defaultImage;
        }
      },
    );
  }
}
