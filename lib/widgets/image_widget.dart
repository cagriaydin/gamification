import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yorglass_ik/repositories/image-repository.dart';

class ImageWidget extends StatefulWidget {
  final String id;
  final bool isBoardItem;
  ImageWidget({this.id, this.isBoardItem = false});

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  String base64;

  @override
  void initState() {
    if (widget.id != null)
      ImageRepository.instance
          .getImage(widget.id)
          .then((value) => setState(() => base64 = value.base64));
    super.initState();
  }

  @override
  void didUpdateWidget(ImageWidget oldWidget) {
    if (widget.id != null)
      ImageRepository.instance
          .getImage(widget.id)
          .then((value) => setState(() => base64 = value.base64));
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.isBoardItem ? 90 : 0),
      child: base64 == null
          ? Container(
              child: Image.asset("assets/default-profile.png"),
            )
          : Image.memory(
              Base64Codec().decode(base64),
              fit: BoxFit.fill,
            ),
    );
  }
}
