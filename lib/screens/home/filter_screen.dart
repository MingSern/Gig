import 'package:Gig/components/filter_card.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/lists/categories.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Job job = Provider.of<Job>(context);

    return Scaffold(
      appBar: AppBar(
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
        title: Text("Filter by"),
        centerTitle: true,
        actions: <Widget>[
          RoundButton(
            icon: Icons.restore,
            onPressed: job.resetFilter,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FilterCard(
              title: "Expected wages:",
              value: "RM ${job.selectedWages.toStringAsFixed(2)}/hr",
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Slider(
                    activeColor: Palette.mustard,
                    value: job.selectedWages,
                    onChanged: job.setWages,
                    divisions: 20,
                    min: 0,
                    max: 100,
                    label: "RM ${job.selectedWages.toStringAsFixed(2)}",
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
                  bool selected = job.selectedCategories.contains(categories[index]);

                  return Material(
                    color: Colors.transparent,
                    child: ListTile(
                      title: Text(
                        categories[index],
                        style: TextStyle(
                          color: selected ? Palette.lapizBlue : Colors.grey,
                        ),
                      ),
                      trailing: selected
                          ? Icon(
                              Icons.done,
                              color: Palette.lapizBlue,
                            )
                          : Container(width: double.minPositive),
                      onTap: () => job.setCategories(categories[index]),
                    ),
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
