import 'package:Gig/utils/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
