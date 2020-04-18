import 'dart:convert';

import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/account.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/services/ip_quality_score.dart';
import 'package:Gig/utils/validator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {
  Account account;
  AuthStatus authStatus = AuthStatus.notSignedIn;
  String errorMessage;

  @override
  Future<bool> verifyEmail() async {
    if (this.account.email == "yeomingsern@gmail.com") {
      return true;
    }

    return false;
  }

  @override
  Future<void> verifyAccount(Account account) async {
    this.account = account;
    bool verified = await this.verifyEmail();

    if (!verified) {
      this.errorMessage = "Please provide a valid email address.";
    }

    return null;
  }

  @override
  Future<void> verifyAndRegisterAccount(String smsCode) {
    // TODO: implement verifyAndRegisterAccount
    return null;
  }
}

void main() {
  group("Register as employer text fields validation", () {
    test("Non-empty business name returns null", () {
      var result = Validator.businessName("testing business name");
      expect(result, null);
    });

    test("Empty business name returns error string", () {
      var result = Validator.businessName("");
      expect(result, "Business/Company name is empty");
    });

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

    test("Non-empty phone number returns null", () {
      var result = Validator.phoneNumber("01234567678");
      expect(result, null);
    });

    test("Empty phone number returns error string", () {
      var result = Validator.phoneNumber("");
      expect(result, "Phone number is empty");
    });
  });

  group("Register as employer verification", () {
    test("Valid email and phone number returns returns null", () async {
      MockUser user = MockUser();
      Account account = Account(UserType.jobseeker, "yeomingsern@gmail.com", "password", "fullname", "age",
          "gender", "businessName", "+601110768827");

      await user.verifyAccount(account);
      var result = user.errorMessage;

      expect(result, null);
    });

    test("Invalid email returns error string", () async {
      MockUser user = MockUser();
      Account account = Account(UserType.jobseeker, "asdasdsad@gmsail.com", "password", "fullname", "age",
          "gender", "businessName", "+601110768827");

      await user.verifyAccount(account);
      var result = user.errorMessage;

      expect(result, "Please provide a valid email address.");
    });
  });
}
