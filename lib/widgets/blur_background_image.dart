import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

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
            child: imageUrl == null
                ? Image.asset("assets/default-profile.png")
                : MemoryImage(base64.decode(imageUrl))),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
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
