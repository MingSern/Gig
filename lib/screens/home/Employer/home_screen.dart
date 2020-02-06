import 'package:Gig/components/small_card.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/utils/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Job job = Provider.of<Job>(context);

    void viewJobInfo(document) {
      job.setJob(document);
      Navigator.pushNamed(context, "/home/job/info");
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
          if (!snapshot.hasData) {
            return Center(
              child: Text("No post"),
            );
          }
          return ListView(
            children: snapshot.data.documents.map((document) {
              return SmallCard(
                workPosition: document["workPosition"],
                businessName: document["businessName"],
                wages: document["wages"],
                location: document["location"],
                createdAt: document["createdAt"],
                onPressed: () => viewJobInfo(document),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/home/job/add"),
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
