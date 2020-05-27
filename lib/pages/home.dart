import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get_version/get_version.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/pages/bottom_navigation.dart';
import 'package:yorglass_ik/pages/suggestion.dart';
import 'package:yorglass_ik/pages/task_list_page.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/widgets/custom_drawer/custom_drawer.dart';
import 'package:yorglass_ik/widgets/image_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<CustomDrawerState> drawerController;

  @override
  void initState() {
    drawerController = GlobalKey<CustomDrawerState>();
    handleRemoteConfig(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => AuthenticationService.verifiedUser,
      child: CustomDrawer(
        key: drawerController,
        bodyBuilder: Builder(builder: (context) {
          return Container(
            child: BottomNavigation(
              drawerController: drawerController,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
//                border: Border.all(color: Color(0xffD1F7FB),width: 5)
              //TODO: as performance improvements remove shodows if needed
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
              padding: EdgeInsets.only(
                  top: size.height / 20, bottom: size.height / 20),
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
                        child: ImageWidget(
                            id: AuthenticationService.verifiedUser.image),
                      ),
                      SizedBox(height: size.height / 40),
                      Text(
                        AuthenticationService.verifiedUser.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).accentColor,
                          shadows: <Shadow>[
                            Shadow(
                              blurRadius: 4.0,
                              color: Color(0xFFE0ECF4),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height / 40),
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
                        height: size.height / 30,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Consumer<User>(
                            builder: (_, User value, __) {
                              return MenuButton(
                                text: "Görevlerim",
                                icon: Icons.assistant_photo,
                                count: AuthenticationService
                                    .verifiedUser.taskCount,
                                click: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      final userProvider =
                                          Provider.of<User>(context);
                                      return ChangeNotifierProvider.value(
                                        value: userProvider,
                                        child: TaskListPage(
                                          user: AuthenticationService
                                              .verifiedUser,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          MenuButton(
                            text: "Önerilerim",
                            icon: Icons.question_answer,
                            click: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SuggestionPage(),
                              ),
                            ),
                          ),
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
                      ),
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
      ),
    );
  }

  handleRemoteConfig(BuildContext context) async {
    try {
      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      await remoteConfig.fetch(expiration: Duration(minutes: 1));
      await remoteConfig.activateFetched();
      var map = jsonDecode(remoteConfig.getString('app_version'));
      var currentVersion = await GetVersion.projectVersion;
      final sharedPref = await SharedPreferences.getInstance();
      if (map['version'] != currentVersion) {
        if (!map['forced'] &&
            sharedPref.getBool(map['version']) != null &&
            sharedPref.getBool(map['version'])) {
          return;
        }
        if (!map['forced']) {
          sharedPref.setBool(map['version'], true);
        }
        await Future.delayed(Duration(milliseconds: 2000));
        final title = map['forced']
            ? 'Uygulamayı güncellemelisiniz.'
            : 'Yeni sürüm mevcut';
        showDialog(
          context: context,
          barrierDismissible: !map['forced'],
          useRootNavigator: false,
          builder: (context) {
            return WillPopScope(
              onWillPop: () async {
                //                if (!map['forced']) {
                //                  sharedPref.remove(map['version']);
                //                }

                //              if (!map['forced']) {
                //                sharedPref.setBool(map['version'], false);
                //              }
                return !map['forced'];
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(title)
                                ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                if (!map['forced'])
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Material(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: InkWell(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        onTap: () {
                                          //                                        if (!map['forced']) {
                                          //                                          sharedPref.remove(map['version']);
                                          //                                        }
                                          sharedPref.setBool(
                                              map['version'], true);
                                          return Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Tekrar Gösterme',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Material(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: InkWell(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      onTap: () {
                                        OpenAppstore.launch(
                                          androidAppId:
                                              'com.ciplidev.network_up',
                                          iOSAppId: '1499186365',
                                        );
                                        if (!map['forced']) {
                                          sharedPref.setBool(
                                              map['version'], false);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          'Güncelle!',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      print(e);
      return;
    }
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
            left: 160,
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
