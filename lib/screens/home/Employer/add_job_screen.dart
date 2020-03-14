import 'package:Gig/components/field.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/lists/categories.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddJobScreen extends StatefulWidget {
  @override
  _AddJobScreenState createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var workPosition;
  var wages;
  var location;
  var description;
  var category;

  @override
  void initState() {
    this.generateJobData();
    super.initState();
  }

  void generateJobData() {
    var data = Generator.generateJobData();

    this.workPosition = data["workPosition"];
    this.wages = data["wages"];
    this.location = data["location"];
    this.description = data["description"];
    this.category = data["category"];
  }

  @override
  Widget build(BuildContext context) {
    Job job = Provider.of<Job>(context);

    bool validatedAndSaved() {
      var form = this.formKey.currentState;

      if (form.validate()) {
        form.save();
        return true;
      }

      return false;
    }

    void createJob() {
      if (validatedAndSaved()) {
        job
            .createJob(this.workPosition, this.wages, this.location, this.description, this.category)
            .then((_) {
          if (job.containsError) {
            job.showErrorMessage(context);
          } else {
            Device.goBack(context);
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: RoundButton(
          loading: job.loading,
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
        titleSpacing: 0.0,
        title: Text("Add a job"),
        centerTitle: true,
        actions: <Widget>[
          RoundButton(
            loading: job.loading,
            icon: Icons.done,
            onPressed: job.loading ? null : createJob,
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
                  initialValue: this.workPosition,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  labelText: "Work position",
                  loading: job.loading,
                  onSaved: (value) => workPosition = value,
                  validator: (value) => value.isEmpty ? "Work position is empty" : null,
                ),
                SizedBox(height: 10),
                Field(
                  initialValue: this.wages,
                  keyboardType: TextInputType.number,
                  labelText: "Wages",
                  loading: job.loading,
                  onSaved: (value) => wages = value,
                  validator: (value) => value.isEmpty ? "Wages is empty" : null,
                ),
                SizedBox(height: 10),
                Field(
                  initialValue: this.location,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  labelText: "Location",
                  loading: job.loading,
                  onSaved: (value) => location = value,
                  validator: (value) => value.isEmpty ? "Location is empty" : null,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    isDense: false,
                    value: this.category,
                    validator: (value) => value == null ? "Category is empty" : null,
                    disabledHint: DropdownMenuItem(
                      value: this.category,
                      child: Text(
                        this.category ?? "Blah",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    decoration: InputDecoration(
                      labelText: "Category",
                      filled: true,
                      isDense: true,
                      fillColor: job.loading ? Colors.grey[50] : Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: job.loading ? null : (value) => this.setState(() => this.category = value),
                  ),
                ),
                SizedBox(height: 10),
                Field(
                  initialValue: this.description,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  labelText: "Description",
                  loading: job.loading,
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
