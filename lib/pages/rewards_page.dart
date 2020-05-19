import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/content_option.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/repositories/reward-repository.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/widgets/content_selector.dart';
import 'package:yorglass_ik/widgets/gradient_text.dart';
import 'package:yorglass_ik/widgets/reward-cards3.dart';
import 'package:yorglass_ik/widgets/reward-slider-one.dart';
import 'package:yorglass_ik/widgets/reward-slider-two.dart';

class RewardsPage extends StatelessWidget {
  final List<ContentOption> options = [
    ContentOption(title: 'Ödül Havuzu', isActive: true),
    ContentOption(title: 'Ödüllerim'),
  ];

  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              height: 125,
              width: size.width,
              padding: EdgeInsets.only(top: padding.top),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xff54B4BA),
                        offset: Offset(2, 3),
                        blurRadius: 4,
                        spreadRadius: 2)
                  ]),
              child: Column(
                children: [
                  Flexible(
                    child: GradientText(
                      (AuthenticationService.verifiedUser.point ?? 0)
                          .toString(),
                      fontSize: 25,
                    ),
                  ),
                  Flexible(
                    child: GradientText(
                      'puan',
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: 40,
                    child: ContentSelector(
                      onChange: onContentSelectorChange,
                      options: options,
                      rowMainAxisAlignment: MainAxisAlignment.spaceAround,
                      contentSelectorType: ContentSelectorType.tab,
                      activeColor: Color(0xff4BADBB),
                      isLeaderBoard: false,
                      disabledColor: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: controller,
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "İnsanlara Faydam Olsun",
                          style:
                              TextStyle(color: Color(0xffAAAAAD), fontSize: 20),
                        ),
                      ),
                      Container(
                        height: size.height / 3,
                        child: RewardSliderOne(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Şirin Hayvan Dostlarımıza",
                          style:
                              TextStyle(color: Color(0xffAAAAAD), fontSize: 20),
                        ),
                      ),
                      Container(
                        height: size.height / 2.5,
                        child: RewardSliderTwo(),
                      ),
                      //TODO: type 3 start here
                      Container(
                        height: size.height / 2,
                        child: FutureBuilder(
                          future: RewardRepository.instance.getRewards(type: 3),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Reward>> snapshot) {
                            if (snapshot.hasData) {
                              return GridView.count(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.all(8),
                                crossAxisCount: 2,
                                children: snapshot.data
                                    .map((e) => RewardCards3(reward: e))
                                    .toList(),
                              );
                            } else
                              return Center(child: CircularProgressIndicator());
                          },
                        ),
                      )
                      //TODO type 3 finish
                    ],
                  ),
                ),
                //TODO ödüllerim sayfası
                Center(
                  child: Text('ödüllerim sayfası'),
                )
              ],
            ),
          ),
          // Flexible(
          //   child: RewardSliderOne(),
          // ),
          // GridView(
          //   semanticChildCount: 2,
          //   children: <Widget>[],
          // ),
        ],
      ),
    );
  }

  onContentSelectorChange(ContentOption contentOption) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => controller.animateToPage(
              contentOption.title == 'Ödüllerim' ? 1 : 0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            ));
  }
}
