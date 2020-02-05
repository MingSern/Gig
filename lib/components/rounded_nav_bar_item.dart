import 'package:flutter/material.dart';

class RoundedNavBarItem extends StatelessWidget {
  RoundedNavBarItem({
    Key key,
    @required this.currentIndex,
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

  final int currentIndex;
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: AnimatedContainer(
        width: this.currentIndex == this.index ? this.expandWidth : this.shrinkWidth,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: this.currentIndex == this.index ? this.activeColor : Colors.transparent,
        ),
        padding: const EdgeInsets.only(left: 10),
        duration: Duration(milliseconds: 350),
        curve: Curves.decelerate,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Icon(this.iconData, color: this.currentIndex == this.index ? this.activeLabelColor : this.inactiveLabelColor),
            this.currentIndex == this.index
                ? Container(
                    alignment: Alignment(0, 0),
                    margin: const EdgeInsets.only(left: 5),
                    child: Text(
                      this.label,
                      style: TextStyle(
                        color: this.activeLabelColor,
                        fontWeight: FontWeight.bold,
                        fontSize: this.labelSize,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
