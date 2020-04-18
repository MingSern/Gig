import 'package:Gig/components/filter_card.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/lists/categories.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/dialogs.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return BuildFilter(
      user: user,
    );
  }
}

class BuildFilter extends StatefulWidget {
  final User user;

  BuildFilter({
    @required this.user,
  });

  @override
  _BuildFilterState createState() => _BuildFilterState();
}

class _BuildFilterState extends State<BuildFilter> {
  RangeValues preferredWages;
  List<dynamic> preferredCategories;

  @override
  void initState() {
    preferredWages = widget.user.account.preferredWages;
    preferredCategories = List.from(widget.user.account.preferredCategories);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Job job = Provider.of<Job>(context);

    void savePreferredCategories() async {
      if (preferredCategories.isNotEmpty) {
        await widget.user
            .savePreferences(preferredWages: preferredWages, preferredCategories: preferredCategories)
            .then((_) async {
          await job.getAllJobs().then((_) {
            Navigator.pop(context);
          });
        });
      } else {
        Dialogs.notifyDialog(
          context: context,
          content: "Please select at least one job category.",
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: RoundButton(
          icon: Icons.arrow_back,
          loading: widget.user.loading,
          onPressed: () => Device.goBack(context),
        ),
        title: Text("Your preferences"),
        centerTitle: true,
        actions: <Widget>[
          RoundButton(
            icon: Icons.done,
            loading: widget.user.loading,
            onPressed: savePreferredCategories,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FilterCard(
              title: "Expected wages:",
              value: preferredWages.end.toStringAsFixed(2) == "100.00"
                  ? "RM ${preferredWages.start.toStringAsFixed(0)} ~ ∞"
                  : "RM ${preferredWages.start.toStringAsFixed(0)} ~ ${preferredWages.end.toStringAsFixed(2)}/hr",
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  RangeSlider(
                    activeColor: Palette.mustard,
                    values: preferredWages,
                    onChanged: (value) => this.setState(() => preferredWages = value),
                    divisions: 99,
                    min: 1,
                    max: 100,
                    labels: RangeLabels(
                      "RM ${preferredWages.start.toStringAsFixed(2)}/hr",
                      preferredWages.end.toStringAsFixed(2) == "100.00"
                          ? "∞"
                          : "RM ${preferredWages.end.toStringAsFixed(2)}/hr",
                    ),
                  ),
                ],
              ),
            ),
            FilterCard(
              title: "Catogories",
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  bool preferred = preferredCategories.contains(categories[index]);

                  return Material(
                    color: Colors.transparent,
                    child: ListTile(
                        title: Text(
                          categories[index],
                          style: TextStyle(
                            color: preferred ? Palette.lapizBlue : Colors.grey,
                          ),
                        ),
                        trailing: preferred
                            ? Icon(
                                Icons.done,
                                color: Palette.lapizBlue,
                              )
                            : Container(width: double.minPositive),
                        onTap: () {
                          if (preferredCategories.contains(categories[index])) {
                            this.setState(() => preferredCategories.remove(categories[index]));
                          } else {
                            this.setState(() => preferredCategories.add(categories[index]));
                          }
                        }),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    indent: 20,
                    endIndent: 20,
                    height: 0.5,
                    color: Colors.grey[400],
                  );
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
