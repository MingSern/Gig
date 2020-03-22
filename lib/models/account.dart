import 'package:Gig/enum/enum.dart';
import 'package:flutter/material.dart';

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
  RangeValues preferedWages;
  String gender;
  String age;

  Account(userType, email, password, fullname, age, gender, businessName, phoneNumber) {
    this.preferedCategories = new List<dynamic>();
    this.userType = userType;
    this.email = email;
    this.password = password;
    this.fullname = fullname;
    this.age = age;
    this.gender = gender;
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

  void setPreferedWages(RangeValues preferedWages) {
    this.preferedWages = preferedWages;
  }
}
