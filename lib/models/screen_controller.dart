import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/user.dart';
import 'package:flutter/material.dart';

class ScreenController extends ChangeNotifier {
  int currentIndex;

  ScreenController() {
    this.currentIndex = 0;
  }

  void update(User user) {
    if (user.authStatus == AuthStatus.notSignedIn) {
      this.currentIndex = 0;
    }
  }

  void setIndex(index) {
    this.currentIndex = index;
    notifyListeners();
  }

  void goTo({@required BuildContext context, @required int screenIndex}) {
    Navigator.of(context).popUntil((route) => route.isFirst);

    this.setIndex(screenIndex);
  }
}
