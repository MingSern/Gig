import 'package:Gig/components/date.dart';
import 'package:Gig/components/list_card.dart';
import 'package:Gig/components/small_card.dart';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/checker.dart';
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
          elevation: 0,
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
              stream: job.getPendings(),
            ),
            BuildLists(
              type: JobStatus.shortlisted,
              stream: job.getShortlists(),
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
  final Stream<QuerySnapshot> stream;

  BuildLists({
    @required this.type,
    @required this.stream,
  });

  @override
  Widget build(BuildContext context) {
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
      var jobseekerId = document["uid"];
      var key = document["key"];

      job.declinePending(jobseekerId, key).then((_) {
        if (job.containsError) {
          job.showErrorMessage(context);
        }
      });
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

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            var document = snapshot.data.documents.elementAt(index);
            var currentDate = Time.getDate(document["updatedAt"]);
            var previousDate;

            if (index != 0) {
              var previousDoc = snapshot.data.documents.elementAt(index - 1);
              previousDate = Time.getDate(previousDoc["updatedAt"]);
            }

            return Column(
              children: <Widget>[
                currentDate != previousDate ? Date(date: currentDate) : Container(),
                user.account.userType == UserType.employer
                    ? this.type == JobStatus.pending
                        ? ListCard(
                            fullname: document["name"],
                            workPosition: document["workPosition"],
                            onPressed: () => viewProfile(document["uid"]),
                            declined: checkJobStatus(document["status"]),
                            onAccept: () => acceptPending(document),
                            onReject: () => declinePending(document),
                          )
                        : ListCard(
                            fullname: document["name"],
                            workPosition: document["workPosition"],
                            onPressed: () => viewProfile(document["uid"]),
                          )
                    : SmallCard(
                        workPosition: document["workPosition"],
                        businessName: document["businessName"],
                        wages: document["wages"],
                        location: document["location"],
                        createdAt: document["createdAt"],
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
