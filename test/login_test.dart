import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/screens/auth/login_screen.dart';
import 'package:Gig/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockUser extends Mock implements User {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  Future<void> loginAccount(String email, String password) {
    if (email == "email" && password == "password") {
      this.authStatus = AuthStatus.signedIn;
    }

    return null;
  }
}

void main() {
  group("Login text fields validation", () {
    test("Non-empty email returns null", () {
      var result = Validator.email("test@gmail.com");
      expect(result, null);
    });

    test("Empty email returns error string", () {
      var result = Validator.email("");
      expect(result, "Email is empty");
    });

    test("Non-empty password returns null", () {
      var result = Validator.email("password");
      expect(result, null);
    });

    test("Empty password returns error string", () {
      var result = Validator.password("");
      expect(result, "Password is empty");
    });
  });

  group("Login verification", () {
    test("Valid email and password returns signed in status", () async {
      MockUser user = MockUser();

      await user.loginAccount("email", "password");
      var result = user.authStatus;

      expect(result, AuthStatus.signedIn);
    });

    test("Invalid email or password returns not signed in status", () async {
      MockUser user = MockUser();

      await user.loginAccount("asd", "dfsdf");
      var result = user.authStatus;

      expect(result, AuthStatus.notSignedIn);
    });
  });

  // Widget testableWidget({Widget child, var provider}) {
  //   return MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider<User>(create: (context) => provider),
  //     ],
  //     child: MaterialApp(
  //       home: child,
  //     ),
  //   );
  // }

  // testWidgets("Login button", (WidgetTester tester) async {
  //   User user = User();
  //   LoginScreen loginScreen = LoginScreen();

  //   await tester.pumpWidget(testableWidget(child: loginScreen, provider: user));

  //   Finder emailField = find.byKey(Key("email_text_field"));
  //   await tester.enterText(emailField, "email");

  //   Finder passwordField = find.byKey(Key("password_text_field"));
  //   await tester.enterText(passwordField, "password");

  //   await tester.tap(find.byKey(Key("login_button")));

  //   verify(await user.loginAccount("email", "password")).called(1);
  //   var result = user.authStatus;

  //   expect(result, AuthStatus.signedIn);
  // });
}
