import 'package:flutter/material.dart';
import 'package:yorglass_ik/repositories/feed-repository.dart';
import 'package:yorglass_ik/widgets/feed-widget.dart';

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
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Duyurular"),
                    Text("15 İleti"),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("Webinarlar"),
                    Text("10 İleti"),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("B2B"),
                    Text("10 İleti"),
                  ],
                )
              ],
            ),
            Expanded(
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
