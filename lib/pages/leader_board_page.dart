import 'package:fetch_more/fetch_more.dart';
import 'package:flutter/material.dart';
import 'package:yorglass_ik/helpers/statusbar-helper.dart';
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
  List<LeaderBoardItem> leaderBoardUsers;

  LeaderBoardPage({Key key, this.leaderBoardUsers}) : super(key: key);

  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  bool isSelfCardVisible = true;

  final PageController pageController =
      PageController(initialPage: 0, keepPage: true);
  final ScrollController scrollController = ScrollController();
  final GlobalKey<FetchMoreBuilderState> _fetchMoreController =
      GlobalKey<FetchMoreBuilderState>();

  final List<ContentOption> options = [
    ContentOption(title: 'Bireysel', isActive: true),
    ContentOption(title: 'İşletme'),
  ];

  List<User> userList = [];
  List<UserLeaderBoard> userLeaderList = [];
  List<BranchLeaderBoard> branchLeaderList = [];
  List<Branch> branchList = [];
  List<Branch> branchTopList = [];

  var future;

  int limit = 10;
  int myRank = 0;
  bool isFirst = true;
  bool showMyRank = false;
  bool fetchMore = true;

  @override
  void initState() {
    StatusbarHelper.setSatusBar();
    future = Future.wait([
      BranchRepository.instance.getBoardPointList(),
      BranchRepository.instance.getTopBranchPointList(),
      BranchRepository.instance.getBranchList(),
      UserRepository.instance.getUserList(limit: limit, offset: 0),
      UserRepository.instance.getUserPointList(limit: limit, offset: 0)
    ]);
    getMyRank();
    super.initState();
  }

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
            height: size.height / 2,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  userList.take(3).toList(),
                );
              },
            ),
            title: Container(
              height: 36,
              child: ContentSelector(
                onChange: onContentSelectorChange,
                options: options,
                contentSelectorType: ContentSelectorType.tab,
                rowMainAxisAlignment: MainAxisAlignment.start,
                activeColor: Colors.white,
                isLeaderBoard: true,
                disabledColor: Colors.white.withOpacity(.6),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: WillPopScope(
            onWillPop: () {
              Navigator.pop(
                context,
                userList.take(3).toList(),
              );
              return new Future(() => false);
            },
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 19,
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (i) {
                        options.forEach((element) {
                          element.isActive = false;
                        });
                        setState(() {
                          options.elementAt(i).isActive = true;
                        });
                      },
                      children: [
                        Column(
                          children: [
                            Container(
                              child: LeaderBoard(
                                isLeaderBoard: true,
                                list: widget.leaderBoardUsers,
                              ),
                            ),
                            if (size.height > 600)
                              SizedBox(
                                height: size.height / 14,
                              ),
                            Expanded(
                              child: FutureBuilder(
                                future: future,
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData) {
                                    branchLeaderList = snapshot.data[0];
                                    branchTopList = snapshot.data[1];
                                    branchList = snapshot.data[2];
                                    userList = snapshot.data[3];
                                    userLeaderList = snapshot.data[4];
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        if (isSelfCardVisible && myRank > 5)
                                          GestureDetector(
                                            onTap: () async {
                                              showMyRank = true;
                                              await _fetchMoreController
                                                  .currentState
                                                  .refresh();

                                              setState(() {
                                                isSelfCardVisible = false;
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(11),
                                              child: RankContent(
                                                image: AuthenticationService
                                                    .verifiedUser.image,
                                                selfContent: true,
                                                title: AuthenticationService
                                                    .verifiedUser.name,
                                                rank: myRank,
                                                point: AuthenticationService
                                                    .verifiedUser.point,
                                                subTitle: AuthenticationService
                                                    .verifiedUser.branchName,
                                              ),
                                              decoration: BoxDecoration(
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
                                              ),
                                            ),
                                          ),
                                        Flexible(
                                          child: MediaQuery.removePadding(
                                            context: context,
                                            removeTop: true,
                                            child: FetchMoreBuilder(
                                              fetchMoreController:
                                                  _fetchMoreController,
                                              dataFetcher: dataFetcher,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      List<dynamic> list,
                                                      int index) {
                                                UserLeaderBoard item =
                                                    list.elementAt(index);
                                                return Visibility(
                                                  visible: showMyRank
                                                      ? true
                                                      : (index != 0 &&
                                                          index != 1 &&
                                                          index != 2),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(18, 0, 18, 0),
                                                    child: Container(
                                                      decoration: item.userId ==
                                                              AuthenticationService
                                                                  .verifiedUser
                                                                  .id
                                                          ? BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              boxShadow: <
                                                                  BoxShadow>[
                                                                BoxShadow(
                                                                  color: Color(
                                                                      0xFFC2F6FC),
                                                                  spreadRadius:
                                                                      0,
                                                                  blurRadius: 5,
                                                                  offset:
                                                                      Offset(
                                                                          0, 4),
                                                                ),
                                                              ],
                                                            )
                                                          : BoxDecoration(),
                                                      child: RankContent(
                                                        image: userList
                                                            .singleWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    item.userId)
                                                            .image,
                                                        selfContent: item
                                                                .userId ==
                                                            AuthenticationService
                                                                .verifiedUser
                                                                .id,
                                                        title: userList
                                                            .singleWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    item.userId)
                                                            .name,
                                                        subTitle: branchList
                                                            .singleWhere((element) =>
                                                                element.id ==
                                                                (userList
                                                                    .singleWhere((element) =>
                                                                        element
                                                                            .id ==
                                                                        item.userId)
                                                                    .branch))
                                                            .name,
                                                        rank: showMyRank
                                                            ? (myRank -
                                                                1 +
                                                                index)
                                                            : index + 1,
                                                        point: item.point,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              limit: limit,
                                            ),
                                          ),
                                        )
                                      ],
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
                        FutureBuilder(
                          future: future,
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              branchLeaderList = snapshot.data[0];
                              branchTopList = snapshot.data[1];
                              branchList = snapshot.data[2];
                              userList = snapshot.data[3];
                              userLeaderList = snapshot.data[4];
                              return Column(
                                children: [
                                  Container(
                                    child: LeaderBoard(
                                      isLeaderBoard: true,
                                      list: [
                                        LeaderBoardItem(
                                          name: "\n",
                                          imageId: branchTopList[0].image,
                                          point: branchTopList[0].point,
                                          branchName: branchTopList[0].name,
                                        ),
                                        LeaderBoardItem(
                                          name: "\n",
                                          imageId: branchTopList[1].image,
                                          point: branchTopList[1].point,
                                          branchName: branchTopList[1].name,
                                        ),
                                        LeaderBoardItem(
                                          name: "\n",
                                          imageId: branchTopList[2].image,
                                          point: branchTopList[2].point,
                                          branchName: branchTopList[2].name,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (size.height > 600)
                                    SizedBox(
                                      height: size.height / 10,
                                    ),
                                  Flexible(
                                    child: MediaQuery.removePadding(
                                      context: context,
                                      removeTop: true,
                                      child: ListView.builder(
                                          controller: scrollController,
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              branchLeaderList.length - 3,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            BranchLeaderBoard item =
                                                branchLeaderList
                                                    .skip(3)
                                                    .elementAt(index);
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        18, 0, 18, 0),
                                                child: Container(
                                                  child: RankContent(
                                                      image: branchList
                                                          .singleWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  item.branchId)
                                                          .image,
                                                      selfContent: item
                                                              .branchId ==
                                                          AuthenticationService
                                                              .verifiedUser
                                                              .branch,
                                                      point: item.point,
                                                      subTitle: branchList
                                                          .singleWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  item.branchId)
                                                          .name,
                                                      rank: index + 4),
                                                  decoration: item.branchId ==
                                                          AuthenticationService
                                                              .verifiedUser
                                                              .branch
                                                      ? BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          boxShadow: <
                                                              BoxShadow>[
                                                            BoxShadow(
                                                              color: Color(
                                                                  0xFFC2F6FC),
                                                              spreadRadius: 0,
                                                              blurRadius: 5,
                                                              offset:
                                                                  Offset(0, 4),
                                                            ),
                                                          ],
                                                        )
                                                      : BoxDecoration(),
                                                ));
                                          }),
                                    ),
                                  )
                                ],
                              );
                            } else
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  getMyRank() async {
    List<UserLeaderBoard> userList =
        await UserRepository.instance.getUserPointList(limit: 0, offset: 0);

    UserLeaderBoard user = userList.singleWhere(
        (element) => element.userId == AuthenticationService.verifiedUser.id);

    int i = userList.indexOf(user);
    myRank = i > 3 ? i : i + 1;
  }

  onContentSelectorChange(ContentOption contentOption) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => pageController.animateToPage(
              contentOption.title == 'Bireysel' ? 0 : 1,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            ));
  }

  resetUserList(int index) async {
    userList.clear();
    userLeaderList.clear();
    userList.addAll(
      await UserRepository.instance.getUserList(limit: limit, offset: index),
    );
    userLeaderList.addAll(
      await UserRepository.instance
          .getUserPointList(limit: limit, offset: index),
    );
  }

  refreshTopThree() {
    setState(() {
      widget.leaderBoardUsers = [
        LeaderBoardItem(
          imageId: userList[0].image,
          point: userLeaderList[0].point,
          name: userList[0].name,
          branchName: userList[0].branchName,
        ),
        LeaderBoardItem(
          imageId: userList[1].image,
          point: userLeaderList[1].point,
          name: userList[1].name,
          branchName: userList[1].branchName,
        ),
        LeaderBoardItem(
          imageId: userList[2].image,
          point: userLeaderList[2].point,
          name: userList[2].name,
          branchName: userList[2].branchName,
        )
      ];
    });
    if (userList
        .take(5)
        .map((e) => e.id)
        .toList()
        .contains(AuthenticationService.verifiedUser.id)) {
      setState(() {
        isSelfCardVisible = false;
      });
    } else {
      setState(() {
        isSelfCardVisible = true;
      });
    }
  }

  Future<List> dataFetcher(int index, int limit) async {
    if (index == 0 && !fetchMore && showMyRank) {
      fetchMore = true;
      showMyRank = false;
      await resetUserList(index);
      setState(() {
        isSelfCardVisible = true;
      });
    }
    if (!fetchMore) return [];
    if (index == 0 && !showMyRank) {
      await resetUserList(index);
      if (!isFirst) refreshTopThree();

      if (isFirst) {
        isFirst = false;
        return userLeaderList;
      }
    } else {
      if (showMyRank) {
        fetchMore = false;
        userList.clear();
      }

      userList.addAll(
        await UserRepository.instance.getUserList(
            limit: limit, offset: !showMyRank ? index : myRank - 1),
      );
    }

    var leaderBoardList = new List<UserLeaderBoard>();
    leaderBoardList.addAll(
      await UserRepository.instance.getUserPointList(
          limit: limit, offset: !showMyRank ? index : myRank - 1),
    );
    return leaderBoardList;
  }
}
