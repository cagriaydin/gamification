import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user-reward.dart';
import 'package:yorglass_ik/repositories/reward-repository.dart';
import 'package:provider/provider.dart';

class LikeRewardWidget extends StatefulWidget {
  final List<String> likedRewards;

  const LikeRewardWidget({
    Key key,
    @required this.reward,
    this.likedRewards,
  }) : super(key: key);

  final Reward reward;

  @override
  _LikeRewardWidgetState createState() => _LikeRewardWidgetState();
}

class _LikeRewardWidgetState extends State<LikeRewardWidget> {
  @override
  Widget build(BuildContext context) {
    final likedRewards = context.select((UserReward userReward) => userReward.liked);
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        IconButton(
          color: Color(0xFFF90A60),
          icon: likedRewards.contains(widget.reward.id) ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
          onPressed: () {
            setState(
              () {
                if (!likedRewards.contains(widget.reward.id)) {
                  widget.reward.likeCount++;
                  likedRewards.add(widget.reward.id);
                } else {
                  likedRewards.remove(widget.reward.id);
                  if (widget.reward.likeCount == 0) return;
                  widget.reward.likeCount--;
                }
              },
            );
            RewardRepository.instance.changeLike(widget.reward.id).then(
                  (value) => setState(
                    () {
                      if (!value) {
                        if (!likedRewards.contains(widget.reward.id)) {
                          widget.reward.likeCount++;
                          likedRewards.add(widget.reward.id);
                        } else {
                          likedRewards.remove(widget.reward.id);
                          if (widget.reward.likeCount == 0) return;
                          widget.reward.likeCount--;
                        }
                      }
                    },
                  ),
                );
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(19.0, 36.0, 18, 0),
          child: Text(
            widget.reward.likeCount != null ? widget.reward.likeCount.toString() : "0",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFF90A60), fontWeight: FontWeight.w300, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
