import 'package:flutter/material.dart';

class FlagPoint extends StatelessWidget {
  const FlagPoint({
    Key key,
    @required this.point,
  }) : super(key: key);

  final int point;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Transform.scale(
      scale: size.height < 600 ? .7 : .95,
      child: DefaultTextStyle(
        style: TextStyle(
          color: Color(0xff2DB3C1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/flag.png'),
                fit: BoxFit.contain,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (point ?? 0).toString(),
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                  ),
                  Text(
                    'puan',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
