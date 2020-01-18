import 'package:Gig/utils/device.dart';
import 'package:flutter/material.dart';

class RoundedNavBar extends StatefulWidget {
  RoundedNavBar({
    Key key,
    this.items,
    this.expandable = false,
    this.padding = const EdgeInsets.all(0),
  });

  final List<dynamic> items;
  final bool expandable;
  final EdgeInsets padding;

  @override
  _RoundedNavBarState createState() => _RoundedNavBarState();
}

class _RoundedNavBarState extends State<RoundedNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.expandable ? null : Device.getMaxHeight(context) * 0.085,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.items,
      ),
    );
  }
}
