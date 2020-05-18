import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/models/feed-item.dart';
import 'package:yorglass_ik/models/feed-type.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class FeedRepository {
  static final FeedRepository _instance = FeedRepository._privateConstructor();

  FeedRepository._privateConstructor();

  static FeedRepository get instance => _instance;
  Future<List<FeedItem>> getFeed() async {
    Results res = await DbConnection.query("SELECT * FROM feed WHERE id NOT IN (?)", [AuthenticationService.verifiedUser.deletedFeeds]);
    List<FeedItem> feedItemList = [];
    if (res.length > 0) {
      res.forEach((element) {
        feedItemList.add(
          FeedItem(
            id: element[0],
            title: element[1],
            description: element[2].toString(),
            date: element[3],
            likeCount: element[4],
            itemType: element[5],
            imageId: element[6],
            url: element[7],
          ),
        );
      });
    }
    return feedItemList;
  }

  Future<List<FeedType>> getFeedTypes() async {
    Results res = await DbConnection.query("SELECT * FROM feedtype");
    List<FeedType> feedTypeList = [];
    if (res.length > 0) {
      res.forEach((element) {
        feedTypeList.add(
          FeedType(
            id: element[0],
            title: element[1],
          ),
        );
      });
    }
    return feedTypeList;
  }
}
