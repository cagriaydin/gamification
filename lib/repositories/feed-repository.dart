import 'dart:async';

import 'package:mysql1/mysql1.dart';
import 'package:rxdart/subjects.dart';
import 'package:yorglass_ik/models/feed-item.dart';
import 'package:yorglass_ik/models/feed-type.dart';
import 'package:yorglass_ik/repositories/dio_repository.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class FeedRepository {
  static final FeedRepository _instance = FeedRepository._privateConstructor();

  FeedRepository._privateConstructor() {
    getFeed();
  }

  static FeedRepository get instance => _instance;

  StreamController<List<FeedItem>> _feedList = BehaviorSubject();

  Stream get currentFeeds => _feedList.stream;

  Future<List<FeedItem>> getFeed() async {
    final res = await RestApi.instance.dio.get('/feed/getAllFeed');
    List<FeedItem> feedItemList = [];
    if (res.statusCode == 200) {
      var list = feedItemListFromJson(res.data);
      feedItemList.addAll(list);
      _feedList.add(feedItemList);
    }

    return feedItemList;
  }

  Future<FeedItem> getFeedItem(String id) async {
    var future = await RestApi.instance.dio.get('/feed/byId/$id');
    FeedItem feed;
    if (future.statusCode == 200) {
      feed = feedItemFromJson(future.data);
    }
    return feed;
  }

  Future<List<FeedType>> getFeedTypes() async {
    final res = await RestApi.instance.dio.get('/feed_type/getAllFeedTypes');
    List<FeedType> feedTypeList = [];
    if (res.statusCode == 200) {
      final list = feedTypeListFromJson(res.data);
      feedTypeList.addAll(list);
    }
    return feedTypeList;
  }

  Future<bool> changeLike(String id) async {
    if (!AuthenticationService.verifiedUser.likedFeeds.contains(id)) {
      var future = await RestApi.instance.dio.get('/feed_action/delete?userId=${AuthenticationService.verifiedUser.id}&feedId=$id');
      if (future.statusCode == 200) {
        var updateLike = await RestApi.instance.dio.get('/feed/updateLikeCount?id=$id&value=-1');
        return updateLike.statusCode == 200;
      }
    } else {
      var future = await RestApi.instance.dio.get('/feed_action/add?userId=${AuthenticationService.verifiedUser.id}&feedId=$id&operation=1');
      if (future.statusCode == 200) {
        var updateLike = await RestApi.instance.dio.get('/feed/updateLikeCount?id=$id&value=1');
        return updateLike.statusCode == 200;
      }
    }
    return false;
  }

  Future<bool> deleteFeed(String id) async {
    if (AuthenticationService.verifiedUser.likedFeeds.contains(id)) {
      await changeLike(id);
    }
    var future = await RestApi.instance.dio.get('/feed_action/add?userId=${AuthenticationService.verifiedUser.id}&feedId=$id&operation=0');
    if (future.statusCode == 200) {
      AuthenticationService.verifiedUser.deletedFeeds.add(id);
    }
    getFeed();
    return true;
  }
}
