import 'package:Gig/components/small_card.dart';
import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return SmallCard(
                  workPosition: "Cashier",
                  businessName: "H&M",
                  wages: "31",
                  createdAt: 1579432429384,
                  location: "Bukit Bintang",
                  onPressed: () => Navigator.pushNamed(context, "/job/info"),
                );
              },
            ),
            ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return SmallCard(
                  workPosition: "Cashier",
                  businessName: "H&M",
                  wages: "31",
                  createdAt: 1579432429384,
                  location: "Bukit Bintang",
                  onPressed: () => Navigator.pushNamed(context, "/job/info"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
