import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/feed-item.dart';
import 'package:yorglass_ik/repositories/feed-repository.dart';
import 'package:yorglass_ik/widgets/feed-widget.dart';

class FeedPage extends StatelessWidget {
  final Function menuFunction;
  FeedPage({this.menuFunction});

  @override
  Widget build(BuildContext context) {
    FeedRepository.instance.getFeed();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => menuFunction(),
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
              // NEXT RELEASE
              color: Theme.of(context).primaryColor.withOpacity(0),
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 10,
              child: StreamBuilder<List<FeedItem>>(
                stream: FeedRepository.instance.currentFeeds,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<FeedItem>> snapshot,
                ) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: snapshot.data
                          .map((feedItem) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FeedContent(
                                  feedItem: feedItem,
                                  deleteItem: () {
                                    FeedRepository.instance.deleteFeed(feedItem.id);
                                  },
                                ),
                              ))
                          .toList(),
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
      ),
    );
  }
}
