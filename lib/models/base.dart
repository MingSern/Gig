import 'package:Gig/components/primary_button.dart';
import 'package:Gig/enum/enum.dart';
import 'package:flutter/material.dart';

class Base extends ChangeNotifier {
  ViewState viewState = ViewState.idle;
  String errorMessage;
  bool containsError = false;

  // Set ------------------------------------
  void setState(ViewState viewState) {
    this.viewState = viewState;
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
          PrimaryButton(
            text: "Okay",
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
