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

    void filterJobs() {
      Navigator.pushNamed(context, "/home/job/filter");
    }

    return Scaffold(
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
      body: ListView(
        children: <Widget>[
          BuildCarousell(
            title: "Recommended for you",
            future: job.getAvailableJobs(),
          ),
          BuildCarousell(
            title: "Near you",
            future: job.getAvailableJobs(),
          ),
          BuildCarousell(
            title: "Available jobs",
            future: job.getAvailableJobs(),
          ),
        ],
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

class BuildCarousell extends StatelessWidget {
  final String title;
  final Future<QuerySnapshot> future;

  BuildCarousell({
    @required this.title,
    @required this.future,
  });

  @override
  Widget build(BuildContext context) {
    Job job = Provider.of<Job>(context);

    void viewJobInfo(document) {
      job.setJob(document);
      Navigator.pushNamed(context, "/home/job/info");
    }

    return FutureBuilder(
      future: this.future,
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

        return Column(
          children: <Widget>[
            TitleButton(
              title: this.title,
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
    );
  }
}
