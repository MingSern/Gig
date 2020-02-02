import 'package:Gig/components/pending_card.dart';
import 'package:Gig/components/small_card.dart';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    Job job = Provider.of<Job>(context);

    void viewProfile() {
      /// Todo go to profile screen for [employer] or [jobseeker]
    }

    void viewJobInfo(document) {
      job.setJob(document);
      Navigator.pushNamed(context, "/home/job/info");
    }

    void acceptPending(String key) {
      /// Todo accept pending
    }

    void rejectPending(String key) {
      /// Todo reject pending
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "List",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          bottom: TabBar(
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 50),
            indicatorColor: Colors.black.withOpacity(0.8),
            tabs: <Widget>[
              Tab(text: "Pending"),
              Tab(text: "Shortlisted"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            StreamBuilder(
              stream: job.getPendings(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: snapshot.data.documents.map((document) {
                    return user.account.userType == UserType.employer
                        ? PendingCard(
                            fullname: document["name"],
                            onTap: viewProfile,
                            onAccept: () => acceptPending(document["key"]),
                            onReject: () => rejectPending(document["key"]),
                          )
                        : SmallCard(
                            workPosition: document["workPosition"],
                            businessName: document["businessName"],
                            wages: document["wages"],
                            location: document["location"],
                            createdAt: document["createdAt"],
                            rejected: document["rejected"],
                            onPressed: () => viewJobInfo(document),
                          );
                  }).toList(),
                );
              },
            ),
            StreamBuilder(
              stream: job.getShortlists(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: snapshot.data.documents.map((document) {
                    return user.account.userType == UserType.employer
                        ? PendingCard(
                            fullname: document["name"],
                            onTap: viewProfile,
                            onAccept: () => acceptPending(document["key"]),
                            onReject: () => rejectPending(document["key"]),
                          )
                        : SmallCard(
                            workPosition: document["workPosition"],
                            businessName: document["businessName"],
                            wages: document["wages"],
                            location: document["location"],
                            createdAt: document["updatedAt"],
                            rejected: document["rejected"],
                            onPressed: () => viewJobInfo(document),
                          );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
