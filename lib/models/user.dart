import 'dart:convert';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/account.dart';
import 'package:Gig/models/base.dart';
import 'package:Gig/services/firebase.dart';
import 'package:Gig/services/ip_quality_score.dart';
import 'package:Gig/utils/checker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final Firestore firestore = Firestore.instance;

class User extends Base {
  String userId;
  AuthStatus authStatus;
  Account account;
  String shortlisted = "0";
  String applied = "0";
  dynamic otherUser;
  bool profileCompleted = false;

  User() {
    this.authenticate();
  }

  Future<void> authenticate() async {
    await Firebase.getCurrentUser().then((user) async {
      if (user != null) {
        this.setId(user.uid);

        await Future.wait([
          this.getAccount(),
          this.getApplied(),
          this.getShortlisted(),
          this.subscribeFcmToken(),
        ]);

        this.authStatus = AuthStatus.signedIn;
      } else {
        this.authStatus = AuthStatus.notSignedIn;
      }
    }).catchError((onError) {
      setErrorMessage(onError.message);
      this.authStatus = AuthStatus.notSignedIn;
    });

    notifyListeners();
  }

  Future<void> subscribeFcmToken() async {
    String fcmToken = await Firebase.getFCMToken();

    firestore.collection("accounts").document(this.userId).collection("token").document(fcmToken).setData({
      "fcmToken": fcmToken,
    });
  }

  Future<void> unsubscribeFcmToken() async {
    String fcmToken = await Firebase.getFCMToken();

    firestore.collection("accounts").document(this.userId).collection("token").document(fcmToken).delete();
  }

  void setId(String userId) {
    this.userId = userId;
  }

  void setAccount(Account account) {
    this.account = account;
    notifyListeners();
  }

  Future<void> getAccount() async {
    DocumentSnapshot snapshot = await firestore.collection("accounts").document(this.userId).get();
    var accountData = snapshot.data;

    UserType userType = Checker.getUserType(accountData["userType"]);
    String email = accountData["email"];
    String fullname = accountData["fullname"];
    String businessName = accountData["businessName"] ?? "";
    String phoneNumber = accountData["phoneNumber"];
    String imageUrl = accountData["imageUrl"] ?? "";
    List<dynamic> preferredCategories = accountData["preferredCategories"] ?? [];
    String preferredWages = accountData["preferredWages"];
    String gender = accountData["gender"];
    String age = accountData["age"];

    Account account = new Account(userType, email, null, fullname, age, gender, businessName, phoneNumber);

    account.setImageUrl(imageUrl);
    account.setPreferredCategories(preferredCategories);

    if (preferredWages == null) {
      account.setPreferredWages(RangeValues(10, 100));
    } else {
      List<String> values = preferredWages.split("-");
      double start = double.parse(values.first);
      double end = double.parse(values.last);

      account.setPreferredWages(RangeValues(start, end));
    }

    this.setAccount(account);
  }

  // Account -----------------------------------------------------------------------------------------
  Future<void> loginAccount(String email, String password) async {
    isLoading(true);

    await Firebase.signIn(email, password).then((_) async {
      await this.authenticate();
    }).catchError((onError) {
      setErrorMessage(onError.message);
    });

    isLoading(false);
  }

