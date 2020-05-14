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

  final ContentSelectorType contentSelectorType;

  final double paddingHorizontal;

  const ContentSelector({
    Key key,
    @required this.options,
    this.activeColor = const Color(0xff2FB4C2),
    this.disabledColor = Colors.black26,
    this.onChange,
    this.paddingHorizontal = 24,
    this.customWidgetBuilder,
    this.contentSelectorType = ContentSelectorType.feed,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  _ContentSelectorState createState() => _ContentSelectorState();
}

class _ContentSelectorState extends State<ContentSelector> {
  @override
  void initState() {
    widget.options.forEach((element) {
      if (element.isActive) {
        onChangeCallback(element);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
              setState(() {
                contentOption.isActive = true;
              });
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
                          : widget.disabledColor,
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
                            color: widget.disabledColor,
                            fontSize: contentOption.isActive ? 12 : 10,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      : Container(
                          height: 1,
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                contentOption.isActive
                                    ? Colors.blue
                                    : Colors.transparent,
                                Colors.transparent,
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

  void onChangeCallback(contentOption) {
    if (widget.onChange != null) widget.onChange(contentOption);
  }
}
