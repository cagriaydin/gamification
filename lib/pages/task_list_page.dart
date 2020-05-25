import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:yorglass_ik/helpers/popup_helper.dart';
import 'package:yorglass_ik/models/user-task.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/repositories/image-repository.dart';
import 'package:yorglass_ik/repositories/task-repository.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/widgets/build_user_info.dart';
import 'package:yorglass_ik/widgets/gradient_text.dart';
import 'package:yorglass_ik/widgets/user_percentage.dart';
import 'package:yorglass_ik/widgets/user_point.dart';

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
          controller.offset < -100) {
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
                height: size.height / 8,
                width: size.width,
                padding: EdgeInsets.only(top: padding.top),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xffC5F7FA),
                          offset: Offset(2, 3),
                          blurRadius: 4,
                          spreadRadius: 2)
                    ]),
                child: UserPoint(),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 90),
                        child: UserPercentage(),
                      ),
                      BuildUserInfo(
                        user: widget.user,
                        isTaskPage: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 90.0),
                        child: UserPoint(),
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

  final Function changePointCallback;

  const BuildTask({
    Key key,
    this.userTask,
    this.isLeft = true,
    this.changePointCallback,
  }) : super(key: key);

  @override
  _BuildTaskState createState() => _BuildTaskState();
}

class _BuildTaskState extends State<BuildTask> {
  ConfettiController confettiController;

