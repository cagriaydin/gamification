import 'dart:convert';

import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/models/image.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class ImageRepository {
  static final ImageRepository _instance =
      ImageRepository._privateConstructor();

  ImageRepository._privateConstructor();

  static ImageRepository get instance => _instance;
  Map<String, Image> storedImage = {};

  Future<Image> getImage(String id) async {
    try {
      print('id : ' + id);
      print('id contains: ' + storedImage.containsKey(id).toString());
      if (!storedImage.containsKey(id)) {
        Results res =
            await DbConnection.query('SELECT * FROM images WHERE id = ?', [id]);
        if (res.length > 0) {
          Image data = Image(
              id: res.single[0],
              base64: res.single[4].toString(),
              code: res.single[1],
              base64Prefix: res.single[3],
              suffix: res.single[2],
              alt: res.single[5]);
          data.decodedImage = Base64Codec().decode(data.base64);
          storedImage[data.id] = data;
        }
      }
      print('storage id : ' + storedImage[id].base64);
      return storedImage[id];
    } catch (e) {
      print(e);
    }
  }

  Future<String> getImage64(String id) async {
    if (!storedImage.containsKey(id)) {
      Results res =
          await DbConnection.query('SELECT * FROM images WHERE id = ?', [id]);
      if (res.length > 0) {
        Image data = Image(
            id: res.single[0],
            base64: res.single[4].toString(),
            code: res.single[1],
            base64Prefix: res.single[3],
            suffix: res.single[2],
            alt: res.single[5]);
        storedImage[data.id] = data;
      }
    }
    return storedImage[id].base64;
  }
}
