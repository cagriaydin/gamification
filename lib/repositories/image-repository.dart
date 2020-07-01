import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:yorglass_ik/models/image.dart';
import 'package:yorglass_ik/repositories/dio_repository.dart';

class ImageRepository {
  static final ImageRepository _instance =
      ImageRepository._privateConstructor();

  ImageRepository._privateConstructor();

  static ImageRepository get instance => _instance;
  Map<String, Image> storedImage = {};

  Future<Image> getImage(String id) async {
    try {
      if (containsKey(id)) {
        return storedImage[id];
      } else {
        Image image;
        Response imageRes =
            await RestApi.instance.dio.get('/image/getImageById?id=' + id);

        if (imageRes.data != null) {
          image = Image.fromMap(imageRes.data);
          image.decodedImage = Base64Codec().decode(image.base64);
          storedImage[image.id] = image;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  bool containsKey(String id) => storedImage.containsKey(id);

  Future<String> getImage64(String id) async {
    if (!containsKey(id)) {
      Image image;
      Response imageRes =
          await RestApi.instance.dio.get('/image/getImageById?id=' + id);

      if (imageRes.data != null) {
        image = Image.fromMap(imageRes.data);
        storedImage[image.id] = image;
      }
    }
    return storedImage[id].base64;
  }
}
