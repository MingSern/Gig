import 'package:Gig/components/big_card.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/title_button.dart';
import 'package:Gig/models/job.dart';
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
        titleSpacing: 0,
        title: searchBar(context),
        actions: <Widget>[
          RoundButton(
            icon: Icons.tune,
            onPressed: () => Navigator.pushNamed(context, "/home/job/filter"),
          )
        ],
      ),
      body: FutureBuilder(
        future: job.getAvailableJobs(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("No post"),
            );
          }

          return ListView(
            children: <Widget>[
              TitleButton(
                title: "Recommended for you",
              ),
              Container(
                height: 255,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (content, index) {
                    return BigCard(
                      workPosition: "Cashier",
                      businessName: "H&M",
                      wages: "31",
                      createdAt: 1579432429384,
                      location: "Bukit Bintang",
                      onPressed: () {},
                    );
                  },
                ),
              ),
              TitleButton(
                title: "Near you",
              ),
              Container(
                height: 255,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (content, index) {
                    return BigCard(
                      workPosition: "Cashier",
                      businessName: "H&M",
                      wages: "31",
                      createdAt: 1579432429384,
                      location: "Bukit Bintang",
                      onPressed: () {},
                    );
                  },
                ),
              ),
              TitleButton(
                title: "Available jobs",
              ),
              Container(
                height: 255,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  children: snapshot.data.documents.map((document) {
                    return BigCard(
                      workPosition: document["workPosition"],
                      businessName: document["businessName"],
                      wages: document["wages"],
                      location: document["location"],
                      createdAt: document["createdAt"],
                      onPressed: () => viewJobInfo(document),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget searchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/home/job/search"),
      child: Container(
        height: 40,
        margin: const EdgeInsets.only(left: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.grey[200],
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
