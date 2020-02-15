import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static exitApp(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Exit app"),
            content: Text("Are you sure you want to exit this application?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "CANCEL",
                  style: TextStyle(color: Palette.lapizBlue),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
              FlatButton(
                child: Text(
                  "EXIT",
                  style: TextStyle(color: Palette.lapizBlue),
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  static confirmationDialog({
    @required BuildContext context,
    String title = 'Discard',
    String content = 'Are you sure?',
    String onConfirm = 'Discard',
    String onCancel = 'Cancel',
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text(
              onCancel.toUpperCase(),
              style: TextStyle(color: Palette.lapizBlue),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text(
              onConfirm.toUpperCase(),
              style: TextStyle(color: Palette.lapizBlue),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}
