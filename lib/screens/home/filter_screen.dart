import 'package:Gig/components/round_button.dart';
import 'package:Gig/utils/device.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
        title: Text("Filter by"),
        centerTitle: true,
        actions: <Widget>[
          RoundButton(
            icon: Icons.done,
            onPressed: () => Device.goBack(context),
          )
        ],
      ),
    );
  }
}
