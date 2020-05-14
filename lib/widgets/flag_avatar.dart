import 'package:flutter/material.dart';
import 'package:yorglass_ik/widgets/flag_point.dart';

class FlagAvatar extends StatelessWidget {
  final String imageUrl;
  final int point;
  final int rank;

  const FlagAvatar({Key key, this.imageUrl, this.point, this.rank})
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
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 64),
                child: Material(
                  elevation: 5,
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.all(Radius.circular(getRadius(size))),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: CircleAvatar(
                      radius: getRadius(size),
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  ),
                ),
              ),
              if (rank == 1)
                Image.asset(
                  'assets/crown.png',
                  scale: 1.4,
                ),
              Positioned(
                right: 8,
                top: 6,
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
