import 'package:Gig/components/big_card.dart';
import 'package:Gig/components/filter_card.dart';
import 'package:Gig/components/loading.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/title_button.dart';
import 'package:Gig/lists/categories.dart';
import 'package:Gig/models/image_manager.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    Job job = Provider.of<Job>(context);

    void filterJobs() {
      Navigator.pushNamed(context, "/home/job/filter");
    }

    return user.account.preferedCategories.isEmpty
        ? BuildSelection()
        : Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: BuildSearchBar(),
              actions: <Widget>[
                RoundButton(
                  icon: Icons.tune,
                  onPressed: filterJobs,
                )
              ],
            ),
            body: ListView(
              children: <Widget>[
                BuildCarousell(
                  title: "Recommended for you",
                  future: job.getAvailableJobs(limit: 5),
                ),
                BuildCarousell(
                  title: "Your preferences",
                  future: job.getAvailableJobs(limit: 5),
                ),
                BuildCarousell(
                  title: "Near you",
                  future: job.getAvailableJobs(limit: 5),
                ),
                BuildCarousell(
                  title: "Available jobs",
                  future: job.getAvailableJobs(limit: 5),
                ),
              ],
            ),
          );
  }
}

class BuildSelection extends StatefulWidget {
  @override
  _BuildSelectionState createState() => _BuildSelectionState();
}

class _BuildSelectionState extends State<BuildSelection> {
  List<String> preferedCategories;

  @override
  void initState() {
    preferedCategories = new List<String>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    void savePreferedCategories() {
      user.savePreferedCategories();
    }

    return Scaffold(
      appBar: AppBar(
        // title: Text("Select your categories"),
        actions: <Widget>[
          RoundButton(
            icon: Icons.done,
            loading: this.preferedCategories.isEmpty,
            onPressed: savePreferedCategories,
          ),
        ],
      ),
      body: user.loading
          ? Loading()
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  FilterCard(
                    title: "Catogories",
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        String category = categories[index];
                        bool prefered = preferedCategories.contains(category) ?? false;

                        return Material(
                          color: Colors.transparent,
                          child: ListTile(
                            title: Text(
                              category,
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
                              if (prefered) {
                                this.setState(() => preferedCategories.remove(category));
                              } else {
                                this.setState(() => preferedCategories.add(category));
                              }

                              print(preferedCategories.toString());
                            },
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

class BuildSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/home/job/search"),
      child: Container(
        height: 40,
        margin: const EdgeInsets.only(left: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Search jobs",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
            Icon(
              Icons.search,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}

class BuildCarousell extends StatelessWidget {
  final String title;
  final Future<QuerySnapshot> future;

  BuildCarousell({
    @required this.title,
    @required this.future,
  });

  @override
  Widget build(BuildContext context) {
    ImageManager imageManager = Provider.of<ImageManager>(context);
    Job job = Provider.of<Job>(context);

    void viewJobInfo(document) {
      job.setJob(document);
      Navigator.pushNamed(context, "/home/job/info");
    }

    return FutureBuilder(
      future: this.future,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (!snapshot.hasData) {
          return Container();
        }

        if (snapshot.data.documents.length == 0) {
          return Container();
        }

        return Column(
          children: <Widget>[
            TitleButton(
              title: this.title,
            ),
            Container(
              height: 255,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                children: snapshot.data.documents.map((document) {
                  if (document["uid"] != null) {
                    imageManager.addAccountId(document["uid"]);
                  }

                  return BigCard(
                    workPosition: document["workPosition"],
                    businessName: document["businessName"],
                    imageUrl: document["imageUrls"]?.first ?? "https://tinyurl.com/wby7c6p",
                    wages: document["wages"],
                    location: document["location"],
                    createdAt: document["createdAt"],
                    onPressed: () => viewJobInfo(document),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
