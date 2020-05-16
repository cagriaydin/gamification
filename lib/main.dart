import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:yorglass_ik/pages/home.dart';

import 'package:yorglass_ik/pages/welcome.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/shared/custom_theme.dart';

void main() => runApp(
      DevicePreview(
        builder: (context) => MyApp(),
        enabled: false,
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loggedIn;
  bool hasConnection = false;
  @override
  void initState() {
    // AuthenticationService().signOut();
    listenConnection();
    AuthenticationService.firebaseAuthInstance.onAuthStateChanged.listen((event) {
      if (event != null) {
        setState(() {
          loggedIn = true;
        });
      } else {
        setState(() {
          loggedIn = false;
        });
      }
    });
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
              SizedBox(
                height: 20,
              ),
              Text(
                "Lütfen bağlantınızı kontrol ediniz...",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.of(context).locale,
      // <--- Add the locale
      builder: DevicePreview.appBuilder,
      // <--- Add the builder
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      home: Scaffold(
        body: getMainPage(loggedIn, hasConnection),
      ),
    );
  }
}
