class Validator {
  static String email(String value) {
    return value.isEmpty ? "Email is empty" : null;
  }

  static String password(String value) {
    return value.isEmpty ? "Password is empty" : null;
  }

  static String fullname(String value) {
    return value.isEmpty ? "Full name is empty" : null;
  }

  static String businessName(String value) {
    return value.isEmpty ? "Business/Company name is empty" : null;
  }

  static String age(var value) {
    return value == null ? "Age is empty" : null;
  }

  static String gender(var value) {
    return value == null ? "Gender is empty" : null;
  }

  static String phoneNumber(String value) {
    return value.isEmpty ? "Phone number is empty" : null;
  }

  static String workPosition(String value) {
    return value.isEmpty ? "Work position is empty" : null;
  }

  static String wages(String value) {
    return value.isEmpty ? "Wages is empty" : null;
  }

  static String category(String value) {
    return value == null ? "Category is empty" : null;
  }

  static String location(String value) {
    return value == null ? "Location is empty" : null;
  }

  static String description(String value) {
    return value.isEmpty ? "Description is empty" : null;
  }
}
