import 'package:dio/dio.dart';
import 'package:yorglass_ik/models/branch.dart';
import 'package:yorglass_ik/models/feed-action.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/models/user_leader_board.dart';
import 'package:yorglass_ik/repositories/branch_repository.dart';
import 'package:yorglass_ik/repositories/dio_repository.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._privateConstructor();

  UserRepository._privateConstructor();

  static UserRepository get instance => _instance;

  Future<List<UserLeaderBoard>> getUserPointList(
      {int limit, int offset}) async {
    List<UserLeaderBoard> list = [];
    Response userLeaderBoardRes = await RestApi.instance.dio.get(
        '/leaderboard/getAllLeaderBoard' +
            (limit != null ? '?limit=' + limit.toString() : '') +
            (offset != null ? '&offset=' + offset.toString() : ''));
    if (userLeaderBoardRes.data != null) {
      list = leaderBoardListFromJson(userLeaderBoardRes.data);
    }
    return list;
  }

  Future<List<User>> getUserList({int limit, int offset}) async {
    List<Branch> bList = await BranchRepository.instance.getBranchList();

    List<User> list = [];
    Response userRes = await RestApi.instance.dio.get('/user/getAllUserList' +
        (limit != null ? '?limit=' + limit.toString() : '') +
        (offset != null ? '&offset=' + offset.toString() : ''));
    if (userRes.data != null) {
      list = userListFromJson(userRes.data);
      for (var item in list) {
        item.branchName =
            bList.firstWhere((element) => element.id == item.branch).name;
      }
    }
    return list;
  }

  Future<List<User>> getTopUserPointList() async {
    var userList = new List<User>();
    var userPointList = await getUserPointList(limit: 3, offset: 0);
    for (var user in userPointList) {
      userList.add(await getUser(user.userId));
      userList.last.point = user.point;
    }
    return userList;
  }

  Future<User> getUser(String id) async {
    User user;
    Response userRes =
        await RestApi.instance.dio.get('/user/getUserById?id=' + id);
    if (userRes != null) {
      user = User.fromJson(userRes.data);
    }
    return await _fillUser(user, false);
  }

  Future<User> fillUserWithRest(User user, bool detailed) async {
    if (user.id != null) {
      Branch b = await BranchRepository.instance.getBranch(user.branch);
      user.branchName = b.name;
      if (detailed) {
        Response feedActionRes = await RestApi.instance.dio
            .get('/feed_action/getAllFeedAction?userId=' + user.id);
        List<FeedAction> feedActionList = [];
        List<String> deletedFeeds = [];
        List<String> likedFeeds = [];
        if (feedActionRes != null) {
          feedActionList = feedActionListFromJson(feedActionRes.data);
          for (var feedAction in feedActionList) {
            if (feedAction.operation == 0) {
              deletedFeeds.add(feedAction.feedid);
            } else {
              likedFeeds.add(feedAction.feedid);
            }
          }
        }
        user.likedFeeds = likedFeeds;
        user.deletedFeeds = deletedFeeds;
      }
      return user;
    } else {
      return null;
    }
  }

  Future<User> _fillUser(User user, bool detailed) async {
    if (user != null) {
      Branch b = await BranchRepository.instance.getBranch(user.branch);
      user.branchName = b.name;
      if (detailed) {
        Response feedActionRes = await RestApi.instance.dio
            .get('/feed_action/getAllFeedAction?userId=' + user.id);
        List<FeedAction> feedActionList = [];
        List<String> deletedFeeds = [];
        List<String> likedFeeds = [];
        if (feedActionRes != null) {
          feedActionList = feedActionListFromJson(feedActionRes.data);
          for (var feedAction in feedActionList) {
            if (feedAction.operation == 0) {
              deletedFeeds.add(feedAction.feedid);
            } else {
              likedFeeds.add(feedAction.feedid);
            }
          }
        }
        user.likedFeeds = likedFeeds;
        user.deletedFeeds = deletedFeeds;
      }
      return user;
    } else {
      return null;
    }
  }
}
