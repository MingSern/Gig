import 'package:Gig/utils/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Non-empty work position returns null", () {
    var result = Validator.workPosition("salesperson");
    expect(result, null);
  });

  test("Empty work position returns error string", () {
    var result = Validator.workPosition("");
    expect(result, "Work position is empty");
  });

  test("Non-empty wages returns null", () {
    var result = Validator.wages("23");
    expect(result, null);
  });

  test("Empty wages returns error string", () {
    var result = Validator.wages("");
    expect(result, "Wages is empty");
  });

  test("Non-empty cateogry returns null", () {
    var result = Validator.category("Accountant");
    expect(result, null);
  });

  test("Empty cateogry returns error string", () {
    var result = Validator.category(null);
    expect(result, "Category is empty");
  });

  test("Non-empty age returns null", () {
    var result = Validator.age(23);
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

  test("Non-empty location returns null", () {
    var result = Validator.location("Selangor");
    expect(result, null);
  });

  test("Empty location returns null", () {
    var result = Validator.location(null);
    expect(result, "Location is empty");
  });

  test("Non-empty description returns null", () {
    var result = Validator.description("requirements are");
    expect(result, null);
  });

  test("Empty description returns null", () {
    var result = Validator.description("");
    expect(result, "Description is empty");
  });
}
