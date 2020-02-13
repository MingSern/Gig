import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/account.dart';
import 'package:Gig/models/base.dart';
import 'package:Gig/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final Firestore firestore = Firestore.instance;

class User extends Base {
  String userId;
  AuthStatus authStatus;
  Account account;
  String shortlisted = "0";
  String applied = "0";

  User() {
    this.authenticate();
  }

  Future<void> authenticate() async {
    await Firebase.getCurrentUser().then((user) async {
      if (user != null) {
        this.setId(user.uid);
        await this.getAccount();
        await this.getApplied();
        await this.getShortlisted();
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

  void setId(String userId) {
    this.userId = userId;
  }

  void setAccount(Account account) {
    this.account = account;
  }

  Future<void> getAccount() async {
    DocumentSnapshot snapshot = await firestore.collection("accounts").document(this.userId).get();
    var accountData = snapshot.data;

    UserType userType = UserType.values.firstWhere((e) => e.toString() == accountData["userType"]);
    String email = accountData["email"];
    String fullname = accountData["fullname"];
    String businessName = accountData["businessName"] ?? "";
    String phoneNumber = accountData["phoneNumber"];
    String password = accountData["password"] ?? "";

    Account account = new Account(userType, email, password, fullname, businessName, phoneNumber);

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

    var verificationId;

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
      print('${exception.message}');
    };

    await Firebase.sendCodeToPhoneNumber(
            account.phoneNumber, autoRetrieve, smsCodeSent, verifySuccess, verifyFailed)
        .catchError((onError) {
      setErrorMessage(onError.message);
    });

    isLoading(false);
  }

  Future<void> verifyAndRegisterAccount(String smsCode) async {
    isLoading(true);

    var credential =
        PhoneAuthProvider.getCredential(verificationId: this.account.verificationId, smsCode: smsCode);

    await Firebase.signInWithPhoneNumber(credential).then((AuthResult result) async {
      if (result.user != null) {
        await Firebase.signUp(this.account.email, this.account.password).then((userId) async {
          this.setId(userId);

          var data = {
            "userType": this.account.userType.toString(),
            "uid": this.userId,
            "fullname": this.account.fullname,
            "email": this.account.email,
            "phoneNumber": this.account.phoneNumber,
          };

          if (this.account.userType == UserType.employer) {
            data["businessName"] = this.account.businessName;
          }

          await firestore.collection("accounts").document(this.userId).setData(data).then((_) async {
            await this.authenticate();
          });
        }).catchError((onError) {
          setErrorMessage(onError.message);
        });
      } else {
        setErrorMessage("User not exist.");
      }
    }).catchError((onError) {
      setErrorMessage(onError.message);
    });

    isLoading(false);
  }

  Future<void> logoutAccount() async {
    isLoading(true);

    await Firebase.signOut().then((_) async {
      await this.authenticate();
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
      setErrorMessage(onError.message);
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
      setErrorMessage(onError.message);
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
      setErrorMessage(onError.message);
    });

    isLoading(false);
  }
}
