import 'package:Gig/components/loading.dart';
import 'package:Gig/components/primary_button.dart';
import 'package:Gig/models/user.dart';
import 'package:flutter/material.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/components/code_field.dart';
import 'package:provider/provider.dart';
import 'package:quiver/async.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  dynamic key;
  String smsCode;
  bool containsError = false;
  var width = 150.0;
  int start = 60;
  int current = 60;
  CountdownTimer countDownTimer;
  dynamic sub;

  void startTimer(var sub) {
    sub.onData((duration) {
      if (this.mounted) {
        setState(() {
          this.current = this.start - duration.elapsed.inSeconds;
        });
      }
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }

  @override
  void initState() {
    countDownTimer = new CountdownTimer(
      new Duration(seconds: this.start),
      new Duration(seconds: 1),
    );

    sub = countDownTimer.listen(null);

    super.initState();
    this.startTimer(sub);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    bool validatedAndSaved() {
      if (this.key == null) {
        return false;
      }

      var form = this.key.currentState;

      if (form.validate()) {
        form.save();
        return true;
      } else {
        return false;
      }
    }

    Future<void> verifyAndRegisterAccount() async {
      setState(() {
        containsError = false;
      });

      if (validatedAndSaved()) {
        user.verifyAndRegisterAccount(this.smsCode).then((_) {
          if (user.containsError) {
            user.showErrorMessage(context);
          } else {
            Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
          }
        });
      } else {
        setState(() {
          containsError = true;
        });
      }
    }

    void resendVerificationCode() {
      user.verifyAccount(user.account).then((_) {
        countDownTimer = new CountdownTimer(
          new Duration(seconds: this.start),
          new Duration(seconds: 1),
        );

        sub.cancel();
        sub = countDownTimer.listen(null);

        this.startTimer(sub);
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: RoundButton(
          icon: Icons.arrow_back,
          loading: user.loading,
          onPressed: () => Device.goBack(context),
        ),
      ),
      body: user?.account?.phoneNumber == null
          ? Loading()
          : Container(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Verify contact number",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Text(
                        "A 6 digit verification code was sent to your contact number ${user.account.phoneNumber}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Text(
                        this.current.toString(),
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: CodeField(
                        onSave: (value, key) {
                          this.smsCode = value;
                          this.key = key;
                        },
                        loading: user.loading,
                      ),
                    ),
                    this.containsError
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Text(
                              "Verification code cannot be empty",
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : SizedBox(
                            height: 40,
                          ),
                    PrimaryButton(
                      text: "Verify",
                      loading: user.loading,
                      onPressed: verifyAndRegisterAccount,
                    ),
                    user.loading
                        ? Container()
                        : FlatButton(
                            onPressed: resendVerificationCode,
                            child: Text(
                              "Resend code",
                              style: TextStyle(
                                fontFamily: 'LexendDeca',
                                color: Colors.black54,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
