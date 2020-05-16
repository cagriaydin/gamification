import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/user.dart';
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
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        }),
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
            user: User(
              point: 300,
              name: 'Ramazan Demir',
              branchName: 'Eskişehir İşletmesi ',
              code: '60017',
              image:
                  'https://vrl-eu-cdn.wetransfer.net/ivise/eyJwaXBlbGluZSI6W1sic3JnYiIse31dLFsiYXV0b19vcmllbnQiLHt9XSxbImdlb20iLHsiZ2VvbWV0cnlfc3RyaW5nIjoiNTEyeDUxMj4ifV0sWyJmb3JjZV9qcGdfb3V0Iix7InF1YWxpdHkiOjg1fV0sWyJzaGFycGVuIix7InJhZGl1cyI6MC43NSwic2lnbWEiOjAuNX1dLFsiZXhwaXJlX2FmdGVyIix7InNlY29uZHMiOjYwNDgwMH1dXSwic3JjX3VybCI6InMzOi8vd2V0cmFuc2Zlci1ldS1wcm9kLW91dGdvaW5nL2U2NjQ4MGMzOGY1OTUxOTc2ZDQ0MjRjZjc3NGViMDhlMjAyMDA1MTMxMDUzNTkvYmFmNmIxOWU4MjJlOTc3ZmZiMzJhNDg3MTg4ZGNlMTA5ODcwZDYxYSJ9/24d49e9ef8cb5f1be34bbe1cfd228e6cbb7a247f26aa702ec2b8268bfadadc0f',
              percentage: 75,
            ),
          ),
        ],
      ),
    );
  }

  toggleDrawer() {
    widget.drawerController.currentState.toggle();
  }
}
