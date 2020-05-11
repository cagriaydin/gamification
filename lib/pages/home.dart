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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ClipRect(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: <Widget>[
                  Container(
                    width: constraints.maxWidth,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                          width: constraints.maxWidth * 0.6 - 20,
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
                                    height: constraints.maxWidth * 0.3,
                                    width: constraints.maxWidth * 0.3,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white, width: 2.0),
                                      borderRadius: new BorderRadius.all(new Radius.circular(constraints.maxWidth * .2)),
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
                                padding: const EdgeInsets.only(bottom: 50),
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
                    width: constraints.maxWidth,
                    height: showMenu ? constraints.maxHeight * 0.8 : constraints.maxHeight,
                    top: showMenu ? constraints.maxHeight * 0.1 : 0,
                    left: showMenu ? constraints.maxWidth * 0.6 : 0,
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
                    duration: Duration(milliseconds: 200),
                  ),
                  showMenu
                      ? Positioned(
                          width: constraints.maxWidth,
                          height: showMenu ? constraints.maxHeight * 0.8 : constraints.maxHeight,
                          top: showMenu ? constraints.maxHeight * 0.1 : 0,
                          left: showMenu ? constraints.maxWidth * 0.6 : 0,
                          child: GestureDetector(
                            onTap: () {
                              openMenu();
                            },
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ))
                      : SizedBox(height: 0),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
