import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yorglass_ik/widgets/flag_point.dart';

class FlagAvatar extends StatelessWidget {
  final String imageUrl;
  final int point;
  final int rank;
  final String name;

  const FlagAvatar({Key key, this.imageUrl, this.point, this.rank, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FlagPoint(point: point),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              name.isNotEmpty
                  ? Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  : Text(""),
              Padding(
                padding: name.isNotEmpty
                    ? const EdgeInsets.fromLTRB(8, 48, 8, 64)
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
                    top: 18.0,
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
          ? AssetImage("assets/default-profile.png")
          : MemoryImage(base64.decode(imageUrl));
    } catch (e) {
      print(e);
      return AssetImage("assets/default-profile.png");
    }
  }

  double getRadius(size) {
    double currentSize = (size.height < 700 || size.width < 400) ? 50 : 60;
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
