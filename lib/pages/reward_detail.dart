import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yorglass_ik/helpers/popup_helper.dart';
import 'package:yorglass_ik/helpers/statusbar-helper.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user-reward.dart';
import 'package:yorglass_ik/repositories/reward-repository.dart';
import 'package:yorglass_ik/widgets/image_widget.dart';
import 'package:yorglass_ik/widgets/loading_builder.dart';

class RewardDetail extends StatefulWidget {
  final Reward reward;

  RewardDetail({this.reward}) {
    StatusbarHelper.setSatusBar();
  }

  @override
  _RewardDetailState createState() => _RewardDetailState();
}

class _RewardDetailState extends State<RewardDetail> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final int point =
        context.select((UserReward userReward) => userReward.point);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: !isLoading
          ? Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  child: Container(
                    width: size.width,
                    height: size.height / 2,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: ImageWidget(
                        id: widget.reward.imageId,
                        borderRadius: BorderRadius.all(Radius.circular(0)),
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
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                15.0, 20.0, 10.0, 0.0),
                            child: Text(
                              widget.reward.title,
                              style: TextStyle(
                                  fontSize: 24, color: Color(0xFF26315F)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: Visibility(
                            visible: widget.reward.point > point,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Bu ödül için ${widget.reward.point - point} puan daha kazanmalısın !",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFFF90A60),
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: OutlineButton(
                              child: Text('Ödülü Al!'),
                              textColor: Color(0xff2DB3C1),
                              borderSide: BorderSide(
                                color: Color(0xff2DB3C1),
                                style: BorderStyle.solid,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              onPressed: widget.reward.point > point
                                  ? null
                                  : () async {
                                      try {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        var y = await RewardRepository.instance
                                            .buyReward(widget.reward.id);
                                        Navigator.pop(context);
                                        if (y) {
                                          PopupHelper().showPopup(context,
                                              Text('Ödülü başarıyla aldınız!'));
                                        }
                                      } catch (e) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        PopupHelper().showPopup(
                                            context, Text(e.toString()));
                                      }
                                    },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          : LoadingBuilder(
              text: "Ödül satın alınıyor...",
            ),
    );
  }
}
