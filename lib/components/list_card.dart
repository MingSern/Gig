import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final String fullname;
  final GestureTapCallback onTap;
  final GestureTapCallback onAccept;
  final GestureTapCallback onReject;

  ListCard({
    @required this.fullname,
    @required this.onTap,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              blurRadius: 15.0,
              offset: Offset(0.0, 4.0),
            ),
          ],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BuildUser(
              fullname: this.fullname,
            ),
            this.onAccept == null && this.onReject == null
                ? Container()
                : BuildButtons(
                    onAccept: this.onAccept,
                    onReject: this.onReject,
                  ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final text;
  final onPressed;
  final color;
  final iconData;

  Button({
    @required this.text,
    @required this.color,
    @required this.iconData,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints.expand(height: 40),
        child: OutlineButton(
          highlightElevation: 15,
          borderSide: BorderSide(
            color: this.color,
            style: BorderStyle.solid,
            width: 1.5,
          ),
          highlightedBorderColor: this.color,
          splashColor: Colors.black12,
          highlightColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                this.iconData,
                color: this.color,
              ),
              SizedBox(width: 5),
              Text(
                this.text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: this.color,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          onPressed: this.onPressed,
        ),
      ),
    );
  }
}

class BuildUser extends StatelessWidget {
  final fullname;

  BuildUser({
    @required this.fullname,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 35,
          backgroundColor: Palette.mustard,
          child: Text(
            Device.getFirstLetter(this.fullname),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          this.fullname,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 19,
          ),
        ),
      ],
    );
  }
}

class BuildButtons extends StatelessWidget {
  final onAccept;
  final onReject;

  BuildButtons({
    @required this.onAccept,
    @required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Button(
              text: "Decline",
              color: Colors.red,
              iconData: Icons.clear,
              onPressed: this.onReject,
            ),
            SizedBox(
              width: 10,
            ),
            Button(
              text: "Accept",
              color: Colors.green,
              iconData: Icons.check,
              onPressed: this.onAccept,
            ),
          ],
        ),
      ],
    );
  }
}
