import 'package:Gig/components/rounded_nav_bar.dart';
import 'package:Gig/components/rounded_nav_bar_item.dart';
import 'package:Gig/screens/profile/profile_screen.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class Screen {
  const Screen(this.label, this.icon);
  final String label;
  final IconData icon;
}

const List<Screen> screens = <Screen>[
  Screen('Home', Icons.home),
  Screen('List', Icons.list),
  Screen('Chat', Icons.chat_bubble_outline),
  Screen('Profile', Icons.person_outline),
];

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: this.currentIndex,
        children: <Widget>[
          Scaffold(),
          Scaffold(),
          Scaffold(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: RoundedNavBar(
        items: screens.map((Screen screen) {
          return RoundedNavBarItem(
            startIndex: currentIndex,
            index: screens.indexOf(screen),
            label: screen.label,
            activeColor: Palette.mustard,
            iconData: screen.icon,
            onTap: () {
              setState(() {
                currentIndex = screens.indexOf(screen);
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
