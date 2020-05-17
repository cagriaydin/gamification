import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:yorglass_ik/models/task.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/widgets/build_user_info.dart';
import 'package:yorglass_ik/widgets/gradient_text.dart';

class TaskListPage extends StatelessWidget {
  final User user;
  final List<Task> tasks = [
    Task(
      name: 'Lıkır Lıkır 2 lt su içtim',
      point: 5,
      count: 1,
      id: '1233123',
      interval: 5,
    ),
    Task(
      name: 'Egzersiz yaptım',
      point: 5,
      count: 1,
      id: 'idd01234',
      interval: 1,
    ),
    Task(
      name: 'Lıkır Lıkır 2 lt su içtim',
      point: 5,
      count: 1,
      id: '1233123',
      interval: 5,
    ),
    Task(
      name: 'Egzersiz yaptım',
      point: 5,
      count: 1,
      id: 'idd01234',
      interval: 1,
    ),
    Task(
      name: 'Lıkır Lıkır 2 lt su içtim',
      point: 5,
      count: 1,
      id: '1233123',
      interval: 5,
    ),
    Task(
      name: 'Egzersiz yaptım',
      point: 5,
      count: 1,
      id: 'idd01234',
      interval: 1,
    ),
  ];

  TaskListPage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GradientText('%' + (user.percentage ?? 0).toString()),
              BuildUserInfo(
                user: user,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientText((user.point ?? 0).toString()),
                  GradientText('puan'),
                ],
              )
            ],
          ),
          Image.asset(
            'assets/task_divider.png',
            fit: BoxFit.fitWidth,
          ),
          Expanded(
            child: TaskListBuilder(
              length: tasks.length,
              taskBuilder: taskBuilder,
            ),
          ),
        ],
      ),
    );
  }

  Widget taskBuilder(context, index) {
    return BuildTask(
      task: tasks.elementAt(index),
    );
  }
}

class BuildTask extends StatefulWidget {
  final Task task;

  const BuildTask({Key key, this.task}) : super(key: key);

  @override
  _BuildTaskState createState() => _BuildTaskState();
}

class _BuildTaskState extends State<BuildTask> {
  int currentCount = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //TODO: add and show how much point task
          Text(widget.task.name),
          Text('#günlük',style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black54),),
          GestureDetector(
            onLongPress: () => setState(() => currentCount++),
            behavior: HitTestBehavior.opaque,
            child: StepperLinearIndicator(
              width: 200,
              height: 20,
              stepCount: widget.task.interval,
              currentCount: currentCount,
            ),
          ),
        ],
      ),
    );
  }
}

class StepperLinearIndicator extends StatelessWidget {
  final int stepCount;
  final int currentCount;
  final double width;
  final double height;

  const StepperLinearIndicator(
      {Key key, this.stepCount, this.width, this.height, this.currentCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    num paddingNodeWidth = 10;
    final stepWidth = (width) / stepCount;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(90)),
        border: Border.all(
          color: Color(0xff54B4BA),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          for (int i = currentCount - 1; i >= 0; i--)
            Positioned(
              top: 0,
              bottom: 0,
              left: i * stepWidth - (i * paddingNodeWidth),
              child: Container(
                width: stepWidth + paddingNodeWidth,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(90)),
                  border: Border.all(
                    color: Color(0xff54B4BA),
                  ),
                  gradient: LinearGradient(
                    colors: [Color(0xff54B4BA), Colors.white],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

typedef Widget TaskBuilder(context, index);

class TaskListBuilder extends StatefulWidget {
  final int length;
  final TaskBuilder taskBuilder;

  const TaskListBuilder({
    Key key,
    @required this.length,
    @required this.taskBuilder,
  }) : super(key: key);

  @override
  _TaskListBuilderState createState() => _TaskListBuilderState();
}

class _TaskListBuilderState extends State<TaskListBuilder>
    with AfterLayoutMixin {
  Size customPaintSize;

  GlobalKey customPaintKey = GlobalKey();

  OverlayEntry overlayEntry;

  ValueNotifier<Offset> offsetNotifier = ValueNotifier<Offset>(Offset.zero);

  List<Offset> currentOffsets = [];

  ScrollController controller = ScrollController();

  int position = 0;

  var decodedImage;

  @override
  void initState() {
    decodedImage = base64.decode(AuthenticationService.verifiedUser.image);
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
    return SingleChildScrollView(
      controller: controller,
      child: Container(
        key: customPaintKey,
        child: CustomPaint(
          foregroundPainter: MyCustomPainter(
            length: widget.length,
            getMaxLength: getMaxLength,
            getOffsets: getOffsets,
          ),
          size: getSize(size),
          child: Container(
            width: getSize(size).width,
            height: getSize(size).height,
            child: Column(
              children: [
                SizedBox(
                  height:
                      currentOffsets.isNotEmpty ? currentOffsets.first.dy : 10,
                ),
                for (int i = 0; i < widget.length; i++)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => animateToIndex(i),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 36, vertical: 8),
                        child: widget.taskBuilder(context, i),
                      ),
                    ),
                  ),
              ],
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
          controller.animateTo(
            offset.dy,
            duration: Duration(milliseconds: 600),
            curve: Curves.easeOut,
          );
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        customPaintSize = Size(customPaintSize.width, maxLength);
      });
    });
//    if (maxLength > customPaintSize.height) {}
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
                top: pos.dy - 40,
                left: pos.dx - 50,
                child: ShadowAvatar(
                  imageUrl: decodedImage,
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
  final int length;
  final Function getMaxLength;
  final Function getOffsets;

  MyCustomPainter({this.getMaxLength, this.getOffsets, @required this.length});

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

  int lengthOfList() => length;

  getP(index, p) {
    return p + (2 * p * index);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return (oldDelegate as MyCustomPainter).length != this.length;
  }
}

class ShadowAvatar extends StatelessWidget {
  final Uint8List imageUrl;

  const ShadowAvatar({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.width / 6,
      width: size.width / 6,
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
            child: Image.memory(
              imageUrl,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
