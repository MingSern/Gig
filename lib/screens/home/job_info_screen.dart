import 'package:Gig/components/round_button.dart';
import 'package:flutter/material.dart';

class JobInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          RoundButton(
            icon: Icons.more_horiz,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
