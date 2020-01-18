import 'package:Gig/components/round_button.dart';
import 'package:flutter/material.dart';

class ShowJobsPage extends StatefulWidget {
  ShowJobsPage({
    @required this.title,
  });

  final String title;

  @override
  _ShowJobsPageState createState() => _ShowJobsPageState();
}

class _ShowJobsPageState extends State<ShowJobsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          RoundButton(
            icon: Icons.search,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
