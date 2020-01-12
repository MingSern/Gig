import 'package:flutter/material.dart';

class RoundedNavBarItem extends StatefulWidget {
  RoundedNavBarItem({
    Key key,
    @required this.startIndex,
    @required this.index,
    @required this.onTap,
    @required this.iconData,
    @required this.label,
    this.activeColor = Colors.grey,
    this.activeLabelColor = Colors.black87,
    this.inactiveLabelColor = Colors.black54,
    this.labelSize = 12,
    this.expandWidth = 90,
    this.shrinkWidth = 50,
  });

  final int startIndex;
  final int index;
  final GestureTapCallback onTap;
  final IconData iconData;
  final String label;
  final Color activeColor;
  final Color activeLabelColor;
  final Color inactiveLabelColor;
  final double labelSize;
  final double expandWidth;
  final double shrinkWidth;

  @override
  _RoundedNavBarItemState createState() => _RoundedNavBarItemState();
}


class _RoundedNavBarItemState extends State<RoundedNavBarItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        width: widget.startIndex == widget.index ? widget.expandWidth : widget.shrinkWidth,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: widget.startIndex == widget.index ? widget.activeColor : Colors.transparent,
        ),
        padding: const EdgeInsets.only(left: 10),
        duration: Duration(milliseconds: 350),
        curve: Curves.decelerate,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Icon(
              widget.iconData,
              color: widget.startIndex == widget.index ? 
                widget.activeLabelColor : widget.inactiveLabelColor
            ),

            widget.startIndex == widget.index ? 
            Container(
              alignment: Alignment(0, 0),
              margin: const EdgeInsets.only(left: 5),
              child: Text(
                widget.label, 
                style: TextStyle(
                  color: widget.activeLabelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.labelSize,
                ),
              ),
            ) : Container(),
          ],
        )
      ),
    );
  }
}