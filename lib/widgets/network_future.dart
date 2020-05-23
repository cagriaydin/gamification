import 'package:flutter/material.dart';

class NetworkFuture extends StatelessWidget {
  /// Container parameters
  /// that will be build on top of this widget
  final double height;
  final double width;
  final Alignment alignment;
  final Decoration decoration;

  final Future future;
  final AsyncWidgetBuilder childBuilder;
  final Widget Function() loadingBuilder;
  final AsyncWidgetBuilder errorBuilder;

  NetworkFuture({
    Key key,
    this.height,
    this.width,
    @required this.future,
    @required this.childBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.alignment = Alignment.center,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(
              height: height,
              width: width,
              decoration: decoration,
              alignment: alignment,
              child: loadingBuilder ??
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData && !snapshot.hasError) {
              return Container(
                height: height,
                width: width,
                decoration: decoration,
                alignment: alignment,
                child: childBuilder(context, snapshot),
              );
            } else {
              return Container(
                height: height,
                width: width,
                decoration: decoration,
                alignment: alignment,
                child: errorBuilder ??
                    const Center(
                      child: Icon(
                        Icons.error,
                      ),
                    ),
              );
            }
            break;
          default:
            return Container(
              height: height,
              width: width,
              decoration: decoration,
              alignment: alignment,
              child: errorBuilder ??
                  const Center(
                    child: Icon(
                      Icons.error,
                    ),
                  ),
            );
        }
      },
    );
  }
}
