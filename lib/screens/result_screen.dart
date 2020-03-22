import 'package:Gig/components/round_button.dart';
import 'package:Gig/utils/device.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List results = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Results"),
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
      ),
      body: ListView.separated(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("ID: ${results[index]["uid"]}"),
              Text("Prefered Categories: ${results[index]["preferedCategories"]}"),
              Text("A: ${results[index]["A"]}"),
              Text("B: ${results[index]["B"]}"),
              Text("A n B: ${results[index]["A n B"]}"),
              Text("A u B: ${results[index]["A u B"]}"),
              Text("Similarity Index: ${results[index]["similarityIndex"]}"),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            indent: 15,
            endIndent: 15,
            height: 1,
            color: Colors.grey,
          );
        },
      ),
    );
  }
}
