import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class PendingCard extends StatelessWidget {
  final String fullname;
  final GestureTapCallback onTap;
  final GestureTapCallback onAccept;
  final GestureTapCallback onReject;

  PendingCard({
    @required this.fullname,
    @required this.onTap,
    @required this.onAccept,
    @required this.onReject,
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
            Row(
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
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Button(
                  text: "Accept",
                  fillColor: Colors.green,
                  textColor: Colors.white,
                  onPressed: this.onAccept,
                ),
                SizedBox(
                  width: 10,
                ),
                Button(
                  text: "Reject",
                  fillColor: Colors.red,
                  textColor: Colors.white,
                  onPressed: this.onReject,
                ),
              ],
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
  final fillColor;
  final textColor;

  Button({
    @required this.text,
    @required this.fillColor,
    @required this.textColor,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RawMaterialButton(
        elevation: 0,
        highlightElevation: 15,
        fillColor: this.fillColor,
        splashColor: Colors.black12,
        highlightColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          this.text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: this.textColor,
            fontSize: 15,
          ),
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}
