import 'dart:ui';

import 'package:flutter/material.dart';

class BlurWidget extends StatelessWidget {
  const BlurWidget({
    Key key,
    this.child,
    this.backgroundChild,
  }) : super(key: key);

  final Widget backgroundChild;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.topCenter,
      children: [
        Opacity(
          opacity: .95,
          child: backgroundChild,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(.3),
                  Colors.white.withOpacity(.1),
                  Colors.white.withOpacity(.3),
                ],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
