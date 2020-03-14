import 'package:Gig/animations/fade_in.dart';
import 'package:Gig/utils/device.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeIn(
        duration: Duration(seconds: 2),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  "assets/logo.png",
                  width: Device.getMaxWidth(context) * 0.4,
                  height: Device.getMaxWidth(context) * 0.4,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "EasyJob",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
