import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class SquareButton extends StatefulWidget {
  SquareButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.margin = const EdgeInsets.all(5),
    this.splashColor = Colors.black12,
    this.textColor = Colors.black87,
    this.highlightColor = Colors.transparent,
    this.width = 150,
    this.height = 45,
  });

  final String text;
  final GestureTapCallback onPressed;
  final EdgeInsets margin;
  final Color splashColor;
  final Color textColor;
  final Color highlightColor;
  final double width;
  final double height;

  @override
  _SquareButtonState createState() => _SquareButtonState();
}

class _SquareButtonState extends State<SquareButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: RawMaterialButton(
        elevation: 0,
        highlightElevation: 15,
        fillColor: Palette.mustard,
        splashColor: widget.splashColor,
        highlightColor: widget.highlightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        constraints: BoxConstraints.tight(Size(widget.width, widget.height)),
        child: Text(
          widget.text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.textColor,
            fontSize: 15,
          ),
        ),
        onPressed: widget.onPressed,
      ),
    );
  }
}
