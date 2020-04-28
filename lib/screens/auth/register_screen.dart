import 'package:Gig/components/drop_field.dart';
import 'package:Gig/components/field.dart';
import 'package:Gig/components/primary_button.dart';
import 'package:Gig/components/title_text.dart';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/account.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/validator.dart';
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
  var age;
  var gender;
  var email;
  var password;
  var phoneNumber;

  void generateAccountData() {
    var account = Generator.generateAccountData();

    this.email = account["email"];
    this.password = account["password"];
    this.fullname = account["fullname"];
    this.businessName = account["businessName"];
    this.age = account["age"];
    this.gender = account["gender"];
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
        Device.dismissKeyboard(context);
        Account account =
            Account(userType, email, password, fullname, age, gender, businessName, phoneNumber);

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
          loading: user.loading,
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
                userType == UserType.jobseeker
                    ? Field(
                        initialValue: this.fullname,
                        labelText: "Fullname",
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        onSaved: (value) => this.fullname = value,
                        validator: Validator.fullname,
                      )
                    : Field(
                        initialValue: this.businessName,
                        labelText: "Business/Company name",
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        onSaved: (value) => this.businessName = value,
                        validator: Validator.businessName,
                      ),
                userType == UserType.jobseeker
                    ? Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: DropField(
                                  padding: const EdgeInsets.only(left: 30, right: 5),
                                  labelText: "Age",
                                  value: this.age,
                                  validator: Validator.age,
                                  items: List.generate(33, (age) {
                                    return (age + 18).toString();
                                  }),
                                  onChanged: (value) => this.setState(() => this.age = value),
                                ),
                              ),
                              Flexible(
                                child: DropField(
                                  padding: const EdgeInsets.only(left: 5, right: 30),
                                  labelText: "Gender",
                                  value: this.gender,
                                  validator: Validator.gender,
                                  items: ["Male", "Female"],
                                  onChanged: (value) => this.setState(() => this.gender = value),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : Container(),
                SizedBox(height: 10),
                Field(
                  initialValue: this.email,
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => this.email = value,
                  validator: Validator.email,
                ),
                SizedBox(height: 10),
                Field(
                  initialValue: this.password,
                  labelText: "Password",
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  onSaved: (value) => this.password = value,
                  validator: Validator.password,
                ),
                SizedBox(height: 10),
                Field(
                  prefix: Text("+60"),
                  initialValue: "1111111111",
                  labelText: "Phone number",
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    if (value.substring(0, 1) == "0") {
                      this.phoneNumber = "+60" + value.substring(1);
                    } else {
                      this.phoneNumber = "+60" + value;
                    }
                  },
                  validator: Validator.phoneNumber,
                ),
                Container(
                  alignment: Alignment(0, 0),
                  padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
                  child: PrimaryButton(
                    text: "Register",
                    onPressed: verifyAccount,
                    loading: user.loading,
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
