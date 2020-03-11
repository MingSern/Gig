import 'package:Gig/components/floaty_card.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class FilterCard extends StatelessWidget {
  final String title;
  final String value;
  final Widget child;

  FilterCard({
    @required this.title,
    this.value,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FloatyCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  this.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                this.value == null
                    ? Container()
                    : Text(
                        " " + this.value,
                        style: TextStyle(
                          color: Palette.lapizBlue,
                          fontSize: 16,
                        ),
                      ),
              ],
            ),
          ),
          this.child,
        ],
      ),
    );
  }
}
