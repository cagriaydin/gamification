import 'package:flutter/material.dart';

class ContentOption {
  final String title;
  final int count;
  bool isActive;

  ContentOption({@required this.title, this.count, this.isActive = false});
}
