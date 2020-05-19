import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/models/reward-type.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class RewardRepository {
  static final RewardRepository _instance = RewardRepository._privateConstructor();

  RewardRepository._privateConstructor();

  static RewardRepository get instance => _instance;

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
            title: r[1],
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

  Future<List<Reward>> getMyRewards() async {
    Results res = await DbConnection.query(
        "SELECT reward.*, (SELECT count(1) FROM rewardlike WHERE rewardid = reward.id) as count FROM reward, userreward WHERE userreward.rewardid = reward.id AND userreward.userid = ?",
        [AuthenticationService.verifiedUser.id]);
    List<Reward> rewardItemList = [];
    if (res.length > 0) {
      for (Row r in res) {
        rewardItemList.add(
          Reward(
            id: r[0],
            title: r[1],
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

  Future<Reward> getRewardItem(String id) async {
    Results res;
    res = await DbConnection.query("SELECT *, (SELECT count(1) FROM rewardlike WHERE rewardid = reward.id) as count FROM reward WHERE id = ?", [id]);
    return Reward(
      id: res.single[0],
      title: res.single[1],
      imageId: res.single[2],
      point: res.single[3],
      itemType: res.single[4],
      likeCount: res.single[5],
    );
  }

  Future<List<RewardType>> getRewardTypes() async {
    List<RewardType> typeList = [];
    Results res = await DbConnection.query("SELECT * FROM rewardtype ORDER BY order");
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
    }
    return likedList;
  }

  Future<int> getActivePoint() async {
    Results res = await DbConnection.query(
      "SELECT SUM(point), (SELECT SUM(point) FROM userreward where userid = usertask.userid) FROM usertask where complete = 1 AND userid = ?",
      [
        AuthenticationService.verifiedUser.id,
      ],
    );
    return res.single[1] ?? 0 - res.single[2] ?? 0;
  }

  Future buyReward(String id) async {
    Reward r = await getRewardItem(id);
    int budget = await getActivePoint();
    if (budget > r.point) {
      await DbConnection.query("INSERT INTO userreward (userid, rewardid, date, status, point) VALUES (?, ?, ?, ?, ?)", [
        AuthenticationService.verifiedUser.id,
        r.id,
        DateTime.now().toUtc(),
        0,
        r.point,
      ]);
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
        return true;
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
        return true;
      }
    }
    return false;
  }
}
