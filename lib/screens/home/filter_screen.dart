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
  RangeValues preferedWages;
  List<dynamic> preferedCategories;

  @override
  void initState() {
    preferedWages = widget.user.account.preferedWages;
    preferedCategories = List.from(widget.user.account.preferedCategories);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Job job = Provider.of<Job>(context);

    void savePreferedCategories() async {
      if (preferedCategories.isNotEmpty) {
        var saveCategories = widget.user.savePreferedCategories(preferedCategories: preferedCategories);
        var saveWages = widget.user.savePreferedWages(preferedWages: preferedWages);

        await Future.wait([saveCategories, saveWages]).then((_) {
          Navigator.pop(context);
          job.getAvailableJobs();
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
        title: Text("Edit Preferences"),
        centerTitle: true,
        actions: <Widget>[
          RoundButton(
            icon: Icons.done,
            loading: widget.user.loading,
            onPressed: savePreferedCategories,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FilterCard(
              title: "Expected wages:",
              value:
                  "RM ${preferedWages.start.toStringAsFixed(0)} ~ ${preferedWages.end.toStringAsFixed(2)}/hr",
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  RangeSlider(
                    activeColor: Palette.mustard,
                    values: preferedWages,
                    onChanged: (value) => this.setState(() => preferedWages = value),
                    divisions: 99,
                    min: 1,
                    max: 100,
                    labels: RangeLabels(
                      "RM ${preferedWages.start.toStringAsFixed(2)}/hr",
                      "RM ${preferedWages.end.toStringAsFixed(2)}/hr",
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
                  bool prefered = preferedCategories.contains(categories[index]);

                  return Material(
                    color: Colors.transparent,
                    child: ListTile(
                        title: Text(
                          categories[index],
                          style: TextStyle(
                            color: prefered ? Palette.lapizBlue : Colors.grey,
                          ),
                        ),
                        trailing: prefered
                            ? Icon(
                                Icons.done,
                                color: Palette.lapizBlue,
                              )
                            : Container(width: double.minPositive),
                        onTap: () {
                          if (preferedCategories.contains(categories[index])) {
                            this.setState(() => preferedCategories.remove(categories[index]));
                          } else {
                            this.setState(() => preferedCategories.add(categories[index]));
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
