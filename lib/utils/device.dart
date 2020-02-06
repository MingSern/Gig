import 'package:flutter/material.dart';

class Device {
  static dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  static goBack(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.maybePop(context);
  }

  static getMaxWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static getMaxHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static getFirstLetter(String string) {
    return string.substring(0, 1).toUpperCase();
  }
}
