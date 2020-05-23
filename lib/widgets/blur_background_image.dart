import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yorglass_ik/widgets/image_widget.dart';

class BlurBackgroundImage extends StatelessWidget {
  const BlurBackgroundImage({
    Key key,
    this.child,
    this.imageUrl,
  }) : super(key: key);

  final Widget child;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: .3,
          child: ImageWidget(id: imageUrl,borderRadius: BorderRadius.all(Radius.circular(0)),),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(.1),
                  Colors.white.withOpacity(.3),
                  Colors.white.withOpacity(.5),
                  Colors.white,
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