  Future<void> verifyAccount(Account account) async {
    isLoading(true);

    try {
      var verificationId;
      this.account = account;

      // bool verified = await this.verifyEmail();
      bool verified = true;

      if (verified) {
        final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
          verificationId = verId;
        };

        final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
          verificationId = verId;
          account.setVerificationId(verId);
          this.setAccount(account);
        };

        final PhoneVerificationCompleted verifySuccess = (AuthCredential user) {
          print("verified $verificationId");
        };

        final PhoneVerificationFailed verifyFailed = (AuthException exception) {
          print('${exception.toString()}');
        };

        await Firebase.sendCodeToPhoneNumber(
                account.phoneNumber, autoRetrieve, smsCodeSent, verifySuccess, verifyFailed)
            .catchError((onError) {
          setErrorMessage(onError.message);
        });
      } else {
        setErrorMessage("Please provide a valid email address.");
      }
    } catch (e) {
      setErrorMessage("Seems like you are currently offline. Turn back on your Wifi an try again.");
    }

    isLoading(false);
  }

  Future<bool> verifyEmail() async {
    Response response = await IpQualityScore.call(this.account.email);
    var data = json.decode(response.body);

    if (data["valid"]) {
      return true;
    }

    return false;
  }

  Future<void> verifyAndRegisterAccount(String smsCode) async {
    isLoading(true);

    var credential = PhoneAuthProvider.getCredential(
      verificationId: this.account.verificationId,
      smsCode: smsCode,
    );

    AuthResult result = await Firebase.signInWithPhoneNumber(credential).catchError((onError) {
      setErrorMessage(onError.message);
    });

    if (result?.user != null) {
      String userId = await Firebase.signUp(this.account.email, this.account.password).catchError((onError) {
        setErrorMessage(onError.message);
      });

      this.setId(userId);

      Map<String, dynamic> data = {
        "userType": this.account.userType.toString(),
        "uid": this.userId,
        "fullname": this.account.fullname,
        "email": this.account.email,
        "phoneNumber": this.account.phoneNumber,
        "imageUrl": this.account.imageUrl,
        "pendings": [],
        "shortlists": [],
      };

      if (this.account.userType == UserType.employer) {
        data["businessName"] = this.account.businessName;
      } else {
        data["preferredCategories"] = [];
        data["age"] = this.account.age;
        data["gender"] = this.account.gender;
      }

      var userRef = firestore.collection("accounts").document(this.userId);

      await userRef.setData(data).then((_) async {
        await this.authenticate();
      });
    } else {
      setErrorMessage("User not exist.");
    }

    isLoading(false);
  }

  Future<void> logoutAccount() async {
    isLoading(true);

    await Firebase.signOut().then((_) async {
      await this.authenticate();
      await this.unsubscribeFcmToken();
    }).catchError((onError) {
      setErrorMessage(onError.message);
    });

    isLoading(false);
  }

  // Methods ------------------------------------------
  void setApplied(int length) {
    this.applied = length.toString();
    notifyListeners();
  }

  void setShortlisted(int length) {
    this.shortlisted = length.toString();
    notifyListeners();
  }

  Future<void> getApplied() async {
    var documents =
        await firestore.collection("accounts").document(this.userId).collection("pendings").getDocuments();

    this.setApplied(documents.documents.length);
  }

  Future<void> getShortlisted() async {
    var documents =
        await firestore.collection("accounts").document(this.userId).collection("shortlists").getDocuments();

    this.setShortlisted(documents.documents.length);
  }

  Stream<QuerySnapshot> getDescriptions() {
    return firestore.collection("accounts").document(this.userId).collection("descriptions").snapshots();
  }

  Future<void> createDescription(String title, String description) async {
    isLoading(true);

    var data = {
      "title": title,
      "description": description,
    };

    await firestore
        .collection("accounts")
        .document(this.userId)
        .collection("descriptions")
        .add(data)
        .catchError((onError) {
      setErrorMessage(onError.toString());
    });

    isLoading(false);
  }

  Future<void> editDescription(String documentId, String title, String description) async {
    isLoading(true);

    var updateData = {
      "title": title,
      "description": description,
    };

    await firestore
        .collection("accounts")
        .document(this.userId)
        .collection("descriptions")
        .document(documentId)
        .updateData(updateData)
        .catchError((onError) {
      setErrorMessage(onError.toString());
    });

    isLoading(false);
  }

  Future<void> deleteDescription(String documentId) async {
    isLoading(true);

    await firestore
        .collection("accounts")
        .document(this.userId)
        .collection("descriptions")
        .document(documentId)
        .delete()
        .catchError((onError) {
      setErrorMessage(onError.toString());
    });

    isLoading(false);
  }

  Future<void> updateProfileImage(String imageUrl) async {
    isLoading(true);

    var updateImageUrl = {
      "imageUrl": imageUrl,
    };

    await firestore
        .collection("accounts")
        .document(this.userId)
        .updateData(updateImageUrl)
        .catchError((onError) {
      setErrorMessage(onError.toString());
    });

    await this.getAccount();

    isLoading(false);
  }

  Future<void> viewOtherUserProfile(String uid) async {
    isLoading(true);

    var account = await firestore.collection("accounts").document(uid).get().catchError((onError) {
      setErrorMessage(onError.toString());
    });

    UserType userType = Checker.getUserType(account["userType"]);
    var length = 0;

    if (userType == UserType.jobseeker) {
      var shortlists = await firestore
          .collection("accounts")
          .document(uid)
          .collection("shortlists")
          .getDocuments()
          .catchError((onError) {
        setErrorMessage(onError.toString());
      });

      length = shortlists.documents.length;
    } else {
      var posts = await firestore
          .collection("accounts")
          .document(uid)
          .collection("posts")
          .getDocuments()
          .catchError((onError) {
        setErrorMessage(onError.toString());
      });

      length = posts.documents.length;
    }

    var descriptions = await firestore
        .collection("accounts")
        .document(uid)
        .collection("descriptions")
        .getDocuments()
        .catchError((onError) {
      setErrorMessage(onError.toString());
    });

    var otherUser = {
      "account": account,
      "length": length.toString(),
      "descriptions": descriptions.documents,
    };

    this.setOtherUser(otherUser);

    isLoading(false);
  }

  void setOtherUser(dynamic otherUser) {
    this.otherUser = otherUser;
    notifyListeners();
  }

  bool isJobSeeker() {
    return this.account.userType == UserType.jobseeker;
  }

  bool isEmployer() {
    return this.account.userType == UserType.employer;
  }

  void setWages(RangeValues wages) {
    this.account.preferredWages = wages;

    notifyListeners();
  }

  void setCategories(String category) {
    if (this.account.preferredCategories.contains(category)) {
      this.account.preferredCategories.remove(category);
    } else {
      this.account.preferredCategories.add(category);
    }

    notifyListeners();
  }

  Future<void> savePreferredWages({RangeValues preferredWages}) async {
    isLoading(true);

    var updateWages = {
      "preferredWages":
          "${preferredWages.start.toStringAsFixed(2)}-${preferredWages.end.toStringAsFixed(2)}" ??
              this.account.preferredWages,
    };

    await firestore
        .collection("accounts")
        .document(this.userId)
        .updateData(updateWages)
        .catchError((onError) {
      setErrorMessage(onError.toString());
    });

    if (preferredWages != null) {
      this.account.setPreferredWages(preferredWages);
    }

    isLoading(false);
  }

  Future<void> savePreferredCategories({List<dynamic> preferredCategories}) async {
    isLoading(true);

    var updateCategories = {
      "preferredCategories": preferredCategories ?? this.account.preferredCategories,
    };

    await firestore
        .collection("accounts")
        .document(this.userId)
        .updateData(updateCategories)
        .catchError((onError) {
      setErrorMessage(onError.toString());
    });

    if (preferredCategories != null) {
      this.account.setPreferredCategories(preferredCategories);
    }

    isLoading(false);
  }

  void setProfileCompleted(bool profileCompleted) {
    this.profileCompleted = profileCompleted;
  }
}
