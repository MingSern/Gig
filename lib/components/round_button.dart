import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
  RoundButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
    this.margin = const EdgeInsets.all(5),
    this.fillColor = Colors.transparent,
    this.splashColor = Colors.black12,
  });

  final Icon icon;
  final GestureTapCallback onPressed;
  final EdgeInsets margin;
  final Color fillColor;
  final Color splashColor;

  @override
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: RawMaterialButton(
        elevation: 0,
        highlightElevation: 0,
        constraints: BoxConstraints.tight(Size(45, 45)),
        shape: CircleBorder(),
        fillColor: widget.fillColor,
        splashColor: widget.splashColor,
        child: widget.icon,
        onPressed: widget.onPressed,
      ),
    );
  }
}
