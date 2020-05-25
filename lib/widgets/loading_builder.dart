import 'package:flutter/material.dart';

class LoadingBuilder extends StatelessWidget {
  final text;

  LoadingBuilder({this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Colors.white70,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
           text,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 24,
            ),
          )
        ],
      ),
    );
  }
}
