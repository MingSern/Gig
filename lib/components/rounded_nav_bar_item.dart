import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class RoundedNavBarItem extends StatelessWidget {
  final IconData iconData;
  final GestureTapCallback onPressed;
  final String label;
  final int currentIndex;
  final int index;

  RoundedNavBarItem({
    @required this.iconData,
    @required this.onPressed,
    @required this.label,
    @required this.currentIndex,
    @required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: this.onPressed,
      icon: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            this.iconData,
            color: this.currentIndex == this.index ? Colors.black : Colors.grey,
          ),
          Text(
            this.label,
            style: TextStyle(
              fontSize: this.currentIndex == this.index ? 14 : 12,
              color: this.currentIndex == this.index ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
