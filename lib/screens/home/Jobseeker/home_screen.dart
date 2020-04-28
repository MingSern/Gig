import 'package:Gig/components/big_card.dart';
import 'package:Gig/components/empty_state.dart';
import 'package:Gig/components/filter_card.dart';
import 'package:Gig/components/loading.dart';
import 'package:Gig/components/primary_button.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/title_button.dart';
import 'package:Gig/lists/categories.dart';
import 'package:Gig/models/image_manager.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/dialogs.dart';
import 'package:Gig/utils/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final PageController controller = new PageController();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    Job job = Provider.of<Job>(context);

    void filterJobs() {
      Navigator.pushNamed(context, "/home/job/filter");
    }

    Future<void> onRefresh() async {
      await job.getAllJobs();
    }

    void onGetStarted() async {
      bool isGPSEnabled = await Geolocator().isLocationServiceEnabled();

      if (isGPSEnabled) {
        controller.animateToPage(
          1,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      } else {
        Dialogs.notifyDialog(
          context: context,
          content: "Please enable the GPS in your device setting in order to proceed.",
        );
      }
    }

    return user.account.preferredCategories.isEmpty
        ? PageView(
            controller: controller,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Home",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    EmptyState(
                      imagePath: "assets/get_started.png",
                      message: "Get started by selecting job categories that you like! 🔥",
                    ),
                    PrimaryButton(
                      text: "Get Started",
                      onPressed: onGetStarted,
                    ),
                  ],
                ),
              ),
              BuildSelection()
            ],
          )
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
            body: !job.jobExist
                ? Loading()
                : RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView(
                      children: <Widget>[
                        BuildCarousell(
                          title: "Recommended for you",
                          documents: job.recommendedJobs,
                          limit: 15,
                        ),
                        BuildCarousell(
                          title: "Your preferences",
                          documents: job.preferredJobs,
                          limit: 15,
                        ),
                        BuildCarousell(
                          title: "Near you",
                          documents: job.nearYouJobs,
                          limit: 15,
                        ),
                        BuildCarousell(
                          title: "Latest jobs",
                          documents: job.latestJobs,
                          limit: 15,
                        ),
                      ],
                    ),
                  ),
            // floatingActionButton: FloatingActionButton(
            //   backgroundColor: Colors.white,
            //   child: Icon(
            //     Icons.note_add,
            //     color: Palette.lapizBlue,
            //   ),
            //   onPressed: () async {
            //     Position position =
            //         await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

            //     print(position.toString());
            //   },
            // onPressed: () async {
            //   List result = await job.jaccardCategory();
            //   Navigator.pushNamed(context, "/result", arguments: result);
            // },
            // ),
          );
  }
}

class BuildCarousell extends StatelessWidget {
  final String title;
  final List<DocumentSnapshot> documents;
  final int limit;

  BuildCarousell({
    @required this.title,
    @required this.documents,
    @required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    ImageManager imageManager = Provider.of<ImageManager>(context);
    Job job = Provider.of<Job>(context);

    void viewJobInfo(document) {
      job.setJob(document);
      Navigator.pushNamed(context, "/home/job/info");
    }

    List<Widget> mapDocuments() {
      if (this.documents == null || this.documents.isEmpty || this.documents.length < 1) {
        return [
          BigCard(
            isEmpty: true,
          )
        ];
      }

      List<DocumentSnapshot> filteredDocuments = this.documents.take(this.limit).toList();

      List<Widget> mappedDocuments = filteredDocuments.map((document) {
        if (document["uid"] != null) {
          imageManager.addAccountId(document["uid"]);
        }

        return BigCard(
          workPosition: document["workPosition"],
          businessName: document["businessName"],
          imageUrl: document["imageUrls"]?.first,
          wages: document["wages"],
          location: document["location"],
          createdAt: document["createdAt"],
          onPressed: () => viewJobInfo(document),
        );
      }).toList();

      return mappedDocuments;
    }

    return Column(
      children: <Widget>[
        TitleButton(
          title: this.title,
          documents: this.documents.take(this.limit + 15).toList(),
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
  List<String> preferredCategories;
  RangeValues preferredWages;

  @override
  void initState() {
    preferredCategories = new List<String>();
    preferredWages = RangeValues(10, 100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Job job = Provider.of<Job>(context);
    User user = Provider.of<User>(context);

    Future<void> savePreferredCategories() async {
      if (preferredCategories.isNotEmpty) {
        // var categories = user.savePreferredCategories(preferredCategories: preferredCategories);
        // var wages = user.savePreferredWages(preferredWages: preferredWages);
        await user
            .savePreferences(preferredWages: preferredWages, preferredCategories: preferredCategories)
            .then((_) {
          job.getAllJobs();
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
        title: Text(
          "What you like?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        actions: <Widget>[
          RoundButton(
            icon: Icons.done,
            loading: user.loading,
            onPressed: savePreferredCategories,
          ),
        ],
      ),
      body: user.loading
          ? Loading()
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  FilterCard(
                    title: "Expected wages:",
                    value:
                        "RM ${preferredWages.start.toStringAsFixed(0)} ~ ${preferredWages.end.toStringAsFixed(2)}/hr",
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
                            "RM ${preferredWages.end.toStringAsFixed(2)}/hr",
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
                        String category = categories[index];
                        bool preferred = preferredCategories.contains(category) ?? false;

                        return Material(
                          color: Colors.transparent,
                          child: ListTile(
                            title: Text(
                              category,
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
                              if (preferred) {
                                this.setState(() => preferredCategories.remove(category));
                              } else {
                                this.setState(() => preferredCategories.add(category));
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
