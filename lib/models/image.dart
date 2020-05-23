// To parse this JSON data, do
//
//     final image = imageFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

Image imageFromJson(String str) => Image.fromMap(json.decode(str));

String imageToJson(Image data) => json.encode(data.toMap());

class Image {
  String id;
  String base64;
  int code;
  String base64Prefix;
  String suffix;
  String alt;
  Uint8List decodedImage;

  Image({
    @required this.id,
    @required this.base64,
    @required this.code,
    @required this.base64Prefix,
    @required this.suffix,
    @required this.alt,
  });

  factory Image.fromMap(Map<String, dynamic> json) => Image(
        id: json["id"],
        base64: json["base64"],
        code: json["code"],
        base64Prefix: json["base64prefix"],
        suffix: json["suffix"],
        alt: json["alt"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "base64": base64,
        "code": code,
        "base64prefix": base64Prefix,
        "suffix": suffix,
        "alt": alt,
      };
}

// {
//     "id":"",
//     "base64": "",
//     "code": "",
//     "base64prefix": "",
//     "suffix": "",
//     "alt": ""
// }
