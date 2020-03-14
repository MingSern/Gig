import 'package:flutter/material.dart';

class ScreenController extends ChangeNotifier {
  int currentIndex = 0;

  void setIndex(index) {
    this.currentIndex = index;
    notifyListeners();
  }

  void goTo({@required BuildContext context, @required int screenIndex}) {
    Navigator.of(context).popUntil((route) => route.isFirst);

    this.setIndex(screenIndex);
  }
}
