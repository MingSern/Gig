import 'package:Gig/enum/enum.dart';

class Account {
  UserType userType;
  String email;
  String password;
  String fullname;
  String businessName;
  String phoneNumber;
  String verificationId;
  String imageUrl;
  List<dynamic> preferedCategories;
  int preferedWages;

  Account(userType, email, password, fullname, businessName, phoneNumber) {
    this.preferedCategories = new List<dynamic>();
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

  void setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }

  void setPreferedCategories(List<dynamic> categories) {
    this.preferedCategories = List.from(categories);
  }

  void setPreferedWages(int wages) {
    this.preferedWages = wages;
  }
}
