import 'package:Gig/components/filter_card.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/lists/categories.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    // void savePreferedCategories() async {
    //   if (user.account.preferedCategories.isNotEmpty) {
    //     var saveCategories = user.savePreferedCategories();
    //     var saveWages = user.savePreferedWages();

    //     await Future.wait([saveCategories, saveWages]).then((_) {
    //       Navigator.pop(context);
    //     });
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
        leading: RoundButton(
          icon: Icons.arrow_back,
          loading: user.loading,
          onPressed: () => Device.goBack(context),
        ),
        title: Text("Filter by"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FilterCard(
              title: "Expected wages:",
              value: "RM ${user.account.preferedWages}/hr",
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Slider(
                    activeColor: Palette.mustard,
                    value: user.account.preferedWages.toDouble(),
                    onChanged: (value) => user.setWages(value.toInt()),
                    divisions: 50,
                    min: 0,
                    max: 50,
                    label: "RM ${user.account.preferedWages}/hr",
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
                  bool prefered = user.account.preferedCategories.contains(categories[index]);

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
                      onTap: () => user.setCategories(categories[index]),
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
