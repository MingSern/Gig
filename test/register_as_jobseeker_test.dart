import 'package:Gig/utils/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Non-empty fullname returns null", () {
    var result = Validator.fullname("testing fullname");
    expect(result, null);
  });

  test("Empty fullname returns null", () {
    var result = Validator.fullname("");
    expect(result, "Full name is empty");
  });

  test("Non-empty age returns error null", () {
    var result = Validator.age("20");
    expect(result, null);
  });

  test("Empty age returns error string", () {
    var result = Validator.age(null);
    expect(result, "Age is empty");
  });

  test("Non-empty gender returns null", () {
    var result = Validator.gender("Male");
    expect(result, null);
  });

  test("Empty gender returns null", () {
    var result = Validator.gender(null);
    expect(result, "Gender is empty");
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
}
