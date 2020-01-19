import 'package:Gig/components/round_button.dart';
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
        job.createJob(this.workPosition, this.wages, this.location, this.description).then((_) {
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
        elevation: 0,
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0.0,
        title: Text("Add a job"),
        centerTitle: true,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: FlatButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: job.loading ? null : createJob,
                child: job.loading
                    ? SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                          strokeWidth: 2.0,
                        ),
                      )
                    : Text("Done"),
              ),
            ),
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextFormField(
                    initialValue: this.workPosition,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: "Work position",
                    ),
                    onSaved: (value) => workPosition = value,
                    validator: (value) => value.isEmpty ? "Work position is empty" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextFormField(
                    initialValue: this.wages,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Wages",
                    ),
                    onSaved: (value) => wages = value,
                    validator: (value) => value.isEmpty ? "Wages is empty" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextFormField(
                    initialValue: this.location,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: "Location",
                    ),
                    onSaved: (value) => location = value,
                    validator: (value) => value.isEmpty ? "Location is empty" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextFormField(
                    initialValue: this.description,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: "Description",
                    ),
                    onSaved: (value) => description = value,
                    validator: (value) => value.isEmpty ? "Description is empty" : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showMessage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Discard'),
        content: Text('Confirm discard?'),
        actions: <Widget>[
          FlatButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text(
              "Discard",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
