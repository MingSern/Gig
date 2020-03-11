import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/screens/auth/login_screen.dart';
import 'package:Gig/screens/auth/splash_screen.dart';
import 'package:Gig/screens/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    switch (user.authStatus) {
      case AuthStatus.signedIn:
        return Index();
        break;
      case AuthStatus.notSignedIn:
        return LoginScreen();
        break;
      default:
        return SplashScreen();
        break;
    }
  }
}
