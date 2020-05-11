import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/content_option.dart';
import 'package:yorglass_ik/widgets/content_selector.dart';

class FeedPage extends StatefulWidget {
  final Function menuFunction;

  FeedPage({this.menuFunction});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
                options: _options,
              ),
            )
          ],
        ),
      ),
    );
  }
}
