class Validator {
  static String email(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (value.isEmpty)
      return "Email is empty";
    else if (!regex.hasMatch(value))
      return 'Enter a valid email';
    else
      return null;
  }

  static String password(String value) {
    if (value.isEmpty)
      return "Password is empty";
    else if (value.length < 6)
      return "Password with at least 6 characters";
    else
      return null;
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
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regex = new RegExp(pattern);

    if (value.isEmpty) {
      return "Phone number is empty";
    } else if (!regex.hasMatch(value)) {
      return "Enter a valid phone number.";
    }

    return null;
  }

  static String workPosition(String value) {
    return value.isEmpty ? "Work position is empty" : null;
  }

  static String wages(String value) {
    return value.isEmpty ? "Wages is empty" : null;
  }

  static String category(var value) {
    return value == null ? "Category is empty" : null;
  }

  static String location(var value) {
    return value == null ? "Location is empty" : null;
  }

  static String description(String value) {
    return value.isEmpty ? "Description is empty" : null;
  }
}
