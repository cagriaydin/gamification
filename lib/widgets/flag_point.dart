import 'package:flutter/material.dart';

class FlagPoint extends StatelessWidget {
  const FlagPoint({
    Key key,
    @required this.point,
  }) : super(key: key);

  final int point;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
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
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text((point ?? 0).toString()),
                Text('puan'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
