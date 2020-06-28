import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/models/buyed-reward.dart';
import 'package:yorglass_ik/models/reward-like-dto.dart';
import 'package:yorglass_ik/models/reward-type.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user-reward-dto.dart';
import 'package:yorglass_ik/models/user-reward.dart';
import 'package:yorglass_ik/repositories/task-repository.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/services/db-connection.dart';
import 'package:yorglass_ik/repositories/dio_repository.dart';

class RewardRepository {
  static final RewardRepository _instance =
      RewardRepository._privateConstructor();

  RewardRepository._privateConstructor() {
    getActivePoint()
        .then((value) => likedRewards().then((value) => getMyRewards()));
  }

  static RewardRepository get instance => _instance;
  UserReward userRewardData = UserReward();

  Future<List<Reward>> getRewards({String type}) async {
    Response response = await RestApi.instance.dio.get(
      type == null
          ? '/reward/getRewardDTOs'
          : '/reward/getRewardDTOsByType/$type',
    );
    List<Reward> rewardItemList = [];

    if (response.data != null)
      rewardItemList = rewardListFromJson(response.data);

    return rewardItemList;
  }

  Future<List<BuyedReward>> getMyRewards() async {
    List<BuyedReward> rewardItemList = [];
    String id = AuthenticationService.verifiedUser.id;
    Response response = await RestApi.instance.dio.get(
      '/userreward/getBuyedRewards/$id',
    );
    if (response.data != null)
      rewardItemList = buyedRewardListFromJson(response.data);

    userRewardData.update(rewards: rewardItemList);
    return rewardItemList;
  }

  Future<Reward> getRewardItem(String id) async {
    Response response =
        await RestApi.instance.dio.get('/reward/getRewardDTOsById/$id');
    if (response.data != null) return rewardFromJson(response.data);
  }

  Future<List<RewardType>> getRewardTypes() async {
    List<RewardType> typeList = [];
    Response response =
        await RestApi.instance.dio.get('/reward/getRewardTypes');
    if (response.data != null) typeList = rewardTypeListFromJson(response.data);
    return typeList;
  }

  Future<List<String>> likedRewards() async {
    String id = AuthenticationService.verifiedUser.id;
    Response response =
        await RestApi.instance.dio.get('/reward/getRewardIdListByUserid/$id');

    List<String> likedList = new List<String>();
    if (response.data != null && response.data.length != 0)
    {
      forEach(response.data, (r){
        likedList.add(r);
      });
    }
    userRewardData.update(liked: likedList);
    return likedList;
  }

  Future<int> getActivePoint() async {
    String id = AuthenticationService.verifiedUser.id;
    Response response =
        await RestApi.instance.dio.get('/userreward/getActivePoints/$id');

    if (response.data > 0) {
      userRewardData.update(point: response.data);
      return response.data;
    }
    userRewardData.update(point: 0);
    return 0;
  }

  Future<bool> buyReward(String id) async {
    Reward r = await getRewardItem(id);
    int budget = await getActivePoint();
    DateTime buyDate = DateTime.now();
    if (budget > r.point) {
      Response post =
          await RestApi.instance.dio.post('/userreward/addUserReward',
              data: UserRewardDTO(
                userid: AuthenticationService.verifiedUser.id,
                rewardid: r.id,
                date: buyDate.toUtc(),
                status: 0,
                point: r.point,
              ).toJson());
      userRewardData.addReward(BuyedReward(
        id: r.id,
        title: r.title,
        imageId: r.imageId,
        itemType: r.itemType,
        likeCount: r.likeCount,
        point: r.point,
        buyDate: buyDate.toLocal(),
        status: 0,
      ));
      getActivePoint();
      return true;
    } else {
      throw Exception("Puanınız bu hediyeyi almak için yetersiz");
    }
  }

  Future<bool> changeLike(String rewardid) async {
    List<String> liked = await likedRewards();
    String userid = AuthenticationService.verifiedUser.id;

    if (liked.contains(rewardid)) {
      Response response = await RestApi.instance.dio.delete('/reward/deleteRewardLike/$userid/$rewardid');
      if (response != null &&
        response.data != null &&
        response.statusCode == 200) {
        userRewardData.liked.remove(rewardid);
        userRewardData.update(liked: userRewardData.liked);
        return false;
      }
    } else {
      RewardLikeDTO reward = RewardLikeDTO(
          userid: userid,
          rewardid: rewardid,
          date: DateTime.now()
      );
      Response response = await RestApi.instance.dio.post('/reward/addRewardLike', data: reward.toJson());
      if (response != null &&
        response.data != null &&
        response.statusCode == 200) {
        userRewardData.liked.add(rewardid);
        userRewardData.update(liked: userRewardData.liked);
//        userRewardStream.map((reward) {
//          reward.liked.add(id);
//          return reward;
//        });
        return true;
      }
    }
  }
}
