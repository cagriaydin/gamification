import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/repositories/reward-repository.dart';
import 'package:yorglass_ik/widgets/image_widget.dart';

class RewardDetail extends StatelessWidget {
  final Reward reward;

  final num currentPoint;

  RewardDetail({this.reward, this.currentPoint = 0});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              width: size.width,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: ImageWidget(
                  id: reward.imageId,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                border: Border.all(color: Colors.white),
                color: Colors.white,
              ),
              height: size.height / 1.75,
              width: size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        reward.title,
                        style: TextStyle(
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: reward.point > currentPoint,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "Bu ödül için ${reward.point - currentPoint} puan daha kazanmalısın !",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.pink,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: OutlineButton(
                      child: Text('Ödülü Al!'),
                      textColor: Color(0xff2DB3C1),
                      borderSide: BorderSide(
                        color: Color(0xff2DB3C1),
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      onPressed: reward.point > currentPoint
                          ? null
                          : () async {
                              try {
                                var y = await RewardRepository.instance
                                    .buyReward(reward.id);
                                print(y);
                              } catch (e) {
                                print(e);
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
