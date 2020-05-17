// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';

ImageModel imageModelFromJson(String str) => ImageModel.fromJson(json.decode(str));

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
    int id;
    String image64;

    ImageModel({
        this.id,
        this.image64,
    });

    factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json["id"],
        image64: json["image64"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image64": image64,
    };
}



// {
//   "id": 1,
//   "image64": "Title"
// }

