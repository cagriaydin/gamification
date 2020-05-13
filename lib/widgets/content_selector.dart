import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/content_option.dart';

class ContentSelector extends StatefulWidget {
  final List<ContentOption> options;
  final Color activeColor;
  final Color disabledColor;
  final Function(ContentOption) onChange;

  final double paddingHorizontal;

  const ContentSelector({
    Key key,
    this.options,
    this.activeColor = Colors.blue,
    this.disabledColor = Colors.black26,
    this.onChange,
    this.paddingHorizontal = 24,
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
      padding: EdgeInsets.fromLTRB(64, 0, 0, 0),
      scrollDirection: Axis.horizontal,
      itemCount: widget.options.length,
      itemBuilder: (BuildContext context, int index) {
        final contentOption = widget.options.elementAt(index);
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  height: 8,
                ),
                Text(
                  contentOption.count.toString() + ' ileti',
                  style: TextStyle(
                    color: widget.disabledColor,
                    fontSize: contentOption.isActive ? 12 : 10,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onChangeCallback(contentOption) {
    if (widget.onChange != null) widget.onChange(contentOption);
  }
}
