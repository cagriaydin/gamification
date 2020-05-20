import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/feed-item.dart';
import 'package:yorglass_ik/repositories/feed-repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yorglass_ik/widgets/image_widget.dart';

class FeedContent extends StatefulWidget {
  final FeedItem feedItem;
  bool isLiked = false;
  final Function deleteItem;

  FeedContent({Key key, this.feedItem, this.deleteItem, this.isLiked})
      : super(key: key);

  @override
  _FeedContentState createState() => _FeedContentState();
}

class _FeedContentState extends State<FeedContent> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => widget.feedItem.url != null && widget.feedItem.url.isNotEmpty
          ? launch(widget.feedItem.url)
          : {},
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: size.height / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                color: Theme.of(context).primaryColor,
                offset: new Offset(0, 0),
                blurRadius: 15.0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            child: Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 10 / 7,
                  child: Container(
                    width: size.width,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      child: ImageWidget(
                        id: widget.feedItem.imageId,
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
                    height: size.height * .3,
                    width: size.width - 7,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 14, 32, 4),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                widget.feedItem.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF26315F),
                                  fontSize: 35,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(32, 8, 32, 20),
                                child: Text(
                                  widget.feedItem.description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    shadows: <Shadow>[
                                      Shadow(
                                        blurRadius: 40.0,
                                        color: Color(0xFF2FB4C2).withOpacity(.4),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   right: 0,
                //   child: IconButton(
                //     color: Colors.white,
                //     icon: Icon(Icons.close),
                //     onPressed: () {
                //       FeedRepository.instance
                //           .deleteFeed(widget.feedItem.id)
                //           .then((value) => widget.deleteItem());
                //     },
                //   ),
                // ),
                Positioned(
                  right: 0,
                  bottom: 5,
                  child: Stack(
                    children: <Widget>[
                      IconButton(
                        color: Color(0xFFF90A60),
                        icon: widget.isLiked
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                        onPressed: () {
                          FeedRepository.instance
                              .changeLike(widget.feedItem.id)
                              .then(
                                (value) => setState(
                                  () {
                                    !widget.isLiked
                                        ? widget.feedItem.likeCount++
                                        : widget.feedItem.likeCount--;
                                    !widget.isLiked
                                        ? widget.isLiked = true
                                        : widget.isLiked = false;
                                  },
                                ),
                              );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(19.0, 36.0, 18, 0),
                        child: Text(
                          widget.feedItem.likeCount != null
                              ? widget.feedItem.likeCount.toString()
                              : "0",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFFF90A60),
                              fontWeight: FontWeight.w300,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
