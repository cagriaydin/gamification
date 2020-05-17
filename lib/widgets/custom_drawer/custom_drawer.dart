import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  /// You should pass a [Scaffold] to build your page
  final Widget bodyBuilder;

  /// This is the Drawer you will build
  final Widget drawerBuilder;

  const CustomDrawer({
    Key key,
    this.bodyBuilder,
    this.drawerBuilder,
  }) : super(key: key);

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  double maxSlide;

  bool _canBeDragged;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
//    animationController.addListener(() {
//      /// Since it is using GlobalKey This trigger is needed.
//      setState(() {});
//    });
//    Animation curved =
//        CurvedAnimation(parent: animationController, curve: Curves.easeInCubic);

    super.initState();
  }

  @override
  void dispose() {
    print('CustomDrawerState disposed');
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    maxSlide = (size.width / 3 * 2);
    return GestureDetector(
      onHorizontalDragStart: onHorizontalDragStart,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: onHorizontalDragEnd,
      child: Scaffold(
        body: AnimatedBuilder(
          builder: (BuildContext context, Widget child) {
            final slide = maxSlide * animationController.value;
//            print(animationController.value);
            final scale = 1 - (animationController.value * .3);
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: widget.drawerBuilder,
                  ),
                ),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(slide)
                    ..scale(scale),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () =>
                        !animationController.isDismissed ? closeDrawer() : null,
                    child: IgnorePointer(
                      ignoring: !animationController.isDismissed,
                      child: widget.bodyBuilder,
                    ),
                  ),
                ),
              ],
            );
          },
          animation: animationController,
        ),
      ),
    );
  }

  toggle() {
    animationController.isDismissed
        ? animationController.forward()
        : animationController.reverse();
  }

  void openDrawer() {
    animationController.forward();
  }

  void closeDrawer() {
    animationController.reverse();
  }

  void setStateIfMounted(Function function) {
    if (mounted) {
      setState(() {
        function();
      });
    }
  }

  void onHorizontalDragStart(DragStartDetails details) {
//    print('dx ' + details.globalPosition.dx.toString());
//    print('dy ' + details.globalPosition.dy.toString());

    bool isDragOpenFromLeft = animationController.isDismissed &&
        details.globalPosition.dx < Offset.zero.dx + 30;
    bool isDragFromRight = animationController.isCompleted &&
        details.globalPosition.dx > Offset.zero.dx + maxSlide;

    _canBeDragged = isDragOpenFromLeft || isDragFromRight;
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
//    print(_canBeDragged);
//    print(maxSlide);
    if (_canBeDragged) {
//      print('details.primaryDelta' + details.primaryDelta.toString());
      double delta = details.primaryDelta / maxSlide;
      animationController.value += delta;
    }
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= 365) {
      double visualVelecity =
          details.velocity.pixelsPerSecond.dx / ((maxSlide / 2) * 3);
      animationController.fling(velocity: visualVelecity);
    } else if (animationController.value < 0.5) {
      closeDrawer();
    } else {
      openDrawer();
    }
  }
}
