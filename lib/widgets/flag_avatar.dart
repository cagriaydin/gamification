import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yorglass_ik/widgets/flag_point.dart';

class FlagAvatar extends StatelessWidget {
  final String imageUrl;
  final int point;
  final int rank;
  final String name;
  final String branchName;

  const FlagAvatar(
      {Key key,
      this.imageUrl,
      this.point,
      this.rank,
      this.name,
      this.branchName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          name.isNotEmpty
              ? Text(
                  name.length > 9 ? name.split(" ").join("\n") : name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                )
              : Text(""),
          if (branchName != null)
            SizedBox(
              height: 10,
            ),
          if (branchName != null)
            Row(
              children: [
                Image.asset(
                  "assets/white_pin.png",
                  width: 12,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  branchName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (point != null) FlagPoint(point: point),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: name.isNotEmpty
                        ? const EdgeInsets.fromLTRB(8, 20, 8, 64)
                        : const EdgeInsets.fromLTRB(8, 20, 8, 64),
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
                      top: name.isNotEmpty ? 20 : 6,
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
        ],
      ),
    );
  }

  getImagePadding() {
    if (rank == 1 && name.isNotEmpty) {
      return EdgeInsets.fromLTRB(8, 74, 8, 64);
    }
    if ((rank == 2 || rank == 3) && name.isNotEmpty) {
      return EdgeInsets.fromLTRB(8, 74, 8, 44);
    }
    return EdgeInsets.fromLTRB(8, 8, 8, 64);
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
