import 'package:Gig/components/primary_button.dart';
import 'package:Gig/components/secondary_button.dart';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:Gig/components/round_button.dart';

class RegisterAsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "I am...",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            PrimaryButton(
              text: "Looking for part time jobs",
              width: double.infinity,
              onPressed: () => Navigator.pushNamed(context, '/register', arguments: UserType.jobseeker),
            ),
            SizedBox(
              height: 5,
            ),
            SecondaryButton(
              text: "Hiring",
              width: 200,
              onPressed: () => Navigator.pushNamed(context, '/register', arguments: UserType.employer),
            ),
          ],
        ),
      ),
    );
  }
}
