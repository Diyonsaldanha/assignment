import 'package:flutter/material.dart';
import 'package:task/screens/homepage.dart';
import 'package:task/screens/watchlistscreen.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectedIndex = 0;

  final List<Widget> _widgets = [
    HomePage(),
    WatchList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: _widgets[selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.house_outlined), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_customize_outlined), label: 'WL'),
          ],
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          }),
    );
  }
}
