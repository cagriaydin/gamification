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
  List<String> myList = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];

  Size customPaintSize;

  GlobalKey customPaintKey = GlobalKey();

  OverlayEntry overlayEntry;

  ValueNotifier<Offset> offsetNotifier = ValueNotifier<Offset>(Offset.zero);

  List<Offset> currentOffsets = [];

  ScrollController controller = ScrollController();

  int position = 0;

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
          //final offset = currentOffsets.elementAt(currentOffsets.length - 1);
          if (position < currentOffsets.length) {
            final offset = currentOffsets.elementAt(position);
            offsetNotifier.value = offset ?? Offset.zero;
            position++;
          }
        });
      }),
      body: SingleChildScrollView(
        controller: controller,
        child: Container(
          key: customPaintKey,
          child: CustomPaint(
            foregroundPainter: MyCustomPainter(
                list: myList,
                getMaxLength: getMaxLength,
                getOffsets: getOffsets),
            size: getSize(size),
            child: Container(
              width: getSize(size).width,
              height: getSize(size).height,
              color: Colors.blue,
              child: Column(
                children: [
                  SizedBox(
                    height: currentOffsets?.first?.dy ?? 10,
                  ),
                  ...myList.map(
                        (e) => Flexible(
                            child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 1),
                          child: Container(
                            color: Colors.black,
                          ),
                        )),
                      )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Size getSize(Size size) => customPaintSize ?? size;

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
      //overlayOffset = pos;
      return ValueListenableBuilder(
        valueListenable: offsetNotifier,
        builder: (BuildContext context, Offset value, Widget child) {
          return AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget child) {
              final box = keyContext.findRenderObject() as RenderBox;
              final Offset pos = box.localToGlobal(value);
              //final top = box.size.height - 2000;
              return Positioned(
                top: pos.dy - 25,
                left: pos.dx,
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.black,
                ),
              );
            },
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
    offsets.add(Offset(p, p));
    for (int i = 0; i < lengthOfList(); i++) {
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

    getMaxLength((getP(lengthOfList(), p)));
    getOffsets(offsets);

    //buildPath(path, padding, archPadding, lineLength);
    canvas.drawPath(path, brush);
  }

  int lengthOfList() => list.length;

  getP(index, p) {
    return p + (2 * p * index);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return (oldDelegate as MyCustomPainter).list.length != this.list.length;
  }
}
