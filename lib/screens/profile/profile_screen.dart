import 'package:Gig/components/primary_button.dart';
import 'package:Gig/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    void logout() {
      user.logoutAccount();
    }

    return Scaffold(
      body: Center(
        child: PrimaryButton(
          text: "Logout",
          onPressed: logout,
        ),
      ),
    );
  }
}
