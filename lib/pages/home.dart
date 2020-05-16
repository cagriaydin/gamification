import 'package:flutter/material.dart';
import 'package:yorglass_ik/pages/bottom_navigation.dart';
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
                spreadRadius: 20,
                color: Color(0xffD1F7FB),
                offset: new Offset(0, 0),
                blurRadius: 20,
              ),
            ],
          ),
        );
      }),
      drawerBuilder: Builder(builder: (context) {
        return SafeArea(
          child: Container(
            width: (size.width / 3) * 1.5,
            padding: EdgeInsets.only(top: 50,bottom: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: size.width / 4,
                      width: size.width / 4,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2.0),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(60)),
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
                      AuthenticationService.verifiedUser.branchName[0]
                              .toUpperCase() +
                          AuthenticationService.verifiedUser.branchName
                              .substring(1)
                              .toLowerCase() +
                          ' İşletmesi',
                      style: TextStyle(fontSize: 18, color: Color(0xff4BADBB)),
                    ),
                  ],
                ),
                Container(
                  child: GestureDetector(
                    onTap: () => AuthenticationService.instance.signOut(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
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
        );
      }),
    );
  }
}
