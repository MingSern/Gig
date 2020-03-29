import 'package:Gig/utils/algorithm.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Non-scam phrases returns false", () {
    var result = Algorithm.verifyMessage("blah");
    expect(result, false);
  });

  test("Potential scam phrases returns true", () {
    var result = Algorithm.verifyMessage("transfer money");
    expect(result, true);
  });
}
