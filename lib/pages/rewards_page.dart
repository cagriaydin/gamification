import 'package:flutter/material.dart';
import 'package:yorglass_ik/helpers/statusbar-helper.dart';
import 'package:yorglass_ik/models/content_option.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user-reward.dart';
import 'package:yorglass_ik/repositories/reward-repository.dart';
import 'package:yorglass_ik/widgets/content_selector.dart';
import 'package:yorglass_ik/widgets/gradient_text.dart';
import 'package:yorglass_ik/widgets/reward-cards3.dart';
import 'package:yorglass_ik/widgets/reward-slider-one.dart';
import 'package:yorglass_ik/widgets/reward-slider-two.dart';
import 'package:yorglass_ik/widgets/reward_cards4.dart';

class RewardsPage extends StatefulWidget {
  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final List<ContentOption> options = [
    ContentOption(title: 'Ödül Havuzu', isActive: true),
    ContentOption(title: 'Ödüllerim'),
  ];

  final controller = PageController(initialPage: 0);

  ValueNotifier<int> currentPoint = ValueNotifier(0);

  Future<int> getActivePointFuture;

  @override
  void initState() {
    StatusbarHelper.setSatusBar();
    handleInitState();
    super.initState();
  }

  void handleInitState() async {
    getActivePointFuture = RewardRepository.instance.getActivePoint();
    currentPoint.value = await getActivePointFuture;
  }

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
          buildTopPart(size, padding),
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
                        child: RewardSliderOne(
                          currentPoint: currentPoint,
                        ),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Kendimi mutlu etme zamanı!",
                          style:
                              TextStyle(color: Color(0xffAAAAAD), fontSize: 20),
                        ),
                      ),
                      Container(
                        height: size.height,
                        child: FutureBuilder(
                          future: RewardRepository.instance.getRewards(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Reward>> snapshot) {
                            if (snapshot.hasData) {
                              return GridView.count(
                                childAspectRatio:
                                    MediaQuery.of(context).size.width /
                                        (MediaQuery.of(context).size.height),
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.all(8),
                                crossAxisCount: 2,
                                children: snapshot.data
                                    .map((e) => RewardCards4(reward: e))
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
                StreamBuilder(
                  stream: RewardRepository.instance.userRewardStream,
                  builder:
                      (BuildContext context, AsyncSnapshot<UserReward> snapshot) {
                    if (snapshot.hasData && snapshot.data.rewards != null) {
                      return GridView.count(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(8),
                        crossAxisCount: 2,
                        children: snapshot.data.rewards
                            .map((e) => RewardCards3(reward: e))
                            .toList(),
                      );
                    } else
                      return Center(child: CircularProgressIndicator());
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding buildTopPart(Size size, EdgeInsets padding) {
    return Padding(
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
              child: FutureBuilder(
                future: getActivePointFuture,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData || snapshot.hasError) {
                    return Column(
                      children: [
                        Flexible(
                          child: GradientText(
                            (snapshot.data ?? 0).toString(),
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
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
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

class WorkingProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.build,
            size: 40,
            color: Colors.black54,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Sayfamız yapım aşamasındadır anlayışınız için teşekkür ederiz.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