  @override
  void initState() {
    confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    super.initState();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: widget.isLeft ? 60 : 0, right: widget.isLeft ? 0 : 60),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: widget.isLeft
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.userTask.task.name,
                    textAlign: widget.isLeft ? TextAlign.left : TextAlign.right,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    getIntervalText(),
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF26315F).withOpacity(.6),
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Opacity(
                    opacity: opacity(),
                    child: StepperLinearIndicator(
                      width: size.width / 2,
                      height: 20,
                      stepCount: widget.userTask.task.count,
                      currentCount: widget.userTask.count,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!widget.isLeft)
          Positioned(
            bottom: 32,
            right: 2,
            child: Opacity(
              opacity: opacity(),
              child: ButtonTheme(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                //adds padding inside the button
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //limits the touch area to the button area
                minWidth: 0,
                //wraps child's width
                height: 0,
                //wraps child's height
                child: FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(0),
                  hoverColor: Color(0xff3FC1C9).withOpacity(.7),
                  splashColor: Color(0xff3FC1C9).withOpacity(.7),
                  focusColor: Color(0xff3FC1C9).withOpacity(.7),
                  shape: CircleBorder(
                    side: BorderSide(color: Color(0xff3FC1C9), width: 2),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          widget.userTask.complete == 1
                              ? Color(0xff26315F)
                              : Colors.transparent,
                          widget.userTask.complete == 1
                              ? Color(0xff3FC1C9)
                              : Colors.transparent,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Transform.rotate(
                        angle: -math.pi / 10,
                        child: Column(
                          children: [
                            GradientText(
                              '+' + widget.userTask.point.toString(),
                              disabled: widget.userTask.complete == 0,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            GradientText(
                              'puan',
                              disabled: widget.userTask.complete == 0,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onPressed: () =>
                      TaskRepository.instance.canUpdate(widget.userTask)
                          ? stepComplete(context)
                          : cantComplete(),
                ),
              ),
            ),
          ),
        if (widget.isLeft)
          Positioned(
            bottom: 36,
            left: 2,
            child: Opacity(
              opacity: opacity(),
              child: ButtonTheme(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                //adds padding inside the button
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //limits the touch area to the button area
                minWidth: 0,
                //wraps child's width
                height: 0,
                //wraps child's height
                child: FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(0),
                  hoverColor: Color(0xff3FC1C9).withOpacity(.7),
                  splashColor: Color(0xff3FC1C9).withOpacity(.7),
                  focusColor: Color(0xff3FC1C9).withOpacity(.7),
                  shape: CircleBorder(
                    side: BorderSide(color: Color(0xff3FC1C9), width: 2),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          widget.userTask.complete == 1
                              ? Color(0xff26315F)
                              : Colors.transparent,
                          widget.userTask.complete == 1
                              ? Color(0xff3FC1C9)
                              : Colors.transparent,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Transform.rotate(
                        angle: math.pi / 10,
                        child: Column(
                          children: [
                            GradientText(
                              '+' + widget.userTask.point.toString(),
                              disabled: widget.userTask.complete == 0,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            GradientText(
                              'puan',
                              disabled: widget.userTask.complete == 0,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onPressed: () =>
                      TaskRepository.instance.canUpdate(widget.userTask)
                          ? stepComplete(context)
                          : cantComplete(),
                ),
              ),
            ),
          ),
      ],
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

  Future<void> stepComplete(BuildContext context) async {
    if (TaskRepository.instance.canUpdate(widget.userTask)) {
      await TaskRepository.instance.updateUserTask(widget.userTask);
      if (widget.userTask.complete == 1) {
        confettiController.play();
        context.read<User>().updatePoint();
//        await Future.delayed(Duration(milliseconds: 300));
//        if (widget.changePointCallback != null) widget.changePointCallback();
//        await Future.delayed(Duration(milliseconds: 1000));
//        confettiController.stop();
//        setState(() {});
      }
    }
  }

  void taskComplete() {}

  cantComplete() {
    PopupHelper().showPopup(context, Text('Bugünkü hakkını doldurdun'));
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
    num paddingNodeWidth = (width / stepCount) / 3;
    final lose = (stepCount - 2) * paddingNodeWidth;
    num stepWidth = (width + lose) / stepCount;

    return Container(
      width: width,
      height: height,
//      padding: EdgeInsets.all(.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(90)),
        border: Border.all(
          width: .5,
          color: Color(0xff54B4BA).withOpacity(.5),
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
                    width: .1,
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

  Future<void> decodeImage() async {
    try {
      var image = await ImageRepository.instance
          .getImage64(AuthenticationService.verifiedUser.image);
      decodedImage = base64.decode(image);
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
          offset.dy - 50,
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
    await Future.delayed(Duration(seconds: 1));
    final box = lastPlace.currentContext.findRenderObject() as RenderBox;
    initialPos = box.localToGlobal(Offset(0, 50));
    widget.crossFadeNotifier.addListener(crossFadeListener);
    animateToIndex(0);
  }

  void crossFadeListener() async {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      final box = lastPlace.currentContext.findRenderObject() as RenderBox;
      initialPos = box.localToGlobal(Offset(0, 50));
//      animateToIndex(position);
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
        Color(0xff2FB4C2).withOpacity(.3),
        Colors.white
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
          .createShader(Rect.fromLTWH(
        0.0,
        scrollPosition,
        taskListBuilderSize.width,
        taskListBuilderSize.height,
      ))
      ..strokeWidth = 5;

    final p = size.width / 5;
    final lastP = size.width - p;
    final radius = Radius.circular(85);

    Path path = new Path();
    path.moveTo(p, p);
    path.lineTo(lastP, p);
    List<Offset> offsets = [];
    final kOffsetValue = 30;
    offsets.add(Offset(lastP + kOffsetValue, p));
    for (int i = 0; i < lengthOfList(); i++) {
      final index = i + 1;
      bool secondPart = i % 2 == 0;
      if (!secondPart) {
        final offset = Offset(p, getP(index, p));
        path.arcToPoint(offset, radius: radius, clockwise: false);
        path.lineTo(lastP, getP(index, p));
        offsets.add(Offset(lastP + kOffsetValue, getP(index, p)));
      } else {
        final offset = Offset(lastP, getP(index, p));
        path.arcToPoint(offset, radius: radius);
        path.lineTo(p, getP(index, p));
        offsets.add(Offset(p, getP(index, p)));
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
            color: Color(0xFF3FC1C9).withOpacity(.1),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF3FC1C9).withOpacity(.5),
                  offset: Offset(0, 3),
                  blurRadius: 10,
                  spreadRadius: 1),
              BoxShadow(
                  color: Color(0xFF3FC1C9).withOpacity(.5),
                  offset: Offset(0, -3),
                  blurRadius: 10,
                  spreadRadius: 1),
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
