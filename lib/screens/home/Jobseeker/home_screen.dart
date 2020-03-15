import 'package:Gig/components/big_card.dart';
import 'package:Gig/components/filter_card.dart';
import 'package:Gig/components/loading.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/title_button.dart';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/lists/categories.dart';
import 'package:Gig/models/image_manager.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/algorithm.dart';
import 'package:Gig/utils/dialogs.dart';
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

    Future<void> onRefresh() async {
      await job.getAvailableJobs();
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
            body: job.availableJobs == null
                ? Loading()
                : RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView(
                      children: <Widget>[
                        BuildCarousell(
                          title: "Recommended for you",
                          documents: job.availableJobs,
                          limit: 5,
                        ),
                        BuildCarousell(
                          title: "Your preferences",
                          documents: job.availableJobs,
                          algorithm: Algo.preferences,
                          limit: 5,
                        ),
                        BuildCarousell(
                          title: "Near you",
                          documents: job.availableJobs,
                          limit: 5,
                        ),
                        BuildCarousell(
                          title: "Available jobs",
                          documents: job.availableJobs,
                          limit: 5,
                        ),
                      ],
                    ),
                  ),
          );
  }
}

class BuildCarousell extends StatelessWidget {
  final String title;
  final List<DocumentSnapshot> documents;
  final int limit;
  final Algo algorithm;

  BuildCarousell({
    @required this.title,
    @required this.documents,
    @required this.limit,
    this.algorithm = Algo.none,
  });

  @override
  Widget build(BuildContext context) {
    ImageManager imageManager = Provider.of<ImageManager>(context);
    User user = Provider.of<User>(context);
    Job job = Provider.of<Job>(context);

    void viewJobInfo(document) {
      job.setJob(document);
      Navigator.pushNamed(context, "/home/job/info");
    }

    List<DocumentSnapshot> filterDocuments() {
      return documents.where((document) {
        if (document["uid"] != null) {
          imageManager.addAccountId(document["uid"]);
        }

        switch (this.algorithm) {
          case Algo.none:
            return Algorithm.none();
            break;
          case Algo.preferences:
            return Algorithm.preferences(document: document, user: user);
            break;
          default:
            return Algorithm.none();
            break;
        }
      }).toList();
    }

    List<Widget> mapDocuments() {
      List<DocumentSnapshot> filteredDocuments = filterDocuments();

      List<Widget> mappedDocuments = filteredDocuments
          .map((document) {
            return BigCard(
              workPosition: document["workPosition"],
              businessName: document["businessName"],
              imageUrl: document["imageUrls"]?.first ?? "https://tinyurl.com/wby7c6p",
              wages: document["wages"],
              location: document["location"],
              createdAt: document["createdAt"],
              onPressed: () => viewJobInfo(document),
            );
          })
          .toList()
          .sublist(0, limit > filteredDocuments.length ? filteredDocuments.length : limit);

      return mappedDocuments;
    }

    return Column(
      children: <Widget>[
        TitleButton(
          title: this.title,
          documents: filterDocuments(),
        ),
        Container(
          height: 255,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            children: mapDocuments(),
          ),
        ),
      ],
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
      if (preferedCategories.isNotEmpty) {
        user.savePreferedCategories(preferedCategories: preferedCategories);
      } else {
        Dialogs.notifyDialog(
          context: context,
          content: "Please select at least one job category.",
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Your preferences"),
        actions: <Widget>[
          RoundButton(
            icon: Icons.done,
            loading: user.loading,
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
