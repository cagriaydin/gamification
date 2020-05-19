import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/content_option.dart';

enum ContentSelectorType { tab, feed }

typedef Widget CustomWidgetBuilder(BuildContext context, int index);

class ContentSelector extends StatefulWidget {
  final List<ContentOption> options;
  final Color activeColor;
  final Color disabledColor;
  final Function(ContentOption) onChange;
  final double fontSize;
  final CustomWidgetBuilder customWidgetBuilder;
  final bool isLeaderBoard;

  final ContentSelectorType contentSelectorType;

  final double paddingHorizontal;

  final MainAxisAlignment rowMainAxisAlignment;

  const ContentSelector({
    Key key,
    @required this.options,
    this.activeColor = const Color(0xFF2DB3C1),
    this.disabledColor = const Color(0xFF8E8D90),
    this.onChange,
    this.isLeaderBoard = false,
    this.paddingHorizontal = 24,
    this.customWidgetBuilder,
    this.contentSelectorType = ContentSelectorType.feed,
    this.fontSize = 14,
    this.rowMainAxisAlignment = MainAxisAlignment.center,
  }) : super(key: key);

  @override
  _ContentSelectorState createState() => _ContentSelectorState();
}

class _ContentSelectorState extends State<ContentSelector>
    with AfterLayoutMixin {
  final ScrollController scrollController = ScrollController();

  bool isScrollable = false;

  @override
  void initState() {
//    bool hasActiveElement = false;
    widget.options.forEach((element) {
      if (element.isActive) {
//        hasActiveElement = true;
        onChangeCallback(element);
      }
    });
//    if (!hasActiveElement) {
//      widget.options.first.isActive = true;
//        onChangeCallback(widget.options.first);
//    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isScrollable) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: widget.rowMainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.options.map((contentOption) {
          if (widget.customWidgetBuilder != null) {
            return widget.customWidgetBuilder(
                context, widget.options.indexOf(contentOption));
          } else {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                widget.options.forEach((element) {
                  element.isActive = false;
                });
                if (mounted) {
                  setState(() {
                    contentOption.isActive = true;
                  });
                }
                onChangeCallback(contentOption);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    widget.paddingHorizontal, 0, widget.paddingHorizontal, 0),
                child: Column(
                  crossAxisAlignment:
                      widget.contentSelectorType == ContentSelectorType.feed
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      contentOption.title,
                      style: TextStyle(
                        color: contentOption.isActive
                            ? widget.activeColor
                            : widget.disabledColor.withOpacity(.6),
                        fontSize: contentOption.isActive ? 18 : 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height:
                          widget.contentSelectorType == ContentSelectorType.feed
                              ? 8
                              : 3,
                    ),
                    widget.contentSelectorType == ContentSelectorType.feed
                        ? Text(
                            contentOption.count.toString() + ' ileti',
                            style: TextStyle(
                                color: widget.disabledColor.withOpacity(.6),
                                fontSize: contentOption.isActive ? 14 : 12,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic),
                          )
                        : Container(
                            height: 1,
                            width: widget.isLeaderBoard ? 60 : 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  contentOption.isActive
                                      ? (widget.isLeaderBoard
                                          ? Colors.white
                                          : widget.activeColor)
                                      : Colors.transparent,
                                  widget.isLeaderBoard || contentOption.isActive
                                      ? Colors.white10
                                      : Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          }
        }).toList(),
      );
    } else {
      return ListView.builder(
        controller: scrollController,
        padding: widget.contentSelectorType == ContentSelectorType.feed
            ? EdgeInsets.fromLTRB(64, 0, 0, 0)
            : EdgeInsets.fromLTRB(16, 0, 0, 0),
        scrollDirection: Axis.horizontal,
        itemCount: widget.options.length,
        itemBuilder: (BuildContext context, int index) {
          final contentOption = widget.options.elementAt(index);
          if (widget.customWidgetBuilder != null) {
            return widget.customWidgetBuilder(context, index);
          } else {
            return GestureDetector(
              onTap: () {
                widget.options.forEach((element) {
                  element.isActive = false;
                });
                if (mounted) {
                  setState(() {
                    contentOption.isActive = true;
                  });
                }
                onChangeCallback(contentOption);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    widget.paddingHorizontal, 0, widget.paddingHorizontal, 0),
                child: Column(
                  crossAxisAlignment:
                      widget.contentSelectorType == ContentSelectorType.feed
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      contentOption.title,
                      style: TextStyle(
                        color: contentOption.isActive
                            ? widget.activeColor
                            : widget.disabledColor.withOpacity(.6),
                        fontSize: contentOption.isActive ? 16 : 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height:
                          widget.contentSelectorType == ContentSelectorType.feed
                              ? 8
                              : 3,
                    ),
                    widget.contentSelectorType == ContentSelectorType.feed
                        ? Text(
                            contentOption.count.toString() + ' ileti',
                            style: TextStyle(
                              color: widget.disabledColor.withOpacity(.6),
                              fontSize: contentOption.isActive ? 12 : 10,
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        : Container(
                            height: 1,
                            width: widget.isLeaderBoard ? 60 : 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  contentOption.isActive
                                      ? (widget.isLeaderBoard
                                          ? Colors.white
                                          : Colors.blue)
                                      : Colors.transparent,
                                  widget.isLeaderBoard || contentOption.isActive
                                      ? Colors.white10
                                      : Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          }
        },
      );
    }
  }

  void onChangeCallback(contentOption) {
    if (widget.onChange != null) widget.onChange(contentOption);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      isScrollable = scrollController.position.maxScrollExtent == 0;
    });
    print(scrollController.position.maxScrollExtent);
  }
}
