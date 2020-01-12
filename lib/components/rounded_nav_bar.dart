import 'package:flutter/material.dart';

class RoundedNavBar extends StatefulWidget {
  RoundedNavBar({
    Key key,
    this.items,
    this.expandable = false,
  });

  final List<dynamic> items;
  final bool expandable;

  @override
  _RoundedNavBarState createState() => _RoundedNavBarState();
}

class _RoundedNavBarState extends State<RoundedNavBar> {
  _getMaxHeight() {
    return MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.expandable ? null : _getMaxHeight() * 0.085,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
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
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.items,
      ),
    );
  }
}
