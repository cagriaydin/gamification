import 'package:yorglass_ik/models/feed-item.dart';
List<FeedItem> feedList = [
  FeedItem( id: "1", title: "Pilates Başlıyor!",description: "Saat 19.00’da Fusce scelerisque sed nisl rhoncus pulvinar.", imageId: 1,url: "http://www.google.com"),
    FeedItem(id:"2", title: "Pilates Başlıyor!",description: "Saat 19.00’da Fusce scelerisque sed nisl rhoncus pulvinar.", imageId: 1,),
];

List<FeedItem> getFeed(){
  return feedList;
}

removeFeed(String id){
  feedList.remove((x) => x.id == id);
}

likeFeed(String id){
  feedList.firstWhere((x) => x.id == id).likeCount++;
}
dislikeFeed(String id){
  feedList.firstWhere((x) => x.id == id).likeCount++;
}
