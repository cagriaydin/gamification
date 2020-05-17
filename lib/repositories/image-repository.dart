import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/models/image.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class ImageRepository {
  static final ImageRepository _instance = ImageRepository._privateConstructor();

  ImageRepository._privateConstructor();

  static ImageRepository get instance => _instance;
  Map<String, Image> storedImage = {};

  Future<Image> getImage(String id) async {
    if (!storedImage.containsKey(id)) {
      Results res = await DbConnection.query('SELECT * FROM images WHERE id = ?', [id]);
      if (res.length > 0) {
        Image data = Image(id: res.single[0], base64: res.single[4].toString(), code: res.single[1], base64Prefix: res.single[3], suffix: res.single[2], alt: res.single[5]);
        storedImage[data.id] = data;
      }
    }
    return storedImage[id];
  }
  
  Future<String> getImage64(String id) async {
    if (!storedImage.containsKey(id)) {
      Results res = await DbConnection.query('SELECT * FROM images WHERE id = ?', [id]);
      if (res.length > 0) {
        Image data = Image(id: res.single[0], base64: res.single[4].toString(), code: res.single[1], base64Prefix: res.single[3], suffix: res.single[2], alt: res.single[5]);
        storedImage[data.id] = data;
      }
    }
    return storedImage[id].base64;
  }
}
