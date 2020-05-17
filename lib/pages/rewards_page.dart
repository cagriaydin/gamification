import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:yorglass_ik/services/authentication-service.dart';

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
        animateToIndex(6);
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
              child: Column(
                children: [
                  SizedBox(
                    height: currentOffsets.isNotEmpty
                        ? currentOffsets.first.dy
                        : 10,
                  ),
                  for (int i = 0; i < myList.length; i++)
                    Flexible(
                      child: GestureDetector(
                        onTap: () => animateToIndex(i),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 1),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void animateToIndex(int animateIndex) {
    if (mounted) {
      setState(() {
        position = animateIndex;
        if (position < currentOffsets.length) {
          final offset = currentOffsets.elementAt(position);
          offsetNotifier.value = offset ?? Offset.zero;
          controller.animateTo(offset.dy,
              duration: Duration(milliseconds: 600), curve: Curves.easeOut);
        }
      });
    }
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
                child: ShadowAvatar(
                  imageUrl: AuthenticationService.verifiedUser.image,
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
      ..color = Color(0xff3FC1C9)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

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

class ShadowAvatar extends StatelessWidget {
  final String imageUrl;

  const ShadowAvatar({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.width / 5,
      width: size.width / 5,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(90)),
            color: Color(0xff3FC1C9),
            boxShadow: [
              BoxShadow(
                  color: Color(0xff3FC1C9),
                  offset: Offset(0, 3),
                  blurRadius: 4,
                  spreadRadius: 1.2),
              BoxShadow(
                  color: Color(0xff3FC1C9),
                  offset: Offset(0, -3),
                  blurRadius: 4,
                  spreadRadius: 1.2),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ClipOval(
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              imageUrl,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }
}
