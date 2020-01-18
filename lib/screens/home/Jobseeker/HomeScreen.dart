import 'package:Gig/components/big_card.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/title_button.dart';
import 'package:Gig/utils/device.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final PageController _pageController = new PageController(viewportFraction: 0.89);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: searchBar(context),
        actions: <Widget>[
          RoundButton(
            icon: Icons.tune,
            onPressed: () => Navigator.pushNamed(context, "/home/job/filter"),
          )
        ],
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
            children: <Widget>[
              TitleButton(
                title: "Recommended for you",
                icon: Icon(Icons.arrow_forward),
                onTap: () {},
              ),
              Container(
                height: 255,
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _pageController,
                  itemCount: 5,
                  itemBuilder: (content, index) {
                    return BigCard(
                      title: "Kitchen Assistant",
                      subtitle: "lioncity manpower pte ltd",
                      body: "RM 23/hr",
                      location: "9: Orchard, Somerset, River valley",
                      day: "1 day ago",
                      onPressed: () {},
                    );
                  },
                ),
              ),
              TitleButton(
                title: "Available jobs",
                icon: Icon(Icons.arrow_forward),
                onTap: () {},
              ),
              Container(
                height: 255,
                child: PageView(
                  controller: _pageController,
                  physics: BouncingScrollPhysics(),
                  children: snapshot.data.documents.map((document) {
                    return BigCard(
                      title: document["workPosition"],
                      subtitle: document["businessName"],
                      body: "RM ${document["wages"]}/hr",
                      location: document["location"],
                      day: Device.getTimeAgo(document["createdAt"]),
                      onPressed: () {},
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
