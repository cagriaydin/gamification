import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yorglass_ik/models/content_option.dart';
import 'package:yorglass_ik/models/leader_board_item.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/pages/leader_board_page.dart';
import 'package:yorglass_ik/pages/rewards_page.dart';
import 'package:yorglass_ik/repositories/branch_repository.dart';
import 'package:yorglass_ik/repositories/user_repository.dart';
import 'package:yorglass_ik/widgets/blur_background_image.dart';
import 'package:yorglass_ik/widgets/build_user_info.dart';
import 'package:yorglass_ik/widgets/content_selector.dart';
import 'package:yorglass_ik/widgets/leader_board.dart';
import 'package:yorglass_ik/widgets/reward_cards.dart';
import 'package:yorglass_ik/widgets/user_percentage.dart';
import 'package:yorglass_ik/widgets/user_point.dart';

class ProfilePage extends StatelessWidget {
  final Function menuFunction;

  ProfilePage({Key key, @required this.menuFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final size =
        MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
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
          Flexible(child: BuildProfileInfo(size: size, padding: padding)),
          Flexible(
            child: BuildProfileTabs(),
          ),
        ],
      ),
    );
  }
}

class BuildProfileTabs extends StatefulWidget {
  @override
  _BuildProfileTabsState createState() => _BuildProfileTabsState();
}

class _BuildProfileTabsState extends State<BuildProfileTabs> {
  final PageController pageController = PageController(initialPage: 0);

  final List<ContentOption> options = [
    ContentOption(title: 'Liderler', isActive: true),
    ContentOption(title: 'Ödüllerim'),
  ];

  var future;

  @override
  void initState() {
    future = UserRepository.instance.getTopUserPointList();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: size.height < 600 ? 3 : 2,
          child: Padding(
            padding: size.height < 600
                ? const EdgeInsets.all(8)
                : const EdgeInsets.all(7.0),
            child: ContentSelector(
              onChange: onContentSelectorChange,
              options: options,
              contentSelectorType: ContentSelectorType.tab,
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: PageView(
//                    physics: NeverScrollableScrollPhysics(),
            onPageChanged: (i) {
              options.forEach((element) {
                element.isActive = false;
              });
              setState(() {
                options.elementAt(i).isActive = true;
              });
            },
            controller: pageController,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: FutureBuilder<List<User>>(
                      future: future,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<User>> snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      BranchRepository.instance;
                                      List<LeaderBoardItem> newList =
                                          snapshot.data
                                              .map((e) => LeaderBoardItem(
                                                    imageId: e.image,
                                                    point: e.point,
                                                    name: e.name,
                                                    branchName: e.branchName,
                                                  ))
                                              .toList();
                                      return LeaderBoardPage(
                                          leaderBoardUsers: newList);
                                    },
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  LeaderBoard(
                                    isLeaderBoard: true,
                                    list: snapshot.data
                                        .map((e) => LeaderBoardItem(
                                              imageId: e.image,
                                              point: e.point,
                                              name: e.name,
                                            ))
                                        .toList(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: OutlineButton(
                                      child: Text(
                                        'Lider Tablosunu Gör',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 18,
                                        ),
                                      ),
                                      textColor: Color(0xff2DB3C1),
                                      borderSide: BorderSide(
                                        color: Color(0xff2DB3C1),
                                        style: BorderStyle.solid,
                                        width: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              BranchRepository.instance;
                                              List<LeaderBoardItem> newList =
                                                  snapshot.data
                                                      .map((e) =>
                                                          LeaderBoardItem(
                                                            imageId: e.image,
                                                            point: e.point,
                                                            name: e.name,
                                                            branchName:
                                                                e.branchName,
                                                          ))
                                                      .toList();
                                              return LeaderBoardPage(
                                                  leaderBoardUsers: newList);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Transform.scale(
                  scale: size.height < 600 ? .7 : 1,
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      RewardCards(
                        reward: Reward(
                            imageId: "c9a560ac-63f2-401b-8185-2bae139957ad",
                            point: 0,
                            likeCount: 0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          child: Text(
                            'Ödülleri Gör',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                            ),
                          ),
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
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class BuildProfileInfo extends StatelessWidget {
  const BuildProfileInfo({
    Key key,
    @required this.size,
    @required this.padding,
  }) : super(key: key);

  final Size size;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final user = context.select((User value) => value);
    return BlurBackgroundImage(
      imageUrl: user.image,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height < 600 ? 0 : padding.top,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserPercentage(),
                Container(
                  child: BuildUserInfo(
                    showPercentage: true,
                    user: user,
                    radius: size.height < 700 ? 50 : 65,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: UserPoint(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
