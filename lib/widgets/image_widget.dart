import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yorglass_ik/repositories/image-repository.dart';

class ImageWidget extends StatefulWidget {
  final String id;
  ImageWidget({this.id});

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  String base64;
  @override
  void initState() {
    ImageRepository.instance.getImage(widget.id).then((value) => setState(() => base64 = value.base64));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return base64 == null
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white70,
              ),
            ),
          )
        : Image.memory(Base64Codec().decode(base64));
  }
}
