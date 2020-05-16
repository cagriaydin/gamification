import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/content_option.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/pages/leader_board_page.dart';
import 'package:yorglass_ik/pages/rewards_page.dart';
import 'package:yorglass_ik/widgets/blur_background_image.dart';
import 'package:yorglass_ik/widgets/build_user_info.dart';
import 'package:yorglass_ik/widgets/content_selector.dart';
import 'package:yorglass_ik/widgets/gradient_text.dart';
import 'package:yorglass_ik/widgets/leader_board.dart';
import 'package:yorglass_ik/widgets/reward_cards.dart';

class ProfilePage extends StatelessWidget {
  final Function menuFunction;
  final User user;
  final PageController pageController = PageController(initialPage: 0);

  final List<ContentOption> options = [
    ContentOption(title: 'Liderler', isActive: true),
    ContentOption(title: 'Ödüllerim'),
  ];

  ProfilePage({Key key, @required this.menuFunction, @required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => menuFunction(),
          child: Icon(
            Icons.menu,
            color: Color(0xff2DB3C1),
            size: 40,
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 2,
            child: BlurBackgroundImage(
              imageUrl: user.image,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height < 600 ? 0 : padding.top,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GradientText('%' + user.percentage.toString()),
                      BuildUserInfo(
                        showPercentage: true,
                        user: user,
                        radius: size.height < 700 ? 50 : 70,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GradientText(user.point.toString()),
                          GradientText('puan'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Padding(
                    padding: size.height < 600
                        ? const EdgeInsets.all(8)
                        : const EdgeInsets.all(16.0),
                    child: ContentSelector(
                      onChange: onContentSelectorChange,
                      options: options,
                      contentSelectorType: ContentSelectorType.tab,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () => pushLeaderBoardPage(context),
                              child: LeaderBoard(
                                users: [user, user, user],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlineButton(
                              child: Text('Lider Tablosunu Gör'),
                              textColor: Color(0xff2DB3C1),
                              borderSide: BorderSide(
                                color: Color(0xff2DB3C1),
                                style: BorderStyle.solid,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              onPressed: () => pushLeaderBoardPage(context),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Flexible(
                            child: RewardCards(
                              reward: Reward(
                                point: 25000,
                                image:
                                    'https://i.picsum.photos/id/0/5616/3744.jpg',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlineButton(
                              child: Text('Ödülleri Gör'),
                              textColor: Color(0xff2DB3C1),
                              borderSide: BorderSide(
                                color: Color(0xff2DB3C1),
                                style: BorderStyle.solid,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              onPressed: () => pushRewardsPage(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future pushLeaderBoardPage(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return LeaderBoardPage(
            leaderBoard: LeaderBoard(
              users: [user, user, user],
            ),
          );
        },
      ),
    );
  }

  Future pushRewardsPage(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return RewardsPage();
        },
      ),
    );
  }

  onContentSelectorChange(ContentOption contentOption) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => pageController.animateToPage(
              contentOption.title == 'Liderler' ? 0 : 1,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            ));
  }
}
