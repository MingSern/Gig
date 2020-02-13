import 'package:Gig/components/field.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DescriptionScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final dynamic argument = ModalRoute.of(context).settings.arguments;
    User user = Provider.of<User>(context);
    bool isAdding = argument["isAdding"];
    String title = argument["title"];
    String description = argument["description"];

    bool validatedAndSaved() {
      var form = this.formKey.currentState;

      if (form.validate()) {
        form.save();
        return true;
      }

      return false;
    }

    void createDescription() {
      if (validatedAndSaved()) {
        user.createDescription(title, description).then((_) {
          if (user.containsError) {
            user.showErrorMessage(context);
          } else {
            Navigator.pop(context);
          }
        });
      }
    }

    void editDescription() {
      if (validatedAndSaved()) {
        user.editDescription(argument["documentId"], title, description).then((_) {
          if (user.containsError) {
            user.showErrorMessage(context);
          } else {
            Navigator.pop(context);
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
        titleSpacing: 0.0,
        title: Text(isAdding ? "Add a description" : "Edit description"),
        centerTitle: true,
        actions: <Widget>[
          RoundButton(
            icon: Icons.done,
            onPressed: isAdding ? createDescription : editDescription,
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Field(
                  initialValue: title,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  labelText: "Title",
                  hintText: "About me",
                  onSaved: (value) => title = value,
                  validator: (value) => value.isEmpty ? "Title is empty" : null,
                ),
                SizedBox(height: 10),
                Field(
                  initialValue: description,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  labelText: "Description",
                  hintText: "I am ...",
                  maxLines: null,
                  onSaved: (value) => description = value,
                  validator: (value) => value.isEmpty ? "Description is empty" : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
