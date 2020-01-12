import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/account.dart';
import 'package:Gig/models/base.dart';
import 'package:Gig/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final Firestore firestore = Firestore.instance;

class User extends Base {
  String id;
  AuthStatus authStatus;
  Account account;

  User() {
    this.authenticate();
  }

  Future<void> authenticate() async {
    await Firebase.getCurrentUser().then((user) {
      if (user != null) {
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

  // Account -----------------------------------------------------------------------------------------
  Future<void> loginAccount(String email, String password) async {
    setState(ViewState.busy);

    await Firebase.signIn(email, password).then((_) {
      this.authenticate();
    }).catchError((onError) {
      setErrorMessage(onError.message);
    });

    setState(ViewState.idle);
  }

  Future<void> verifyAccount(Account account) async {
    setState(ViewState.busy);

    var verificationId;

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;
      account.setVerificationId(verId);
      this.account = account;
    };

    final PhoneVerificationCompleted verifySuccess = (AuthCredential user) {
      print("verified $verificationId");
    };

    final PhoneVerificationFailed verifyFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await Firebase.sendCodeToPhoneNumber(account.phoneNumber, autoRetrieve, smsCodeSent, verifySuccess, verifyFailed).catchError((onError) {
      setErrorMessage(onError.message);
    });

    setState(ViewState.idle);
  }

  Future<void> verifyAndRegisterAccount(String smsCode) async {
    setState(ViewState.busy);

    var credential = PhoneAuthProvider.getCredential(verificationId: this.account.verificationId, smsCode: smsCode);

    await Firebase.signInWithPhoneNumber(credential).then((AuthResult result) async {
      if (result.user != null) {
        await Firebase.signUp(this.account.email, this.account.password).then((userId) async {
          this.id = userId;

          var data = {
            "userType": this.account.userType.toString(),
            "id": this.id,
            "fullname": this.account.fullname,
            "email": this.account.email,
            "phoneNumber": this.account.phoneNumber,
          };

          if (this.account.userType == UserType.employer) {
            data["businessName"] = this.account.businessName;
          }

          await firestore.collection("accounts").document(userId).setData(data).then((_) {
            this.authenticate();
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

    setState(ViewState.idle);
  }

  Future<void> logoutAccount() async {
    setState(ViewState.busy);

    await Firebase.signOut().then((_) {
      this.authenticate();
    }).catchError((onError) {
      setErrorMessage(onError.message);
    });

    setState(ViewState.idle);
  }
}
