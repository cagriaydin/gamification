import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/feed-item.dart';
import 'package:yorglass_ik/repositories/image-repository.dart';

class FeedContent extends StatefulWidget {
  FeedItem feedItem;
  bool isLiked = false;

  FeedContent({Key key, this.feedItem, this.isLiked}) : super(key: key);

  @override
  _FeedContentState createState() => _FeedContentState();
}

class _FeedContentState extends State<FeedContent> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 10 / 7,
            child: Container(
              width: size.width,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Image.memory(
                  Base64Codec().decode(
                    getImage64(widget.feedItem.imageId),
                  ),
                ),
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF9298BA),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.feedItem.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF26315F),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.feedItem.description,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.close),
              onPressed: () {
                print("CLOSE BUTTON IS CLICKED");
              },
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Column(
              children: <Widget>[
                IconButton(
                  color: Colors.pink,
                  icon: widget.isLiked
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                  onPressed: () {
                    setState(() {
                      !widget.isLiked
                          ? widget.isLiked = true
                          : widget.isLiked = false;
                    });
                    print("LIKE BUTTON IS CLICKED");
                  },
                ),
                Text(
                  widget.feedItem.likeCount.toString(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
