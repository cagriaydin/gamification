import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/branch.dart';
import 'package:yorglass_ik/models/branch_leader_board.dart';
import 'package:yorglass_ik/models/content_option.dart';
import 'package:yorglass_ik/models/leader_board_item.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/models/user_leader_board.dart';
import 'package:yorglass_ik/repositories/branch_repository.dart';
import 'package:yorglass_ik/repositories/user_repository.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/widgets/content_selector.dart';
import 'package:yorglass_ik/widgets/leader_board.dart';
import 'package:yorglass_ik/widgets/rank_content.dart';

class LeaderBoardPage extends StatefulWidget {
  final LeaderBoard leaderBoard;
  bool isSelfCardVisible = true;

  LeaderBoardPage({Key key, this.leaderBoard}) : super(key: key);

  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  final PageController pageController = PageController(initialPage: 0);
  final ScrollController scrollController = ScrollController();

  final List<ContentOption> options = [
    ContentOption(title: 'Bireysel', isActive: true),
    ContentOption(title: 'İşletme'),
  ];

  List<BranchLeaderBoard> branchLeaderList =
      BranchRepository.instance.getBoardPointList();
  List<Branch> branchList = BranchRepository.instance.getBranchList();

  List<UserLeaderBoard> userLeaderList =
      UserRepository.instance.getUserPointList();
  List<User> userList = UserRepository.instance.getUserList();

  List<Branch> branchTopList =
      BranchRepository.instance.getTopBranchPointList();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.white,
          ),
        ),
        Positioned(
          top: 0,
          child: Image.asset(
            "assets/board-background.png",
            width: size.width,
          ),
        ),
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Container(
              width: size.width,
              height: 33,
              child: ContentSelector(
                onChange: onContentSelectorChange,
                options: options,
                contentSelectorType: ContentSelectorType.tab,
                activeColor: Colors.white,
                isLeaderBoard: true,
                disabledColor: Colors.white.withOpacity(.6),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 19,
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [
                      Column(
                        children: [
                          Container(
                            child: widget.leaderBoard,
                          ),
                          SizedBox(
                            height: size.height / 18,
                          ),
                          if (widget.isSelfCardVisible)
                            GestureDetector(
                              onTap: () {
                                scrollController.animateTo(
                                  75 *
                                      double.tryParse(
                                          (getMyRank() - 3).toString()),
                                  duration: Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                );
                                setState(() {
                                  widget.isSelfCardVisible = false;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(11),
                                child: RankContent(
                                  selfContent: true,
                                  title: userList
                                      .singleWhere((element) =>
                                          element.id ==
                                          AuthenticationService.verifiedUser.id)
                                      .name,
                                  rank: getMyRank(),
                                  point: userLeaderList
                                      .singleWhere((element) =>
                                          element.userId ==
                                          AuthenticationService.verifiedUser.id)
                                      .point,
                                  subTitle: branchList
                                      .singleWhere((element) =>
                                          element.id ==
                                          (userList
                                              .singleWhere((element) =>
                                                  element.id ==
                                                  AuthenticationService
                                                      .verifiedUser.id)
                                              .branchId))
                                      .name,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Color(0xFFC2F6FC),
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Flexible(
                            child: ListView.builder(
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                itemCount: userLeaderList.length - 3,
                                itemBuilder: (BuildContext context, int index) {
                                  UserLeaderBoard item =
                                      userLeaderList.skip(3).elementAt(index);
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                    child: Container(
                                      decoration: item.userId ==
                                              AuthenticationService
                                                  .verifiedUser.id
                                          ? BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                  color: Color(0xFFC2F6FC),
                                                  spreadRadius: 0,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            )
                                          : BoxDecoration(),
                                      child: RankContent(
                                        selfContent: item.userId ==
                                            AuthenticationService
                                                .verifiedUser.id,
                                        title: userList
                                            .singleWhere((element) =>
                                                element.id == item.userId)
                                            .name,
                                        subTitle: branchList
                                            .singleWhere((element) =>
                                                element.id ==
                                                (userList
                                                    .singleWhere((element) =>
                                                        element.id ==
                                                        item.userId)
                                                    .branchId))
                                            .name,
                                        rank: index + 4,
                                        point: item.point,
                                      ),
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            child: LeaderBoard(
                              list: [
                                LeaderBoardItem(
                                  image: branchTopList[0].image,
                                  point: branchTopList[0].point,
                                  name: branchTopList[0].name + " İşletmesi",
                                ),
                                LeaderBoardItem(
                                  image: branchTopList[1].image,
                                  point: branchTopList[1].point,
                                  name: branchTopList[1].name + " İşletmesi",
                                ),
                                LeaderBoardItem(
                                  image: branchTopList[2].image,
                                  point: branchTopList[2].point,
                                  name: branchTopList[2].name + " İşletmesi",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height / 15,
                          ),
                          Flexible(
                            child: ListView.builder(
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                itemCount: branchLeaderList.length - 3,
                                itemBuilder: (BuildContext context, int index) {
                                  BranchLeaderBoard item =
                                      branchLeaderList.skip(3).elementAt(index);
                                  return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          18, 0, 18, 0),
                                      child: Container(
                                        child: RankContent(
                                            selfContent: item.branchId ==
                                                AuthenticationService
                                                    .verifiedUser.branchId,
                                            point: item.point,
                                            subTitle: branchList
                                                .singleWhere((element) =>
                                                    element.id == item.branchId)
                                                .name,
                                            rank: index + 4),
                                        decoration: item.branchId ==
                                                AuthenticationService
                                                    .verifiedUser.branchId
                                            ? BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                    color: Color(0xFFC2F6FC),
                                                    spreadRadius: 0,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              )
                                            : BoxDecoration(),
                                      ));
                                }),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getMyRank() {
    return userLeaderList.indexOf(userLeaderList.singleWhere((element) =>
            element.userId == AuthenticationService.verifiedUser.id)) +
        1;
  }

  onContentSelectorChange(ContentOption contentOption) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => pageController.animateToPage(
              contentOption.title == 'Bireysel' ? 0 : 1,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            ));
  }
}
