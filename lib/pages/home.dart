import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yorglass_ik/pages/bottom_navigation.dart';
import 'package:yorglass_ik/pages/suggestion.dart';
import 'package:yorglass_ik/pages/task_list_page.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/widgets/custom_drawer/custom_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<CustomDrawerState> drawerController;

  @override
  void initState() {
    drawerController = GlobalKey<CustomDrawerState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomDrawer(
      key: drawerController,
      bodyBuilder: Builder(builder: (context) {
        return Container(
          child: BottomNavigation(
            drawerController: drawerController,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                spreadRadius: 40,
                color: Color(0xffD1F7FB),
                offset: new Offset(0, 0),
                blurRadius: 40,
              ),
            ],
          ),
        );
      }),
      drawerBuilder: Builder(builder: (context) {
        return SafeArea(
          child: Container(
            width: (size.width / 3) * 1.7,
            padding: EdgeInsets.only(top: 50, bottom: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: size.width / 3,
                      width: size.width / 3,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2.0),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(90)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AuthenticationService.verifiedUser.image ==
                                  null
                              ? AssetImage("assets/default-profile.png")
                              : MemoryImage(base64.decode(
                                  AuthenticationService.verifiedUser.image)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      AuthenticationService.verifiedUser.name,
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).accentColor,
                        shadows: <Shadow>[
                          Shadow(
                            blurRadius: 4.0,
                            color: Color(0xFFE0ECF4),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AuthenticationService.verifiedUser.branchName,
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff4BADBB).withOpacity(.6)),
                            textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        MenuButton(
                          text: "Görevlerim",
                          icon: Icons.assistant_photo,
                          count: AuthenticationService.verifiedUser.taskCount,
                          click: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return TaskListPage(
                                  user: AuthenticationService.verifiedUser,
                                );
                              },
                            ),
                          ),
                        ),
                        MenuButton(
                            text: "Önerilerim",
                            icon: Icons.question_answer,
                            click: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SuggestionPage(),
                                  ),
                                )),
                        // MenuButton(
                        //   text: "KVKK Onayı",
                        //   icon: Icons.insert_drive_file,
                        //   click: () => Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => SuggestionPage(),
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
                MenuButton(
                    text: "Çıkış",
                    icon: Icons.power_settings_new,
                    click: () => AuthenticationService.instance.signOut()),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function click;
  final int count;

  const MenuButton({
    this.text,
    this.icon,
    this.click,
    this.count,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(left: 30, top: 20),
          child: GestureDetector(
            onTap: () => click(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  icon,
                  color: Theme.of(context).primaryColorDark,
                  size: 26,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 20,
                      shadows: <Shadow>[
                        Shadow(
                          blurRadius: 4.0,
                          color: Color(0xFFE0ECF4),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        if (count != null)
          Positioned(
            right: 50,
            top: 5,
            child: Container(
              width: 22,
              height: 22,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Color(0xFFF90A60),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textWidthBasis: TextWidthBasis.longestLine,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
