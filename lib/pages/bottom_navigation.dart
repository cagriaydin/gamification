import 'package:flutter/material.dart';
import 'package:yorglass_ik/helpers/statusbar-helper.dart';
import 'package:yorglass_ik/pages/feed.dart';
import 'package:yorglass_ik/pages/profile.dart';
import 'package:yorglass_ik/widgets/bottom.navi.bar.dart';
import 'package:yorglass_ik/widgets/custom_drawer/custom_drawer.dart';

class BottomNavigation extends StatefulWidget {
  final GlobalKey<CustomDrawerState> drawerController;

  BottomNavigation({this.drawerController});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  /// We are changing the page with [_selectedIndex]
  /// also it activates the current [BottomNavyBarItem]
  int _selectedIndex = 0;

  /// It help us to animate between pages when we are changing tabs
  PageController _pageController;

  bool _isEditMode = false;

  @override
  void initState() {
    StatusbarHelper.setSatusBar();
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.white,
        showElevation: true,
        // use this to remove appBar's elevation
        onItemSelected: (index) {
          if (_selectedIndex == index) {
            return;
          }
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          });
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.notifications_none),
            title: Text('Bugün'),
            activeColor: Color(0xff2DB3C1),
            inactiveColor: Theme.of(context).primaryColor,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.extension),
            title: Text('Oyun'),
            activeColor: Color(0xff2DB3C1),
            inactiveColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          if (_selectedIndex == index) {
            return;
          }
          setState(() => _selectedIndex = index);
          if (_selectedIndex != 1) {
            _isEditMode = false;
          }
        },
        children: <Widget>[
          FeedPage(
            menuFunction: toggleDrawer,
          ),
          ProfilePage(
            menuFunction: toggleDrawer,
          ),
        ],
      ),
    );
  }

  toggleDrawer() {
    widget.drawerController.currentState.toggle();
  }
}
