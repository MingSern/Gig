import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/small_card.dart';
import 'package:Gig/models/image_manager.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/utils/device.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowJobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ImageManager imageManager = Provider.of<ImageManager>(context);
    Job job = Provider.of<Job>(context);
    final Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    final String title = data["title"];
    final List<DocumentSnapshot> documents = data["documents"];

    void viewJobInfo(document) {
      job.setJob(document);
      Navigator.pushNamed(context, "/home/job/info");
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
      ),
      body: ListView(
        children: documents.map((document) {
          if (document["uid"] != null) {
            imageManager.addAccountId(document["uid"]);
          }

          return SmallCard(
            workPosition: document["workPosition"],
            businessName: document["businessName"],
            imageUrl: imageManager.getImageUrl(document["uid"]),
            wages: document["wages"],
            createdAt: document["createdAt"],
            location: document["location"],
            onPressed: () => viewJobInfo(document),
          );
        }).toList(),
      ),
    );
  }
}
