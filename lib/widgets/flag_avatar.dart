import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yorglass_ik/widgets/flag_point.dart';

class FlagAvatar extends StatelessWidget {
  final String imageUrl;
  final Uint8List image64;
  final int point;
  final int rank;
  final String name;
  final Color titleColor;
  final bool split;

  const FlagAvatar(
      {Key key,
      this.imageUrl,
      this.point,
      this.rank,
      this.name,
      this.image64,
      this.titleColor,
      this.split = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (point != null) FlagPoint(point: point),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              name.isNotEmpty
                  ? Text(
                      split
                          ? name.length > 10 ? name.split(" ").join("\n") : name
                          : name.length > 20
                              ? name.substring(
                                      0, name.length > 15 ? 15 : name.length) +
                                  '...'
                              : name,
                      style: TextStyle(
                        color: titleColor == null ? Colors.white : titleColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Text(""),
              Padding(
                padding: name.isNotEmpty
                    ? const EdgeInsets.fromLTRB(8, 64, 8, 64)
                    : const EdgeInsets.fromLTRB(8, 8, 8, 64),
                child: Material(
                  elevation: 5,
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.all(Radius.circular(getRadius(size))),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: CircleAvatar(
                      radius: getRadius(size),
                      backgroundImage: backgroundImage(),
                    ),
                  ),
                ),
              ),
              if (rank == 1)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 36.0,
                    right: 85,
                  ),
                  child: Image.asset(
                    'assets/crown.png',
                    scale: 1,
                  ),
                ),
              if (rank != null)
                Positioned(
                  right: name.isNotEmpty ? 10 : 8,
                  top: name.isNotEmpty ? 46 : 6,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(rank.toString()),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff26315F),
                              blurRadius: 2,
                              offset: Offset(0, 4)),
                          BoxShadow(
                              color: Color(0xff2DB3C1),
                              blurRadius: 2,
                              offset: Offset(0, 2))
                        ]),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  Object backgroundImage() {
    try {
      return imageUrl == null
          ? (image64 == null
              ? AssetImage("assets/default-profile.png")
              : MemoryImage(image64))
          : MemoryImage(base64.decode(imageUrl));
    } catch (e) {
      print(e);
      return AssetImage("assets/default-profile.png");
    }
  }

  double getRadius(size) {
    double currentSize = (size.height < 700 || size.width < 400) ? 60 : 70;
    if (rank == 1) {
      return currentSize;
    } else if (rank == 2) {
      return currentSize - 10;
    } else {
      return currentSize - 20;
    }
  }

  double getScale() {
    if (rank == 1) {
      return 2;
    } else if (rank == 2) {
      return 2.3;
    } else {
      return 2.8;
    }
  }
}
