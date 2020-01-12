import 'package:Gig/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/components/code_field.dart';
import 'package:quiver/async.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String smsCode;
  var loading = false;
  var width = 150.0;
  int start = 60;
  int current = 60;

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: this.start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
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
    super.initState();
    this.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          leading: RoundButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Device.dismissKeyboard(context);
              Navigator.pop(context);
            },
          )),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
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
                  "A 6 digit verification code was sent to your contact number 123132313}",
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
                  onSave: (asd) {},
                  loading: this.loading,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              PrimaryButton(
                text: "Verify",
                onPressed: () {},
              ),
              this.loading
                  ? Container()
                  : FlatButton(
                      onPressed: () {},
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
