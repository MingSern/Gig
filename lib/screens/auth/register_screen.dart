import 'package:Gig/components/field.dart';
import 'package:Gig/components/primary_button.dart';
import 'package:Gig/components/title_text.dart';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/account.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Gig/components/round_button.dart';
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

    Future<void> verifyAccount() async {
      if (validatedAndSaved()) {
        Account account = Account(userType, email, password, fullname, businessName, phoneNumber);

        await user.verifyAccount(account).then((_) {
          if (user.containsError) {
            user.showErrorMessage(context);
          } else {
            Navigator.pushNamed(context, "/verification");
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
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
                TitleText(
                  title: "Register as",
                  subtitle: userType == UserType.jobseeker ? "Jobseeker" : "Employer",
                ),
                SizedBox(
                  height: 40,
                ),
                Field(
                  initialValue: this.fullname,
                  labelText: "Fullname",
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  onSaved: (value) => this.fullname = value,
                  validator: (value) => value.isEmpty ? "Full name is empty" : null,
                ),
                userType == UserType.jobseeker
                    ? Container()
                    : Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Field(
                            initialValue: this.businessName,
                            labelText: "Business/Company name",
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            onSaved: (value) => this.businessName = value,
                            validator: (value) => value.isEmpty ? "Business/Company name is empty" : null,
                          ),
                        ],
                      ),
                SizedBox(height: 10),
                Field(
                  initialValue: this.email,
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => this.email = value,
                  validator: (value) => value.isEmpty ? "Email is empty" : null,
                ),
                SizedBox(height: 10),
                Field(
                  initialValue: this.password,
                  labelText: "Password",
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  onSaved: (value) => this.password = value,
                  validator: (value) => value.isEmpty ? "Password is empty" : null,
                ),
                SizedBox(height: 10),
                Field(
                  initialValue: "+601110768827",
                  labelText: "Phone number",
                  keyboardType: TextInputType.phone,
                  onSaved: (value) => this.phoneNumber = value,
                  validator: (value) => value.isEmpty ? "Phone number is empty" : null,
                ),
                Container(
                  alignment: Alignment(0, 0),
                  padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
                  child: PrimaryButton(
                    text: "Register",
                    onPressed: verifyAccount,
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
