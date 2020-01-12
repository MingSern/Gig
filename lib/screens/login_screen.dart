import 'package:Gig/components/primary_button.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var email;
  var password;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    bool validatedAndSaved() {
      var form = this.formKey.currentState;

      if (form.validate()) {
        form.save();
        return true;
      }

      return false;
    }

    void loginAccount() {
      if (validatedAndSaved()) {
        user.loginAccount(this.email, this.password).then((_) {
          if (user.containsError) {
            user.showErrorMessage(context);
          }
        });
      }
    }

    return Scaffold(
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: this.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Container(
                  margin: const EdgeInsets.all(40),
                  alignment: Alignment(-1, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Welcome to",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "EasyJob",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    onSaved: (value) => this.email = value,
                    validator: (value) => value.isEmpty ? "Email is empty" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    onSaved: (value) => this.password = value,
                    validator: (value) => value.isEmpty ? "Password is empty" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 15),
                  child: PrimaryButton(
                    text: "Login",
                    onPressed: loginAccount,
                  ),
                ),
                FlatButton(
                  onPressed: () => Navigator.pushNamed(context, '/register_as'),
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'LexendDeca',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Register here.',
                          style: TextStyle(
                            color: Palette.lapizBlue,
                            fontFamily: 'LexendDeca',
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
