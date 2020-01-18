import 'package:Gig/components/small_card.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        stream: null,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("No post"),
            );
          }
          return ListView(
            children: snapshot.data.documents.map((document) {
              return SmallCard(
                title: document["workPosition"],
                subtitle: document["businessName"],
                body: "RM ${document["wages"]}/hr",
                location: document["location"],
                day: Device.getTimeAgo(document["createdAt"]),
                onPressed: () {},
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
