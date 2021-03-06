import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yorglass_ik/helpers/statusbar-helper.dart';
import 'package:yorglass_ik/models/content_option.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user-reward.dart';
import 'package:yorglass_ik/repositories/reward-repository.dart';
import 'package:yorglass_ik/widgets/content_selector.dart';
import 'package:yorglass_ik/widgets/gradient_text.dart';
import 'package:yorglass_ik/widgets/reward-slider-one.dart';
import 'package:yorglass_ik/widgets/reward-slider-two.dart';
import 'package:yorglass_ik/widgets/reward_cards4.dart';

class RewardsPage extends StatelessWidget {
  final List<ContentOption> options = [
    ContentOption(title: 'Ödül Havuzu', isActive: true),
    ContentOption(title: 'Ödüllerim'),
  ];

  RewardsPage() {
    StatusbarHelper.setSatusBar();
  }

  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return ChangeNotifierProvider.value(
      value: RewardRepository.instance.userRewardData,
      child: Scaffold(
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
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "İnsanlara Faydam Olsun",
                            style: TextStyle(
                                color: Color(0xffD6D8DC),
                                fontSize: 20,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        RewardSliderOne(
                          height: 250,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "Şirin Hayvan Dostlarımıza",
                            style: TextStyle(
                                color: Color(0xffAAAAAD),
                                fontSize: 20,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RewardSliderTwo(width: size.width),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "Kendimi mutlu etme zamanı!",
                            style: TextStyle(
                                color: Color(0xffAAAAAD),
                                fontSize: 20,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        FutureBuilder(
                          future: RewardRepository.instance.getRewards(
                              type: "91548730-6a79-4d8d-9f1b-76f5dfa51887"),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Reward>> snapshot) {
                            if (snapshot.hasData) {
                              return GridView.count(
                                childAspectRatio: 90 / 165,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
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
                      ],
                    ),
                  ),
                  BuildMyRewards(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildTopPart(Size size, EdgeInsets padding) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        height: 170,
        width: size.width,
        padding: EdgeInsets.only(top: padding.top),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                  color: Color(0xffABF3F8),
                  offset: Offset(0, 3),
                  blurRadius: 3,
                  spreadRadius: 1)
            ]),
        child: Column(
          children: [
            Flexible(
              child: BuildActivePoint(),
            ),
            Container(
              width: size.width,
              height: 40,
              child: ContentSelector(
                onChange: onContentSelectorChange,
                options: options,
                rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                contentSelectorType: ContentSelectorType.tab,
                activeColor: Color(0xff4BADBB),
                fontSize: 18,
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
              contentOption.title == 'Ödül Havuzu' ? 0 : 1,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            ));
  }
}

class BuildMyRewards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myRewards = context.select((UserReward value) => value.rewards);
    return myRewards != null && myRewards.length > 0
        ? GridView.count(
            scrollDirection: Axis.vertical,
            childAspectRatio: 90 / 165,
            padding: EdgeInsets.all(8),
            crossAxisCount: 2,
            children: myRewards.map((e) {
              return RewardCards4(
                reward: e,
                isMyReward: true,
              );
            }).toList(),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Şimdilik ödülün bulunmamakta, puan toplamaya devam et!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          );
  }
}

class BuildActivePoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final point = context.select((UserReward userReward) => userReward.point);
    return Column(
      children: [
        Flexible(
          child: GradientText(
            (point ?? 0).toString(),
            fontSize: 40,
          ),
        ),
        Flexible(
          child: GradientText(
            'puan',
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
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
