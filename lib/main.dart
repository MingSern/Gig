import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/root.dart';
import 'package:Gig/screens/chat/ChatRoomScreen.dart';
import 'package:Gig/screens/home/Employer/add_job_screen.dart';
import 'package:Gig/screens/home/Jobseeker/show_jobs_screen.dart';
import 'package:Gig/screens/home/filter_screen.dart';
import 'package:Gig/screens/home/job_info_screen.dart';
import 'package:Gig/screens/home/search_jobs_screen.dart';
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
      ChangeNotifierProvider<User>(create: (context) => User()),
      ChangeNotifierProxyProvider<User, Job>(
        create: (_) => Job(),
        update: (_, user, job) => job..update(user),
      ),
    ];

    final themeData = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.grey,
      fontFamily: 'LexendDeca',
      appBarTheme: AppBarTheme(
        elevation: 0,
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
            '/job/info': (context) => JobInfoScreen(),
            '/home/job/show': (context) => ShowJobsScreen(),
            '/home/job/search': (context) => SearchJobsScreen(),
            '/home/job/filter': (context) => FilterScreen(),
            '/home/job/add': (context) => AddJobScreen(),
            '/chat/room': (context) => ChatRoom(),
          },
        ),
      ),
    );
  }
}
