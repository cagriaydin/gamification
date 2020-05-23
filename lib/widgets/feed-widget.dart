import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/feed-item.dart';
import 'package:yorglass_ik/repositories/feed-repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/widgets/image_widget.dart';

class FeedContent extends StatelessWidget {
  final FeedItem feedItem;
  final Function deleteItem;

  FeedContent({Key key, this.feedItem, this.deleteItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => feedItem.url != null && feedItem.url.isNotEmpty ? launch(feedItem.url) : {},
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
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
                Container(
                  width: size.width,
                  height: 250,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    child: ImageWidget(
                      id: feedItem.imageId,
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: 3,
                  child: Container(
                    width: size.width,
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
                Container(
                  padding: EdgeInsets.only(top: 200),
                  child: Container(
                    width: size.width - 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.fromLTRB(32, 14, 32, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          feedItem.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF26315F),
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          feedItem.description,
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
                      ],
                    ),
                  ),
                ),
                // Positioned(
                //   right: 0,
                //   child: IconButton(
                //     color: Colors.white,
                //     icon: Icon(Icons.close),
                //     onPressed: () {
                //       FeedRepository.instance.deleteFeed(feedItem.id).then((value) => deleteItem());
                //     },
                //   ),
                // ),
                LikeWidget(feedItem: feedItem)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LikeWidget extends StatefulWidget {
  const LikeWidget({
    Key key,
    @required this.feedItem,
  }) : super(key: key);

  final FeedItem feedItem;

  @override
  _LikeWidgetState createState() => _LikeWidgetState();
}

class _LikeWidgetState extends State<LikeWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 5,
      child: Stack(
        children: <Widget>[
          IconButton(
            color: Color(0xFFF90A60),
            icon: AuthenticationService.verifiedUser.likedFeeds.contains(widget.feedItem.id) ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            onPressed: () {
              FeedRepository.instance.changeLike(widget.feedItem.id).then(
                    (value) => setState(
                      () {
                        if (AuthenticationService.verifiedUser.likedFeeds.contains(widget.feedItem.id)) {
                          widget.feedItem.likeCount++;
                        } else {
                          widget.feedItem.likeCount--;
                        }
                      },
                    ),
                  );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(19.0, 36.0, 18, 0),
            child: Text(
              widget.feedItem.likeCount != null ? widget.feedItem.likeCount.toString() : "0",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFF90A60), fontWeight: FontWeight.w300, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
