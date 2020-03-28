import 'package:Gig/components/drop_field.dart';
import 'package:Gig/components/field.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/lists/categories.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

const kGoogleApiKey = "AIzaSyCITcJfRzSd-frV2OBWH8uCEihLd6ZbiRk";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class AddJobScreen extends StatefulWidget {
  @override
  _AddJobScreenState createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();
  var workPosition;
  var wages;
  var location;
  var description;
  var category;
  var age;
  var gender;

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
    this.age = data["age"];
    this.gender = data["gender"];
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
            .createJob(
          this.workPosition,
          this.wages,
          this.location,
          this.description,
          this.category,
          this.age,
          this.gender,
        )
            .then((_) {
          if (job.containsError) {
            job.showErrorMessage(context);
          } else {
            Device.goBack(context);
          }
        });
      }
    }

    void onError(PlacesAutocompleteResponse response) {
      homeScaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(response.errorMessage),
          duration: Duration(seconds: 5),
        ),
      );
    }

    Future<void> getPredictions() async {
      Prediction prediction = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: Mode.overlay,
        language: "en",
        components: [Component(Component.country, "my")],
      );

      if (prediction != null) {
        PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(prediction.placeId);
        final latitude = detail.result.geometry.location.lat;
        final longitude = detail.result.geometry.location.lng;

        this.setState(() {
          this.location = [prediction.description, latitude.toString(), longitude.toString()];
        });
      }
    }

    return Scaffold(
      key: homeScaffoldKey,
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
                  labelText: "Wages (RM/Hour)",
                  loading: job.loading,
                  onSaved: (value) => wages = value,
                  validator: (value) => value.isEmpty ? "Wages is empty" : null,
                ),
                SizedBox(height: 10),
                DropField(
                  loading: job.loading,
                  labelText: "Category",
                  value: this.category,
                  validator: (value) => value == null ? "Category is empty" : null,
                  items: categories,
                  onChanged: job.loading ? null : (value) => this.setState(() => this.category = value),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: DropField(
                        loading: job.loading,
                        padding: const EdgeInsets.only(left: 30, right: 5),
                        labelText: "Age",
                        value: this.age,
                        validator: (value) => value == null ? "Age is empty" : null,
                        items: ["18-20", "21-30", "31-40", "Any"],
                        onChanged: (value) => this.setState(() => this.age = value),
                      ),
                    ),
                    Flexible(
                      child: DropField(
                        loading: job.loading,
                        padding: const EdgeInsets.only(left: 5, right: 30),
                        labelText: "Gender",
                        value: this.gender,
                        validator: (value) => value == null ? "Gender is empty" : null,
                        items: ["Male", "Female", "Any"],
                        onChanged: (value) => this.setState(() => this.gender = value),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: getPredictions,
                  child: DropField(
                    loading: job.loading,
                    flexible: this.location != null ? true : false,
                    labelText: "Location",
                    value: this.location?.first,
                    validator: (value) => value == null ? "Location is empty" : null,
                    items: this.location ?? [],
                    onChanged: null,
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
