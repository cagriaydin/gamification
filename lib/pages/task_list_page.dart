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
    final size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //TODO: add and show how much point task
          Text(widget.task.name),
          Text(
            '#günlük',
            style:
                TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
          ),
          GestureDetector(
            onLongPress: () => stepComplete(),
            behavior: HitTestBehavior.opaque,
            child: StepperLinearIndicator(
              width: size.width / 2,
              height: 20,
              stepCount: widget.task.interval,
              currentCount: currentCount,
            ),
          ),
        ],
      ),
    );
  }

  void stepComplete() {
    if (widget.task.interval > currentCount) {
      setState(() => currentCount++);
    }
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

  ValueNotifier<AnimateOffset> offsetNotifier =
      ValueNotifier<AnimateOffset>(AnimateOffset(Offset.zero, false));

  List<Offset> currentOffsets = [];

  ScrollController controller = ScrollController();

  int position = 0;

  var decodedImage;

  Offset initialPos = Offset.zero;

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
        child: AnimatedBuilder(
          builder: (context, child) {
            final offset = controller.offset;
            return CustomPaint(
              foregroundPainter: MyCustomPainter(
                scrollPosition: offset,
                taskListBuilderSize: size / 2,
                length: widget.length,
                getMaxLength: getMaxLength,
                getOffsets: getOffsets,
              ),
              size: getSize(size),
              child: child,
            );
          },
          animation: controller,
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

  Future<void> animateToIndex(int animateIndex) async {
    if (mounted) {
      if (position < currentOffsets.length) {
        Offset offset = currentOffsets.elementAt(position);
        offsetNotifier.value = AnimateOffset(offset ?? Offset.zero, true);
        position = animateIndex;
        offset = currentOffsets.elementAt(position);
        await Future.delayed(Duration(milliseconds: 600));
        offsetNotifier.value = AnimateOffset(offset ?? Offset.zero, false);
        controller.animateTo(
          offset.dy,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
      }
    }
  }

  Size getSize(Size size) => customPaintSize ?? size;

  getMaxLength(maxLength) {
    if (maxLength != customPaintSize.height) {
      RenderBox renderBox = customPaintKey.currentContext.findRenderObject();
      var global = renderBox.localToGlobal(Offset.zero);
//    print(global.dx);
//    print(global.dy);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          customPaintSize = Size(customPaintSize.width, maxLength);
        });
      });
    }
//    if (maxLength > customPaintSize.height) {}
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    customPaintSize = size;
    final box = customPaintKey.currentContext.findRenderObject() as RenderBox;
    initialPos = box.localToGlobal(Offset.zero);
  }

  overlayBuilder(BuildContext context) {
    final keyContext = customPaintKey.currentContext;
    if (keyContext != null) {
      // widget is visible
      //overlayOffset = pos;
      return ValueListenableBuilder(
        valueListenable: offsetNotifier,
        builder: (BuildContext context, AnimateOffset value, Widget child) {
          return AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget child) {
              final box = keyContext.findRenderObject() as RenderBox;
              final Offset pos = box.localToGlobal(value.offset);
              var bool = (initialPos.dy + 50 > (pos.dy) || value.animate);
              //final top = box.size.height - 2000;
              return Positioned(
                top: pos.dy - 40,
                left: pos.dx - 50,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: bool ? 0 : 1,
                  child: child,
                ),
              );
            },
            child: ShadowAvatar(
              imageUrl: decodedImage,
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

class AnimateOffset {
  final Offset offset;
  final bool animate;

  AnimateOffset(this.offset, this.animate);
}

class MyCustomPainter extends CustomPainter {
  final int length;
  final Function getMaxLength;
  final Function getOffsets;

  final Size taskListBuilderSize;

  final double scrollPosition;

  MyCustomPainter({
    this.scrollPosition,
    this.getMaxLength,
    this.getOffsets,
    @required this.length,
    this.taskListBuilderSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint brush = new Paint()
      ..color = Color(0xff3FC1C9).withOpacity(.5)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(colors: <Color>[
        Colors.white,
//        Color(0xff26315F),
        Color(0xff2FB4C2),
        Colors.white
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
          .createShader(Rect.fromLTWH(
        0.0,
        scrollPosition,
        taskListBuilderSize.width,
        taskListBuilderSize.height,
      ))
      ..strokeWidth = 15;

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
