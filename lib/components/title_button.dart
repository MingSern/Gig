import 'package:flutter/material.dart';

class TitleButton extends StatefulWidget {
  final String title;
  final GestureTapCallback onTap;
  final Icon icon;

  TitleButton({
    @required this.title,
    @required this.onTap,
    this.icon,
  });

  @override
  _TitleButtonState createState() => _TitleButtonState();
}

class _TitleButtonState extends State<TitleButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            widget.icon,
          ],
        ),
      ),
    );
  }
}
