import 'package:flutter/material.dart';
import 'package:yorglass_ik/pages/bottom_navigation.dart';
import 'package:yorglass_ik/services/authentication-service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showMenu = false;
  openMenu() {
    setState(() {
      showMenu = !showMenu;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((value) => openMenu());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: width,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                    width: width * 0.6 - 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: width * 0.3,
                              width: width * 0.3,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 2.0),
                                borderRadius: new BorderRadius.all(new Radius.circular(width * .2)),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    AuthenticationService.verifiedUser.image,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              AuthenticationService.verifiedUser.name,
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              AuthenticationService.verifiedUser.branchName[0].toUpperCase() +
                                  AuthenticationService.verifiedUser.branchName.substring(1).toLowerCase() +
                                  ' İşletmesi',
                              style: TextStyle(fontSize: 18, color: Color(0xff4BADBB)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: GestureDetector(
                            onTap: () => AuthenticationService().signOut(),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.power_settings_new,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                Text("Çıkış")
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedPositioned(
              width: width,
              height: showMenu ? height * 0.8 : height,
              top: showMenu ? height * 0.1 : 0,
              left: showMenu ? width * 0.6 : 0,
              child: GestureDetector(
                onTap: () {
                  if (showMenu) openMenu();
                },
                child: Container(
                  child: BottomNavigation(
                    openMenu: openMenu,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 20,
                        color: Color(0xffD1F7FB),
                        offset: new Offset(0, 0),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
              duration: Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}
