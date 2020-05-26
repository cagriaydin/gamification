import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "İnsanlara Faydam Olsun",
                            style: TextStyle(color: Color(0xffAAAAAD), fontSize: 20),
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
                            style: TextStyle(color: Color(0xffAAAAAD), fontSize: 20),
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
                            style: TextStyle(color: Color(0xffAAAAAD), fontSize: 20),
                          ),
                        ),
                        Container(
                          height: size.height,
                          child: FutureBuilder(
                            future: RewardRepository.instance.getRewards(
                                type: "91548730-6a79-4d8d-9f1b-76f5dfa51887"),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Reward>> snapshot) {
                              if (snapshot.hasData) {
                                return GridView.count(
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height),
                                  scrollDirection: Axis.vertical,
                                  padding: EdgeInsets.all(8),
                                  crossAxisCount: 2,
                                  children: snapshot.data.map((e) => RewardCards4(reward: e)).toList(),
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
        height: 125,
        width: size.width,
        padding: EdgeInsets.only(top: padding.top),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [BoxShadow(color: Color(0xffABF3F8), offset: Offset(0, 3), blurRadius: 3, spreadRadius: 1)]),
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
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.animateToPage(
          contentOption.title == 'Ödüllerim' ? 1 : 0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        ));
  }
}

class BuildMyRewards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myRewards = context.select((UserReward value) => value.rewards);
    return GridView.count(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(8),
      crossAxisCount: 2,
      children: myRewards.map((e) => RewardCards3(reward: e)).toList(),
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
            fontSize: 20,
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
