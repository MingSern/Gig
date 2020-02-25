import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

class Firebase {
  static Future<String> signIn(String email, String password) async {
    AuthResult result = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;

    return user.uid;
  }

  static Future<String> signUp(String email, String password) async {
    AuthResult result = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;

    return user.uid;
  }

  static Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await firebaseAuth.currentUser();

    return user;
  }

  static Future<void> signOut() async {
    return await firebaseAuth.signOut();
  }

  static Future<void> sendCodeToPhoneNumber(
      String phoneNumber, var autoRetrieve, var smsCodeSent, var verifySuccess, var verifyFailed) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verifySuccess,
      verificationFailed: verifyFailed,
    );
  }

  static Future<AuthResult> signInWithPhoneNumber(var credential) {
    return firebaseAuth.signInWithCredential(credential);
  }

  static void notificationSetup() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  static Future<String> getFCMToken() async {
    return await firebaseMessaging.getToken();
  }
}
