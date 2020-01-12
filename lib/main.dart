import 'package:Gig/models/user.dart';
import 'package:Gig/root.dart';
import 'package:Gig/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Gig/screens/register_as_screen.dart';
import 'package:Gig/screens/register_screen.dart';
import 'package:Gig/utils/device.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));

    final providers = [
      // ChangeNotifierProvider<Auth>(create: (context) => Auth()),
      ChangeNotifierProvider<User>(create: (context) => User()),
    ];

    final themeData = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.grey,
      appBarTheme: AppBarTheme(
        color: Colors.white,
      ),
    );

    return GestureDetector(
      onTap: () => Device.dismissKeyboard(context),
      child: MultiProvider(
        providers: providers,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Gig',
          theme: themeData,
          home: Root(),
          routes: {
            '/register_as': (context) => RegisterAsScreen(),
            '/register': (context) => RegisterScreen(),
            '/verification': (context) => VerificationScreen(),
          },
        ),
      ),
    );
  }
}
