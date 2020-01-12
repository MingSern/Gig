import 'package:Gig/enum/enum.dart';

class Account {
  UserType userType;
  String email;
  String password;
  String fullname;
  String businessName;
  String phoneNumber;
  String verificationId;

  Account(userType, email, password, fullname, businessName, phoneNumber) {
    this.userType = userType;
    this.email = email;
    this.password = password;
    this.fullname = fullname;
    this.businessName = businessName;
    this.phoneNumber = phoneNumber;
  }

  void setVerificationId(verificationId) {
    this.verificationId = verificationId;
  }
}
