import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static confirmationDialog({
    @required BuildContext context,
    String title = 'Discard',
    String content = 'Are you sure?',
    String onConfirm = 'Discard',
    String onCancel = 'Cancel',
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text(
              onCancel.toUpperCase(),
              style: TextStyle(color: Palette.lapizBlue),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text(
              onConfirm.toUpperCase(),
              style: TextStyle(color: Palette.lapizBlue),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
