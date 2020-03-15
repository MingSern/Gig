import 'package:Gig/components/empty_state.dart';
import 'package:Gig/components/small_card.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/dialogs.dart';
import 'package:Gig/utils/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Job job = Provider.of<Job>(context);
    User user = Provider.of<User>(context);

    void viewJobInfo(document) {
      job.setJob(document);
      Navigator.pushNamed(context, "/home/job/info");
    }

    void createJob() {
      if (user.profileCompleted) {
        Navigator.pushNamed(context, "/home/job/add");
      } else {
        Dialogs.notifyDialog(context: context);
      }
    }

    void onDelete(dynamic document) {
      Dialogs.confirmationDialog(
        context: context,
        title: "Delete",
        content: "Are you sure you want to delete this job?",
        onConfirm: "Delete",
      ).then((onConfirm) {
        if (onConfirm ?? false) {
          job.deleteJob(document["key"]);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: job.getJobs(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          if (!snapshot.hasData) {
            return Container();
          }

          if (snapshot.data.documents.length == 0) {
            return EmptyState(
              imagePath: "assets/empty_post.png",
              message: "Click on the floating action button to create a job now 🔥",
            );
          }

          return ListView(
            children: snapshot.data.documents.map((document) {
              return SmallCard(
                workPosition: document["workPosition"],
                businessName: user.account.businessName,
                imageUrl: user.account.imageUrl,
                wages: document["wages"],
                location: document["location"],
                createdAt: document["createdAt"],
                onPressed: () => viewJobInfo(document),
                onLongPress: () => onDelete(document),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createJob,
        highlightElevation: 15,
        backgroundColor: Palette.ashGrey,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
