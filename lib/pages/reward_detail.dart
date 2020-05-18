import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/widgets/image_widget.dart';

Reward reward = Reward(
  id: "1",
  imageId: "c9a560ac-63f2-401b-8185-2bae139957ad",
  itemType: "forAnimals",
  title: "Dostlarımıza Mama",
);

class RewardDetail extends StatelessWidget {
  Reward reward;
  RewardDetail({this.reward});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
                    visible: reward.point > 500,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "Bu ödül için 150 puan daha kazanmalısın !",
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
                      onPressed: () {},
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
