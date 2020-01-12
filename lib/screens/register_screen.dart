import 'package:Gig/components/primary_button.dart';
import 'package:Gig/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/screens/register_as_screen.dart';
import 'package:Gig/utils/generator.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var fullname;
  var businessName;
  var email;
  var password;
  var phoneNumber;

  void generateAccountData() {
    var account = Generator.generateAccountData();

    this.email = account["email"];
    this.password = account["password"];
    this.fullname = account["fullname"];
    this.businessName = account["businessName"];
  }

  @override
  void initState() {
    super.initState();
    this.generateAccountData();
  }

  @override
  Widget build(BuildContext context) {
    final UserType userType = ModalRoute.of(context).settings.arguments;
    User user = Provider.of<User>(context);

    bool validatedAndSaved() {
      var form = formKey.currentState;

      if (form.validate()) {
        form.save();
        return true;
      }

      return false;
    }

    Future<void> registerAccount() async {
      if (validatedAndSaved()) {
        user.registerAccount(userType, this.fullname, this.businessName, this.email, this.password, this.phoneNumber).then((_) {
          if (user.containsError) {
            user.showErrorMessage(context);
          } else {
            Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: RoundButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: this.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Register as",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userType == UserType.jobseeker ? "Jobseeker" : "Employer",
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
                    initialValue: this.fullname,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Full name",
                    ),
                    onSaved: (value) => this.fullname = value,
                    validator: (value) => value.isEmpty ? "Full name is empty" : null,
                  ),
                ),
                userType == UserType.jobseeker
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                        child: TextFormField(
                          initialValue: this.businessName,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Business/Company name",
                          ),
                          onSaved: (value) => this.businessName = value,
                          validator: (value) => value.isEmpty ? "Business/Company name is empty" : null,
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextFormField(
                    initialValue: this.email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    onSaved: (value) => this.email = value,
                    validator: (value) => value.isEmpty ? "Email is empty" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    initialValue: this.password,
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
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                  child: TextFormField(
                    initialValue: "+601110768827",
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone number",
                    ),
                    onSaved: (value) => this.phoneNumber = value,
                    validator: (value) => value.isEmpty ? "Phone number is empty" : null,
                  ),
                ),
                Container(
                  alignment: Alignment(0, 0),
                  padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
                  child: PrimaryButton(
                    text: "Register",
                    onPressed: registerAccount,
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
