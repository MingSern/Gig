import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class Base extends ChangeNotifier {
  bool loading = false;
  String errorMessage;
  bool containsError = false;

  // Set ------------------------------------
  void isLoading(bool loading) {
    this.loading = loading;
    notifyListeners();
  }

  void setErrorMessage(String errorMessage) {
    this.errorMessage = errorMessage;
    this.containsError = true;
    notifyListeners();
  }

  void clearErrorMessage() {
    this.containsError = false;
    notifyListeners();
  }

  void showErrorMessage(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Oops!'),
        content: Text(this.errorMessage),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "OKAY",
              style: TextStyle(color: Palette.lapizBlue),
            ),
            onPressed: () {
              this.clearErrorMessage();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
