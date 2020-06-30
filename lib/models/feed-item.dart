import 'dart:convert';

FeedItem feedItemFromJson(String str) => FeedItem.fromJson(json.decode(str));

String feedItemToJson(FeedItem data) => json.encode(data.toJson());

List<FeedItem> feedItemListFromJson(List<dynamic> listOfString) =>
    (listOfString).map((e) => FeedItem.fromJson(e)).toList();


class FeedItem {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  int likeCount;
  final String itemType;
  final String imageId;
  final String url;

  FeedItem({
    this.id,
    this.title,
    this.description,
    this.date,
    this.likeCount,
    this.itemType,
    this.imageId,
    this.url,
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) => FeedItem(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        date: json["date"] == null
            ? DateTime.now()
            : DateTime.tryParse(json["date"]),
        likeCount: json["likeCount"] ?? 0,
        itemType: json["type"],
        imageId: json["image"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "date": iso8601string(date),
        "likeCount": likeCount,
        "type": itemType,
        "image": imageId,
        "url": url,
      };

  String iso8601string(value) => value == null ? null : value.toIso8601String();
}

// {
//   "id": "Id",
//   "title": "Title",
//   "description": "Description",
//   "date": "05.02.2020",
//   "likeCount": 5,
//   "itemType": ["d","w","b2b"],
//   "imageId": 1,
//   "imageUrl": "url"
// }
// Image.memory(Base64Codec().decode(image64));
