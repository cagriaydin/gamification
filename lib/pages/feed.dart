import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/feed-item.dart';
import 'package:yorglass_ik/models/feed-type.dart';
import 'package:yorglass_ik/repositories/feed-repository.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/widgets/feed-widget.dart';
import 'package:yorglass_ik/models/content_option.dart';
import 'package:yorglass_ik/widgets/content_selector.dart';

class FeedPage extends StatefulWidget {
  final Function menuFunction;
  FeedPage({this.menuFunction});
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<ContentOption> _options = [];
  List<FeedType> feedTypes;
  List<FeedItem> feedItemList;
  String selectedId;
  @override
  void initState() {
    FeedRepository.instance.getFeed().then((value) {
      feedItemList = value;
      FeedRepository.instance.getFeedTypes().then((types) {
        setState(() {
          feedTypes = types;
          types.forEach((element) {
            if (types.indexOf(element) == 0) {
              selectedId = element.id;
            }
            _options.add(
              ContentOption(title: element.title, isActive: types.indexOf(element) == 0, count: value.where((e) => e.itemType == element.id).length),
            );
          });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => widget.menuFunction(),
          child: Icon(
            Icons.menu,
            color: Color(0xff2DB3C1),
            size: 40,
          ),
        ),
        title: Center(
            child: Image.asset(
          "assets/yorglass.png",
          width: 100,
        )),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: <Widget>[
            Flexible(
              child: ContentSelector(
                onChange: (ContentOption currentContentOption) {
                  setState(() => selectedId = feedTypes.firstWhere((element) => element.title == currentContentOption.title).id);
                },
                options: _options,
              ),
            ),
            Expanded(
              flex: 10,
              child: ListView(
                children: feedItemList != null
                    ? feedItemList
                        .where((element) => element.itemType == selectedId)
                        .map((feedItem) => FeedContent(
                              feedItem: feedItem,
                              isLiked: AuthenticationService.verifiedUser.likedFeeds.contains(feedItem.id),
                            ))
                        .toList()
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
