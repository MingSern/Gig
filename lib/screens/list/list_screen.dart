import 'package:Gig/components/date.dart';
import 'package:Gig/components/empty_state.dart';
import 'package:Gig/components/list_card.dart';
import 'package:Gig/components/small_card.dart';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/image_manager.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/checker.dart';
import 'package:Gig/utils/drawers.dart';
import 'package:Gig/utils/palette.dart';
import 'package:Gig/utils/time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Job job = Provider.of<Job>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 25,
          title: TabBar(
            labelPadding: const EdgeInsets.symmetric(vertical: 0),
            unselectedLabelColor: Colors.black26,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 50),
            indicatorColor: Palette.mustard,
            tabs: <Widget>[
              BuildTab(text: "Pending", iconData: Icons.timer),
              BuildTab(text: "Shortlisted", iconData: Icons.bookmark_border),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            BuildLists(
              type: JobStatus.pending,
              stream: job.getPendingsAndShortLists(),
            ),
            BuildLists(
              type: JobStatus.shortlisted,
              stream: job.getPendingsAndShortLists(),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildTab extends StatelessWidget {
  final String text;
  final IconData iconData;

  BuildTab({
    @required this.text,
    @required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(this.iconData),
          SizedBox(width: 10),
          Text(
            this.text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class BuildLists extends StatelessWidget {
  final dynamic type;
  final Stream<DocumentSnapshot> stream;

  BuildLists({
    @required this.type,
    @required this.stream,
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

    void viewProfile(String uid) {
      user.viewOtherUserProfile(uid);
      Navigator.pushNamed(context, "/profile/view");
    }

    void acceptPending(document) {
      var jobseekerId = document["uid"];
      var key = document["key"];

      job.acceptPending(jobseekerId, key).then((_) {
        if (job.containsError) {
          job.showErrorMessage(context);
        }
      });
    }

    void declinePending(document) {
      TextEditingController controller = new TextEditingController();

      Drawers.keyboard(
        context: context,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Reject this jobseeker",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                maxLength: 100,
                maxLines: null,
                autofocus: true,
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  filled: true,
                  isDense: true,
                  labelText: "Reason (Optional)",
                  hintText: "I am sorry to...",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(color: Palette.lapizBlue),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      var jobseekerId = document["uid"];
                      var key = document["key"];
                      Navigator.pop(context);

                      job.declinePending(jobseekerId, key, controller.text).then((_) {
                        if (job.containsError) {
                          job.showErrorMessage(context);
                        }
                      });
                    },
                    child: Text(
                      "Save & reject".toUpperCase(),
                      style: TextStyle(color: Palette.lapizBlue),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    bool checkJobStatus(String status) {
      if (Checker.getJobStatus(status) == JobStatus.pending ||
          Checker.getJobStatus(status) == JobStatus.shortlisted) {
        return false;
      }

      return true;
    }

    return StreamBuilder(
      stream: this.stream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (!snapshot.hasData) {
          return Container();
        }

        List pendings = snapshot.data["pendings"] ?? [];
        List shortlists = snapshot.data["shortlists"] ?? [];

        pendings.sort((b, a) {
          return a["updatedAt"].compareTo(b["updatedAt"]);
        });

        shortlists.sort((b, a) {
          return a["updatedAt"].compareTo(b["updatedAt"]);
        });

        if (this.type == JobStatus.pending && pendings.length == 0) {
          return EmptyState(
            imagePath: "assets/empty_list.png",
            message: user.isJobSeeker() ? "You haven't apply any jobs 🤷" : "No one apply for your jobs 🤷",
          );
        } else if (this.type == JobStatus.shortlisted && shortlists?.length == 0) {
          return EmptyState(
            imagePath: "assets/empty_list.png",
            message: user.isJobSeeker()
                ? "Seems like you haven't been accepted 🤷"
                : "Seems like you haven't been accept any jobseekers 🤷",
          );
        }

        return ListView.builder(
          itemCount: this.type == JobStatus.pending ? pendings.length : shortlists.length,
          itemBuilder: (context, index) {
            var document =
                this.type == JobStatus.pending ? pendings.elementAt(index) : shortlists.elementAt(index);
            var currentDate = Time.getDate(document["updatedAt"]);
            var previousDate;

            if (index != 0) {
              var previousDoc = this.type == JobStatus.pending
                  ? pendings.elementAt(index - 1)
                  : shortlists.elementAt(index - 1);
              previousDate = Time.getDate(previousDoc["updatedAt"]);
            }

            if (document["uid"] != null) {
              imageManager.addAccountId(document["uid"]);
            }

            return Column(
              children: <Widget>[
                currentDate != previousDate ? Date(date: currentDate) : Container(),
                user.isEmployer()
                    ? this.type == JobStatus.pending
                        ? ListCard(
                            fullname: document["name"],
                            imageUrl: imageManager.getImageUrl(document["uid"]),
                            workPosition: document["workPosition"],
                            onPressed: () => viewProfile(document["uid"]),
                            message: document["message"],
                            declined: checkJobStatus(document["status"]),
                            onAccept: () => acceptPending(document),
                            onReject: () => declinePending(document),
                          )
                        : ListCard(
                            fullname: document["name"],
                            imageUrl: imageManager.getImageUrl(document["uid"]),
                            workPosition: document["workPosition"],
                            onPressed: () => viewProfile(document["uid"]),
                          )
                    : SmallCard(
                        workPosition: document["workPosition"],
                        businessName: document["businessName"],
                        imageUrl: imageManager.getImageUrl(document["uid"]),
                        wages: document["wages"],
                        location: document["location"],
                        createdAt: document["updatedAt"],
                        message: document["message"],
                        declined: checkJobStatus(document["status"]),
                        onPressed: () => viewJobInfo(document),
                      ),
              ],
            );
          },
        );
      },
    );
  }
}
