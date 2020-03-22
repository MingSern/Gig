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
      await Future.wait([
        job.getAvailableJobs(),
        job.getPreferedJobs(),
      ]);
    }

    return user.account.preferedCategories.isEmpty
        ? PageView(
            controller: controller,
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
                      onPressed: () => controller.animateToPage(
                        1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                      ),
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
            body: job.availableJobs == null
                ? Loading()
                : RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView(
                      children: <Widget>[
                        BuildCarousell(
                          title: "Recommended for you",
                          documents: job.availableJobs,
                          limit: 10,
                        ),
                        BuildCarousell(
                          title: "Your preferences",
                          documents: job.preferedJobs,
                          limit: 10,
                        ),
                        BuildCarousell(
                          title: "Available jobs",
                          documents: job.availableJobs,
                          limit: 10,
                        ),
                      ],
                    ),
                  ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.note_add,
                color: Palette.lapizBlue,
              ),
              onPressed: () async {
                List result = await job.jaccardCategory();
                Navigator.pushNamed(context, "/result", arguments: result);
              },
            ),
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
            workPosition: "Empty",
            businessName: "Empty",
            imageUrl: "Empty",
            wages: "Empty",
            location: "Empty",
            createdAt: 123124918479,
            onPressed: () {},
          )
        ];
      }

      bool limitIsBigger = this.limit > this.documents.length;
      List<DocumentSnapshot> filteredDocuments =
          this.documents.sublist(0, limitIsBigger ? this.documents.length : this.limit);

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
          documents: this.documents,
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
    Job job = Provider.of<Job>(context);
    User user = Provider.of<User>(context);

    void savePreferedCategories() {
      if (preferedCategories.isNotEmpty) {
        user.savePreferedCategories(preferedCategories: preferedCategories).then((_) {
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
        title: Text(
          "What you like",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
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
