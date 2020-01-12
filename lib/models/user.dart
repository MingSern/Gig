import 'package:Gig/models/base.dart';
import 'package:Gig/screens/register_as_screen.dart';
import 'package:Gig/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  notSignedIn,
  signedIn,
}

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final Firestore firestore = Firestore.instance;

class User extends Base {
  String id;
  AuthStatus authStatus;

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

  // Set -----------------------------------------------------------------------------------------
  void setUser(String id) {
    this.id = id;
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

  Future<void> registerAccount(
      UserType userType, String fullname, String businessName, String email, String password, String phoneNumber) async {
    setState(ViewState.busy);

    await Firebase.signUp(email, password).then((userId) async {
      var data = {
        "userType": userType.toString(),
        "id": userId,
        "fullname": fullname,
        "email": email,
        "phoneNumber": phoneNumber,
      };

      if (userType == UserType.employer) {
        data["businessName"] = businessName;
      }

      await firestore.collection("accounts").document(userId).setData(data).then((_) {
        this.setUser(userId);
        this.authenticate();
      });
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
