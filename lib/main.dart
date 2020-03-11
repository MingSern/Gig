import 'package:Gig/models/chat_room.dart';
import 'package:Gig/models/image_manager.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/root.dart';
import 'package:Gig/screens/auth/additional_info_screen.dart';
import 'package:Gig/screens/auth/register_as_screen.dart';
import 'package:Gig/screens/auth/register_screen.dart';
import 'package:Gig/screens/auth/verification_screen.dart';
import 'package:Gig/screens/chat/ChatRoomScreen.dart';
import 'package:Gig/screens/home/Employer/add_job_screen.dart';
import 'package:Gig/screens/home/Jobseeker/show_jobs_screen.dart';
import 'package:Gig/screens/home/filter_screen.dart';
import 'package:Gig/screens/home/job_info_screen.dart';
import 'package:Gig/screens/home/search_jobs_screen.dart';
import 'package:Gig/screens/profile/description_screen.dart';
import 'package:Gig/screens/profile/edit_image_screen.dart';
import 'package:Gig/screens/profile/view_profile_screen.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      ChangeNotifierProxyProvider<User, ChatRoom>(
        create: (_) => ChatRoom(),
        update: (_, user, chatRoom) => chatRoom..update(user),
      ),
      ChangeNotifierProxyProvider<User, ImageManager>(
        create: (_) => ImageManager(),
        update: (_, user, imageManager) => imageManager..update(user),
      ),
    ];

    final themeData = ThemeData(
      textSelectionHandleColor: Palette.lapizBlue,
      textSelectionColor: Palette.lapizBlue.withOpacity(0.2),
      cursorColor: Palette.lapizBlue,
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.grey,
      fontFamily: 'LexendDeca',
      appBarTheme: AppBarTheme(
        elevation: 0.7,
        color: Colors.white,
      ),
    );

    return GestureDetector(
      onTap: () => Device.dismissKeyboard(context),
      child: MultiProvider(
        providers: providers,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EasyJob',
          theme: themeData,
          home: Root(),
          routes: {
            '/register_as': (context) => RegisterAsScreen(),
            '/register': (context) => RegisterScreen(),
            '/verification': (context) => VerificationScreen(),
            '/additionalInfo': (context) => AdditionalInfoScreen(),
            '/job/info': (context) => JobInfoScreen(),
            '/home/job/show': (context) => ShowJobsScreen(),
            '/home/job/search': (context) => SearchJobsScreen(),
            '/home/job/filter': (context) => FilterScreen(),
            '/home/job/add': (context) => AddJobScreen(),
            '/home/job/info': (context) => JobInfoScreen(),
            '/chat/room': (context) => ChatRoomScreen(),
            '/profile/description/add': (context) => DescriptionScreen(),
            '/profile/image/edit': (context) => EditImageScreen(),
            '/profile/view': (context) => ViewProfileScreen(),
          },
        ),
      ),
    );
  }
}
