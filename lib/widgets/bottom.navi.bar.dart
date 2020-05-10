library bottom_navy_bar;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomNavyBar extends StatelessWidget {
  final int selectedIndex;
  final double iconSize;
  final Color backgroundColor;
  final bool showElevation;
  final Duration animationDuration;
  final List<BottomNavyBarItem> items;
  final ValueChanged<int> onItemSelected;
  final MainAxisAlignment mainAxisAlignment;
  final double itemCornerRadius;
  final Curve curve;

  BottomNavyBar({
    Key key,
    this.selectedIndex = 0,
    this.showElevation = true,
    this.iconSize = 30,
    this.backgroundColor,
    this.itemCornerRadius = 50,
    this.animationDuration = const Duration(milliseconds: 270),
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    @required this.items,
    @required this.onItemSelected,
    this.curve = Curves.linear,
  }) {
    assert(items != null);
    assert(items.length >= 2 && items.length <= 5);
    assert(onItemSelected != null);
    assert(curve != null);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = (backgroundColor == null)
        ? Theme.of(context).primaryColorLight
        : backgroundColor;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 15.0,
              offset: Offset(1, -0.2),
              spreadRadius: -5),
          BoxShadow(
              color: Colors.black12,
              blurRadius: 15.0,
              offset: Offset(-1, -0.2),
              spreadRadius: -5)
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(13), topRight: Radius.circular(13)),
      ),
      width: double.infinity,
      height: 88,
      padding: const EdgeInsets.only(top: 6),
      child: Material(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(13), topRight: Radius.circular(13)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: mainAxisAlignment,
              children: items.map((item) {
                final index = items.indexOf(item);
                return GestureDetector(
                  onTap: () => onItemSelected(index),
                  child: _ItemWidget(
                    item: item,
                    iconSize: iconSize,
                    isSelected: index == selectedIndex,
                    backgroundColor: bgColor,
                    itemCornerRadius: itemCornerRadius,
                    animationDuration: animationDuration,
                    curve: curve,
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final double iconSize;
  final bool isSelected;
  final BottomNavyBarItem item;
  final Color backgroundColor;
  final double itemCornerRadius;
  final Duration animationDuration;
  final Curve curve;

  const _ItemWidget({
    Key key,
    @required this.item,
    @required this.isSelected,
    @required this.backgroundColor,
    @required this.animationDuration,
    @required this.itemCornerRadius,
    @required this.iconSize,
    this.curve = Curves.linear,
  })  : assert(isSelected != null),
        assert(item != null),
        assert(backgroundColor != null),
        assert(animationDuration != null),
        assert(itemCornerRadius != null),
        assert(iconSize != null),
        assert(curve != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconTheme(
                data: IconThemeData(
                  size: iconSize,
                  color: isSelected
                      ? item.activeColor.withOpacity(1)
                      : item.inactiveColor == null
                          ? item.activeColor
                          : item.inactiveColor,
                ),
                child: item.icon,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  color: isSelected ? item.activeColor : item.inactiveColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 1,
                textAlign: item.textAlign,
                child: item.title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavyBarItem {
  final Icon icon;
  final Text title;
  final Color activeColor;
  final Color inactiveColor;
  final TextAlign textAlign;

  BottomNavyBarItem({
    @required this.icon,
    @required this.title,
    this.activeColor = Colors.blue,
    this.textAlign,
    this.inactiveColor,
  }) {
    assert(icon != null);
    assert(title != null);
  }
}
