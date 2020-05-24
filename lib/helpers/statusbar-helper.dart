import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class StatusbarHelper {
  static void setSatusBar() {
    // change the status bar color to material color [green-400]
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent).then((value) {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    });

// change the navigation bar color to material color [orange-200]
    FlutterStatusbarcolor.setNavigationBarColor(Colors.white).then((value) {
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
    });
  }
}
