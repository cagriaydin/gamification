import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:yorglass_ik/helpers/statusbar-helper.dart';
import 'package:yorglass_ik/pages/home.dart';
import 'package:yorglass_ik/pages/welcome.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/shared/custom_theme.dart';

void main() {
// => runApp(
//       DevicePreview(
//         builder: (context) => MyApp(),
//         enabled: false,
//       ),
//     );
//{
//  CatcherOptions debugOptions = CatcherOptions(
//    SilentReportMode(),
//    [
//      ConsoleHandler(),
////      SlackHandler(
////        "https://hooks.slack.com/services/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",
////        "#app_errors",
////        username: "Yorglass",
////        enableDeviceParameters: true,
////        enableApplicationParameters: true,
////        enableCustomParameters: true,
////        enableStackTrace: true,
////        printLogs: true,
////      ),
//    ],
//  );

  /// Release configuration. Same as above, but once user accepts dialog, user will be propmpted to send email with crash to support.
//  CatcherOptions releaseOptions = CatcherOptions(
//    SilentReportMode(),
//    [
//      ConsoleHandler(),
//      SlackHandler(
//        "https://hooks.slack.com/services/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",
//        "#app_errors",
//        username: "Yorglass",
//        enableDeviceParameters: true,
//        enableApplicationParameters: true,
//        enableCustomParameters: true,
//        enableStackTrace: true,
//        printLogs: true,
//      ),
//    ],
//  );

  /// STEP 2. Pass your root widget (MyApp) along with Catcher configuration:
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loggedIn;
  bool hasConnection = false;

  @override
  void initState() {
    StatusbarHelper.setSatusBar();
    // AuthenticationService().signOut();
    listenConnection();
    AuthenticationService.firebaseAuthInstance.onAuthStateChanged
        .listen((event) {
      if (event != null) {
        AuthenticationService.instance.verifyUser().then((user) {
          if (user != null) {
            setState(() {
              loggedIn = true;
            });
          } else {
            setState(() {
              loggedIn = false;
            });
          }
        });
      } else {
        setState(() {
          loggedIn = false;
        });
      }
    });
//    Future.delayed(Duration(seconds: 2))
//        .then((val) => Catcher.sendTestException());
    Future.delayed(Duration(seconds: 5)).then((val) =>
        setState(() => loggedIn = loggedIn == null ? false : loggedIn));
    super.initState();
  }

  Future<bool> hasInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  void listenConnection() async {
    hasConnection = await this.hasInternet();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          hasConnection = true;
        });
      } else {
        setState(() {
          hasConnection = false;
        });
      }
    });
  }

  Widget getMainPage(bool loggedIn, bool hasConnection) {
    return hasConnection
        ? loggedIn == null
            ? Container()
            : (loggedIn ? HomePage() : WelcomePage())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white70,
                ),
              ),
//              SizedBox(
//                height: 20,
//              ),
//              Text(
//                "Lütfen bağlantınızı kontrol ediniz...",
//                style: TextStyle(
//                  fontSize: 18,
//                  fontStyle: FontStyle.italic,
//                ),
//              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      navigatorKey: Catcher.navigatorKey,
      // locale: DevicePreview.of(context).locale,
      // <--- Add the locale
      //builder: DevicePreview.appBuilder,
//      builder: (BuildContext context, Widget widget) {
//        Catcher.addDefaultErrorWidget(
//          showStacktrace: true,
//          title: "Error Occured",
//          description: "Error Description",
//          maxWidthForSmallMode: 150,
//        );
//        return widget;
//      },
      // <--- Add the builder
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: child);
      },
      home: Scaffold(
        body: getMainPage(loggedIn, hasConnection),
      ),
    );
  }
}
