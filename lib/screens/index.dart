import 'package:Gig/components/rounded_nav_bar.dart';
import 'package:Gig/components/rounded_nav_bar_item.dart';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/screens/chat/ChatScreen.dart';
import 'package:Gig/screens/home/Employer/home_screen.dart' as Employer;
import 'package:Gig/screens/home/Jobseeker/home_screen.dart' as Jobseeker;
import 'package:Gig/screens/list/list_screen.dart';
import 'package:Gig/screens/profile/profile_screen.dart';
import 'package:Gig/services/firebase.dart';
import 'package:Gig/utils/dialogs.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    Firebase.notificationSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    Future<bool> onWillPop() {
      return Dialogs.exitApp(context);
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: this.currentIndex,
          children: <Widget>[
            user.isJobSeeker() ? Jobseeker.HomeScreen() : Employer.HomeScreen(),
            ListScreen(),
            ChatScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: RoundedNavBar(
          items: screens.map((Screen screen) {
            return RoundedNavBarItem(
              currentIndex: currentIndex,
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
      ),
    );
  }
}
