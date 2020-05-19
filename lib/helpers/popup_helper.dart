import 'package:flutter/material.dart';

class PopupHelper {
  showPopup(BuildContext context, Widget widget) {
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            shadowColor: Color(0xFF02FB4C2),
            elevation: 10,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: size.width - 100,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: widget,
              ),
            ),
          ),
        );
      },
    );
  }
}
