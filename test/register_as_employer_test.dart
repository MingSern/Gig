import 'package:Gig/utils/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
