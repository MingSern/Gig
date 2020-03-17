import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final bool linear;

  Loading({
    this.linear = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: this.linear
          ? SizedBox(
              height: 2,
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Palette.mustard),
                backgroundColor: Colors.transparent,
              ),
            )
          : SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                backgroundColor: Colors.transparent,
              ),
            ),
    );
  }
}
