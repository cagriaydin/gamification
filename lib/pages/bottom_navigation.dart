import 'package:flutter/material.dart';
import 'package:yorglass_ik/widgets/bottom.navi.bar.dart';

class BottomNavigation extends StatefulWidget {
  final Function openMenu;
  BottomNavigation({this.openMenu});
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => widget.openMenu(),
          child: Icon(
            Icons.menu,
            color: Color(0xff2DB3C1),
            size: 40,
          ),
        ),
        title: Center(child: Image.asset("assets/yorglass.png")),
        actions: <Widget>[
          Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.white,
        showElevation: true,
        // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
          _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
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
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
          if (_selectedIndex != 1) {
            _isEditMode = false;
          }
        },
        children: <Widget>[
          Container(),
          Container(),
        ],
      ),
    );
  }
}
