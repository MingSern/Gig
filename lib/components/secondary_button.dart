import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  SecondaryButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.width = 150,
  });

  final String text;
  final GestureTapCallback onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: RawMaterialButton(
        elevation: 0,
        highlightElevation: 15,
        fillColor: Palette.ashGrey,
        splashColor: Colors.black12,
        highlightColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        constraints: BoxConstraints.tight(Size(this.width, 45)),
        child: Text(
          this.text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}
