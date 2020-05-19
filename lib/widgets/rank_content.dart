
import 'package:flutter/material.dart';
import 'package:yorglass_ik/widgets/image_widget.dart';

class RankContent extends StatefulWidget {
  final bool selfContent;

  final int rank;
  final String image;
  final String title;
  final String subTitle;
  final int point;

  RankContent({
    this.selfContent = false,
    this.rank,
    this.image,
    this.title,
    this.point,
    this.subTitle,
  });

  @override
  _RankContentState createState() => _RankContentState();
}

class _RankContentState extends State<RankContent> {
  final color = Color(0xFF26315F);

  final index = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              widget.rank.toString(),
              style: TextStyle(
                fontSize: widget.selfContent ? 25 : 20,
                fontWeight: FontWeight.w300,
                color: color,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              width: widget.selfContent ? 50 : 45,
              height: widget.selfContent ? 50 : 45,
              child: Material(
                color: Color(0xFFC2F6FC).withOpacity(.6),
                borderRadius:
                    BorderRadius.all(Radius.circular(getRadius(size))),
                child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ImageWidget(
                      id: widget.image,
                      isBoardItem: true,
                    )),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: widget.title != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: widget.selfContent ? 22 : 20,
                            fontWeight: FontWeight.w300,
                            color: color),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/blue_pin.png",
                            scale: widget.selfContent ? 7 : 8,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              widget.subTitle,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color(0xFF4BADBB).withOpacity(.6),
                                fontSize: widget.selfContent ? 12 : 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.subTitle,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: color),
                        ),
                      )
                    ],
                  ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.point.toString(),
                  style: TextStyle(
                      fontSize: widget.selfContent ? 25 : 20,
                      fontWeight: FontWeight.w300,
                      color: color),
                ),
                Text(
                  "Puan",
                  style: TextStyle(
                      fontSize: widget.selfContent ? 15 : 12,
                      color: color,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double getRadius(size) {
    double currentSize = (size.height < 700 || size.width < 400) ? 50 : 60;
    return currentSize;
  }
}
