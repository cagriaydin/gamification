import 'dart:async';

import 'package:mysql1/mysql1.dart';
import 'package:rxdart/subjects.dart';
import 'package:yorglass_ik/models/buyed-reward.dart';
import 'package:yorglass_ik/models/reward-type.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user-reward.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class RewardRepository {
  static final RewardRepository _instance = RewardRepository._privateConstructor();

  RewardRepository._privateConstructor() {
    getActivePoint().then((value) => likedRewards().then((value) => getMyRewards()));
  }

  static RewardRepository get instance => _instance;
  //UserReward _userRewardData = UserReward();

  StreamController<UserReward> _userReward = BehaviorSubject();

  Stream get userRewardStream => _userReward.stream;

  Future<List<Reward>> getRewards({String type}) async {
    Results res;
    if (type == null) {
      res = await DbConnection.query("SELECT *, (SELECT count(1) FROM rewardlike WHERE rewardid = reward.id) as count FROM reward ORDER BY point DESC");
    } else {
      res = await DbConnection.query("SELECT *, (SELECT count(1) FROM rewardlike WHERE rewardid = reward.id) as count FROM reward WHERE type = ? ORDER BY point DESC", [type]);
    }
    List<Reward> rewardItemList = [];
    if (res.length > 0) {
      for (Row r in res) {
        rewardItemList.add(
          Reward(
            id: r[0],
            title: r[1].toString(),
            imageId: r[2],
            point: r[3],
            itemType: r[4],
            likeCount: r[5],
          ),
        );
      }
    }
    return rewardItemList;
  }

  Future<List<BuyedReward>> getMyRewards() async {
    Results res = await DbConnection.query(
        "SELECT reward.*, userreward.date, userreward.status, userreward.point, (SELECT count(1) FROM rewardlike WHERE rewardid = reward.id) as count FROM reward, userreward WHERE userreward.rewardid = reward.id AND userreward.userid = ?",
        [AuthenticationService.verifiedUser.id]);
    List<BuyedReward> rewardItemList = [];
    if (res.length > 0) {
      for (Row r in res) {
        rewardItemList.add(
          BuyedReward(
            id: r[0],
            title: r[1].toString(),
            imageId: r[2],
            point: r[7],
            itemType: r[4],
            likeCount: r[8],
            buyDate: r[5].toLocal(),
            status: r[6],
          ),
        );
      }
      // _userRewardData.rewards = rewardItemList;
      // _userReward.add(_userRewardData);
      userRewardStream.map((reward) {
        reward.rewards = rewardItemList;
        return reward;
      });
    }
    return rewardItemList;
  }

  Future<Reward> getRewardItem(String id) async {
    Results res;
    res = await DbConnection.query("SELECT *, (SELECT count(1) FROM rewardlike WHERE rewardid = reward.id) as count FROM reward WHERE id = ?", [id]);
    return Reward(
      id: res.single[0],
      title: res.single[1].toString(),
      imageId: res.single[2],
      point: res.single[3],
      itemType: res.single[4],
      likeCount: res.single[5],
    );
  }

  Future<List<RewardType>> getRewardTypes() async {
    List<RewardType> typeList = [];
    Results res = await DbConnection.query("SELECT * FROM rewardtype ORDER BY showorder");
    if (res.length > 0) {
      for (Row r in res) {
        typeList.add(RewardType(id: r[0], title: r[1]));
      }
    }
    return typeList;
  }

  Future<List<String>> likedRewards() async {
    Results res = await DbConnection.query("SELECT rewardid FROM rewardlike WHERE userid = ?", [AuthenticationService.verifiedUser.id]);
    List<String> likedList = [];
    if (res.length > 0) {
      for (Row r in res) {
        likedList.add(r[0]);
      }
      // _userRewardData.liked = likedList;
      // _userReward.add(_userRewardData);
      userRewardStream.map((reward) {
        reward.liked = likedList;
        return reward;
      });
    }
    return likedList;
  }

  Future<int> getActivePoint() async {
    Results res = await DbConnection.query(
      "SELECT COALESCE(SUM(point),0), (SELECT COALESCE(SUM(point),0) FROM userreward where userid = usertask.userid) FROM usertask where complete = 1 AND userid = ? GROUP BY userid",
      [
        AuthenticationService.verifiedUser.id,
      ],
    );
    int earn = (res.single[0] as double).floor();
    int cost = (res.single[1] as double).floor();
    int budget = (earn == null ? 0 : earn) - (cost == null ? 0 : cost);
    // _userRewardData.point = budget;
    // _userReward.add(_userRewardData);
    userRewardStream.map((reward) {
      reward.point = budget;
      return reward;
    });
    return budget;
  }

  Future buyReward(String id) async {
    Reward r = await getRewardItem(id);
    int budget = await getActivePoint();
    DateTime buyDate = DateTime.now();
    if (budget > r.point) {
      await DbConnection.query("INSERT INTO userreward (userid, rewardid, date, status, point) VALUES (?, ?, ?, ?, ?)", [
        AuthenticationService.verifiedUser.id,
        r.id,
        buyDate.toUtc(),
        0,
        r.point,
      ]);
      // _userRewardData.rewards.add(BuyedReward(
      //   id: r.id,
      //   title: r.title,
      //   imageId: r.imageId,
      //   itemType: r.itemType,
      //   likeCount: r.likeCount,
      //   point: r.point,
      //   buyDate: buyDate.toLocal(),
      //   status: 0,
      // ));
      // _userReward.add(_userRewardData);
      userRewardStream.map((reward) {
        reward.rewards.add(BuyedReward(
          id: r.id,
          title: r.title,
          imageId: r.imageId,
          itemType: r.itemType,
          likeCount: r.likeCount,
          point: r.point,
          buyDate: buyDate.toLocal(),
          status: 0,
        ));
        return reward;
      });
    } else {
      throw Exception("Puanınız bu hediyeyi almak için yetersiz");
    }
  }

  Future<bool> changeLike(String id) async {
    List<String> liked = await likedRewards();
    if (liked.contains(id)) {
      Results res = await DbConnection.query(
        'DELETE FROM rewardlike WHERE userid = ? AND rewardid = ?',
        [
          AuthenticationService.verifiedUser.id,
          id,
        ],
      );
      if (res.affectedRows > 0) {
        // _userRewardData.liked.remove(id);
        // _userReward.add(_userRewardData);
        userRewardStream.map((reward) {
          reward.liked.remove(id);
          return reward;
        });
        return false;
      }
    } else {
      Results res = await DbConnection.query(
        'INSERT INTO rewardlike (userid, rewardid, date) VALUES (?, ?, ?)',
        [
          AuthenticationService.verifiedUser.id,
          id,
          DateTime.now().toUtc(),
        ],
      );
      if (res.affectedRows > 0) {
        // _userRewardData.liked.add(id);
        // _userReward.add(_userRewardData);
        userRewardStream.map((reward) {
          reward.liked.add(id);
          return reward;
        });
        return true;
      }
    }
  }
}
