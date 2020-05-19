import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/models/feed-item.dart';
import 'package:yorglass_ik/models/feed-type.dart';
import 'package:yorglass_ik/repositories/task-repository.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class FeedRepository {
  static final FeedRepository _instance = FeedRepository._privateConstructor();

  FeedRepository._privateConstructor();

  static FeedRepository get instance => _instance;
  Future<List<FeedItem>> getFeed() async {
    Results res = await DbConnection.query("SELECT * FROM feed WHERE id NOT IN (?) ORDER BY date, likecount DESC", [AuthenticationService.verifiedUser.deletedFeeds]);
    List<FeedItem> feedItemList = [];
    if (res.length > 0) {
      forEach(res, (element) {
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

  Future<FeedItem> getFeedItem(String id) async {
    Results res = await DbConnection.query("SELECT * FROM feed WHERE id = ?", [id]);
    FeedItem feed;
    if (res.length > 0) {
      feed = FeedItem(
        id: res.single[0],
        title: res.single[1],
        description: res.single[2].toString(),
        date: res.single[3],
        likeCount: res.single[4],
        itemType: res.single[5],
        imageId: res.single[6],
        url: res.single[7],
      );
    }
    return feed;
  }

  Future<List<FeedType>> getFeedTypes() async {
    Results res = await DbConnection.query("SELECT * FROM feedtype");
    List<FeedType> feedTypeList = [];
    if (res.length > 0) {
      forEach(res, (element) {
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

  Future<bool> changeLike(String id) async {
    if (AuthenticationService.verifiedUser.likedFeeds.contains(id)) {
      Results res = await DbConnection.query('DELETE FROM feedaction WHERE userid = ? AND feedid = ?', [AuthenticationService.verifiedUser.id, id]);
      if (res.affectedRows > 0) {
        AuthenticationService.verifiedUser.likedFeeds.remove(id);
        Results res = await DbConnection.query('UPDATE feed SET likecount = likecount - 1 WHERE id = ?', [id]);
        if (res.affectedRows > 0) {
          return true;
        }
      }
    } else {
      Results res = await DbConnection.query('INSERT INTO feedaction (userid, feedid, operation) VALUES (?, ?, ?)', [AuthenticationService.verifiedUser.id, id, 1]);
      if (res.affectedRows > 0) {
        AuthenticationService.verifiedUser.likedFeeds.add(id);
        Results res = await DbConnection.query('UPDATE feed SET likecount = likecount + 1 WHERE id = ?', [id]);
        if (res.affectedRows > 0) {
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> deleteFeed(String id) async {
    if (AuthenticationService.verifiedUser.likedFeeds.contains(id)) {
      await changeLike(id);
    }
    Results res = await DbConnection.query('INSERT INTO feedaction (userid, feedid, operation) VALUES (?, ?, ?)', [AuthenticationService.verifiedUser.id, id, 0]);
    if (res.affectedRows > 0) {
      AuthenticationService.verifiedUser.deletedFeeds.add(id);
    }
    return true;
  }
}
