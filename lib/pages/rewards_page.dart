import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

//
//class RewardsPage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(),
//      body: Center(
//        child: Text('here'),
//      ),
//    );
//  }
//}

class RewardsPage extends StatefulWidget {
  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> with AfterLayoutMixin {
  List<String> myList = [];

  Size customPaintSize;

  GlobalKey customPaintKey = GlobalKey();

  OverlayEntry overlayEntry;

  ValueNotifier<Offset> offsetNotifier = ValueNotifier<Offset>(Offset.zero);

  List<Offset> currentOffsets = [];

  @override
  void initState() {
    if (overlayEntry != null) {
      overlayEntry.remove();
    }
    overlayEntry = OverlayEntry(builder: (context) => overlayBuilder(context));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(overlayEntry);
    });
    super.initState();
  }

  @override
  void dispose() {
    overlayEntry.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          myList.add('value');
        });
        setState(() {
          final offset = currentOffsets.elementAt(myList.length);
          offsetNotifier.value = offset;
        });
      }),
      body: SingleChildScrollView(
        child: Container(
          key: customPaintKey,
          child: CustomPaint(
            painter: MyCustomPainter(
                list: myList,
                getMaxLength: getMaxLength,
                getOffsets: getOffsets),
            size: customPaintSize ?? size,
          ),
        ),
      ),
    );
  }

  getMaxLength(maxLength) {
    RenderBox renderBox = customPaintKey.currentContext.findRenderObject();
    var global = renderBox.localToGlobal(Offset.zero);
    print(global.dx);
    print(global.dy);

    if (maxLength > customPaintSize.height) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          customPaintSize = Size(customPaintSize.width, maxLength);
        });
      });
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    customPaintSize = size;
  }

  overlayBuilder(BuildContext context) {
    final keyContext = customPaintKey.currentContext;
    if (keyContext != null) {
      // widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      final Offset pos = box.localToGlobal(offsetNotifier.value);
      //overlayOffset = pos;
      return AnimatedBuilder(
        animation: offsetNotifier,
        builder: (BuildContext context, Widget child) {
          return Positioned(
            top: pos.dy,
            left: pos.dx,
            child: Container(
              width: 50,
              height: 50,
              color: Colors.black,
            ),
          );
        },
      );
    }
  }

  getOffsets(List<Offset> offsets) {
    currentOffsets = offsets;
  }
}

class MyCustomPainter extends CustomPainter {
  final List list;
  final Function getMaxLength;
  final Function getOffsets;

  MyCustomPainter({this.getMaxLength, this.list, this.getOffsets});

  @override
  void paint(Canvas canvas, Size size) {
    Paint brush = new Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final p = size.width / 5;
    final lastP = size.width - p;
    final radius = Radius.circular(85);

    Path path = new Path();
    path.moveTo(p, p);
    path.lineTo(lastP, p);
    List<Offset> offsets = [];
    for (int i = 0; i < list.length; i++) {
      final index = i + 1;
      bool secondPart = i % 2 == 0;
      if (!secondPart) {
        final offset = Offset(p, getP(index, p));
        path.arcToPoint(offset, radius: radius, clockwise: false);
        path.lineTo(lastP, getP(index, p));
        offsets.add(offset);
      } else {
        final offset = Offset(lastP, getP(index, p));
        path.arcToPoint(offset, radius: radius);
        path.lineTo(p, getP(index, p));
        offsets.add(offset);
      }
    }

    getMaxLength((getP(list.length, p) + p));
    getOffsets(offsets);

    //buildPath(path, padding, archPadding, lineLength);
    canvas.drawPath(path, brush);
  }

  getP(index, p) {
    return p + (2 * p * index);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
