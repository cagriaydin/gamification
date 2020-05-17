import 'package:flutter/material.dart';
import 'package:yorglass_ik/repositories/feed-repository.dart';
import 'package:yorglass_ik/widgets/feed-widget.dart';
import 'package:yorglass_ik/models/content_option.dart';
import 'package:yorglass_ik/widgets/content_selector.dart';

class FeedPage extends StatefulWidget {
  final Function menuFunction;

  FeedPage({this.menuFunction});
  List<FeedContent> feedList = new List<FeedContent>();

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  var feedList = getFeed().map((feedItem) {
    return new FeedContent(
      feedItem: feedItem,
      isLiked: false,
    );
  }).toList();
  var _options = [
    ContentOption(
      title: "Duyurular",
      count: 15,
      isActive: true,
    ),
    ContentOption(
      title: "Webinar",
      count: 10,
      isActive: false,
    ),
    ContentOption(
      title: "B2B",
      count: 10,
      isActive: false,
    ),
  ];

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
                  print(currentContentOption.title);
                },
                options: _options,
              ),
            ),
            Expanded(
              flex: 10,
              child: ListView(
                children: feedList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
