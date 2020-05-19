import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:yorglass_ik/models/user-task.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/repositories/task-repository.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/widgets/build_user_info.dart';
import 'package:yorglass_ik/widgets/gradient_text.dart';

class TaskListPage extends StatefulWidget {
  final User user;

  TaskListPage({Key key, this.user}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<UserTask> userTasks;

  ScrollController controller = ScrollController();

  final double kEffectHeight = 100;

  ValueNotifier<CrossFadeState> crossFade =
      ValueNotifier(CrossFadeState.showFirst);

  @override
  void initState() {
    controller.addListener(scrollControllerListener);
    TaskRepository.instance.getUserTasks();
    super.initState();
  }

  void scrollControllerListener() {
    if (controller.hasClients) {
//      print('**********************************************');
//      print(controller.offset);
//      print(controller.position.activity.isScrolling);
//      print(controller.position.userScrollDirection == ScrollDirection.forward);
//      print(controller.offset >= 300);
      if (controller.position.userScrollDirection == ScrollDirection.reverse &&
          controller.offset >= 400) {
        if (crossFade.value != CrossFadeState.showSecond) {
          setState(() {
            crossFade.value = CrossFadeState.showSecond;
          });
        }
      }
      if (controller.offset <= controller.position.minScrollExtent &&
          controller.offset < -150) {
        if (crossFade.value != CrossFadeState.showFirst) {
          setState(() {
            crossFade.value = CrossFadeState.showFirst;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    controller.removeListener(scrollControllerListener);
//    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
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
          AnimatedCrossFade(
            layoutBuilder:
                (topChild, topChildKey, bottomChild, bottomChildKey) {
              return Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    key: bottomChildKey,
                    top: 0,
                    child: bottomChild,
                  ),
                  Positioned(
                    key: topChildKey,
                    child: topChild,
                  ),
                ],
              );
            },
            crossFadeState: crossFade.value,
            duration: Duration(milliseconds: 600),
            secondChild: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                height: 150,
                width: size.width,
                padding: EdgeInsets.only(top: padding.top),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xff54B4BA),
                          offset: Offset(2, 3),
                          blurRadius: 4,
                          spreadRadius: 2)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      children: [
                        Flexible(
                            child: GradientText(
                                (widget.user.point ?? 0).toString())),
                        Flexible(
                          child: GradientText(
                            'puan',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            firstChild: Container(
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          GradientText(
                            '%',
                            fontWeight: FontWeight.w300,
                          ),
                          GradientText(
                              (widget.user.percentage ?? 0).toString()),
                        ],
                      ),
                      BuildUserInfo(
                        user: widget.user,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GradientText((widget.user.point ?? 0).toString()),
                          GradientText(
                            'puan',
                            fontWeight: FontWeight.w300,
                          ),
                        ],
                      )
                    ],
                  ),
                  Image.asset(
                    'assets/task_divider.png',
                    fit: BoxFit.fitWidth,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<UserTask>>(
              stream: TaskRepository.instance.currentUserTasks,
              builder: (BuildContext context,
                  AsyncSnapshot<List<UserTask>> snapshot) {
                final loader = Center(
                  child: CircularProgressIndicator(),
                );

                if (snapshot.hasData) {
//                  return Text('asdasdsfa');
                  userTasks = snapshot.data;
                  if (userTasks != null && userTasks.isNotEmpty) {
                    return TaskListBuilder(
                      crossFadeNotifier: crossFade,
                      controller: controller,
                      length: snapshot.data.length,
                      taskBuilder: taskBuilder,
                    );
                  } else
                    return loader;
                } else {
                  return loader;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget taskBuilder(
    context,
    index,
  ) {
    return BuildTask(
      userTask: userTasks.elementAt(index),
      isLeft: index % 2 != 0,
    );
  }
}

class BuildTask extends StatefulWidget {
  final UserTask userTask;
  final bool isLeft;

  const BuildTask({
    Key key,
    this.userTask,
    this.isLeft = true,
  }) : super(key: key);

  @override
  _BuildTaskState createState() => _BuildTaskState();
}

class _BuildTaskState extends State<BuildTask> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(
          left: widget.isLeft ? 16 : 0, right: widget.isLeft ? 0 : 16),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: widget.isLeft
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.userTask.task.name,
                      textAlign:
                          widget.isLeft ? TextAlign.left : TextAlign.right,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      getIntervalText(),
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.black54),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onDoubleTap: () => stepComplete(),
                      behavior: HitTestBehavior.opaque,
                      child: Opacity(
                        opacity: opacity(),
                        child: StepperLinearIndicator(
                          width: size.width / 2,
                          height: 20,
                          stepCount: widget.userTask.task.count,
                          currentCount: widget.userTask.count,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!widget.isLeft)
                  Positioned(
                    bottom: 2,
                    left: 8,
                    child: Transform.rotate(
                      angle: -math.pi / 6,
                      child: GradientText(
                        '+' + widget.userTask.point.toString() + '\n puan',
                        disabled: widget.userTask.complete == 0,
                        fontSize: 20,
                      ),
                    ),
                  ),
                if (widget.isLeft)
                  Positioned(
                    bottom: 2,
                    right: 8,
                    child: Transform.rotate(
                      angle: -math.pi / 6,
                      child: GradientText(
                        '+' + widget.userTask.point.toString() + '\n puan',
                        disabled: widget.userTask.complete == 0,
                        fontSize: 20,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  double opacity() {
    if (widget.userTask.complete == 1) {
      return 1;
    } else
      return TaskRepository.instance.canUpdate(widget.userTask) ? 1 : .2;
  }

  String getIntervalText() {
    switch (widget.userTask.task.interval) {
      case 1:
        return '#günlük';
      case 2:
        return '#haftalık';
      case 3:
        return '#aylık';
      default:
        return '#' +
            (widget.userTask.task.count - widget.userTask.count).toString() +
            ' adım kaldı';
    }
  }

  Future<void> stepComplete() async {
    await TaskRepository.instance.updateUserTask(widget.userTask);
    if (widget.userTask.complete == 1) {
      await AuthenticationService.instance.verifyUser();
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {});
    }
  }

  void taskComplete() {}
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
    num paddingNodeWidth = (width / stepCount) / 3;
    final lose = (stepCount - 2) * paddingNodeWidth;
    num stepWidth = (width + lose) / stepCount;

    return Container(
      width: width,
      height: height,
//      padding: EdgeInsets.all(5),
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
              left: left(i, stepWidth, paddingNodeWidth),
              child: Container(
                width: stepWidth + paddingNodeWidth,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(90)),
                  border: Border.all(
                    width: .5,
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

  double left(int i, double stepWidth, num paddingNodeWidth) =>
      i * stepWidth - (i * paddingNodeWidth);
}

typedef Widget TaskBuilder(context, index);

class TaskListBuilder extends StatefulWidget {
  final int length;
  final TaskBuilder taskBuilder;
  final ScrollController controller;

  final ValueNotifier<CrossFadeState> crossFadeNotifier;

  const TaskListBuilder({
    Key key,
    @required this.length,
    @required this.taskBuilder,
    @required this.controller,
    this.crossFadeNotifier,
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

  Timer _debounce;

  var lastPlace = GlobalKey();

  ScrollController get controller => widget.controller;

  int position = 0;

  var decodedImage;

  Offset initialPos = Offset.zero;

  @override
  void initState() {
    decodeImage();
    if (overlayEntry != null) {
      overlayEntry.remove();
    }
    overlayEntry = OverlayEntry(builder: (context) => overlayBuilder(context));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(overlayEntry);
    });
    super.initState();
  }

  void decodeImage() {
    try {
      decodedImage = base64.decode(AuthenticationService.verifiedUser.image);
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    widget.crossFadeNotifier.removeListener(crossFadeListener);
    if (_debounce != null) _debounce.cancel();
    overlayEntry.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      key: lastPlace,
      physics: BouncingScrollPhysics(),
      controller: controller,
      child: Container(
        key: customPaintKey,
        child: AnimatedBuilder(
          builder: (context, child) {
            final offset = controller.offset;
            return CustomPaint(
              foregroundPainter: MyCustomPainter(
                scrollPosition: offset,
                taskListBuilderSize: size / 1.2,
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
                      behavior: HitTestBehavior.opaque,
                      onTap: () => animateToIndex(i),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 8,
                        ),
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
          offset.dy - 10,
          duration: Duration(milliseconds: 600),
          curve: Curves.ease,
        );
      }
    }
  }

  Size getSize(Size size) => customPaintSize ?? size;

  getMaxLength(maxLength) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (maxLength != customPaintSize.height) {
        setState(() {
          customPaintSize = Size(customPaintSize.width, maxLength);
        });
      }
    });
//    if (maxLength > customPaintSize.height) {}
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    final size = MediaQuery.of(context).size;
    customPaintSize = size;
    final box = lastPlace.currentContext.findRenderObject() as RenderBox;
    initialPos = box.localToGlobal(Offset.zero);
    widget.crossFadeNotifier.addListener(crossFadeListener);
    animateToIndex(0);
  }

  void crossFadeListener() async {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      final box = lastPlace.currentContext.findRenderObject() as RenderBox;
      initialPos = box.localToGlobal(Offset.zero);
      animateToIndex(position);
    });
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
              var bool = (initialPos.dy > (pos.dy) || value.animate);
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
    return (oldDelegate as MyCustomPainter).length == this.length;
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
                  color: Color(0xff3FC1C9).withOpacity(.8),
                  offset: Offset(0, 3),
                  blurRadius: 10,
                  spreadRadius: 1.5),
              BoxShadow(
                  color: Color(0xff3FC1C9).withOpacity(.5),
                  offset: Offset(0, -3),
                  blurRadius: 10,
                  spreadRadius: 1.5),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipOval(
            clipBehavior: Clip.antiAlias,
            child: imageUrl == null
                ? Image.asset(
                    'assets/default-profile.png',
                    fit: BoxFit.fitWidth,
                  )
                : Image.memory(
                    imageUrl,
                    fit: BoxFit.fitWidth,
                  ),
          ),
        ),
      ),
    );
  }
}
