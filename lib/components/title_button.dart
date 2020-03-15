import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TitleButton extends StatelessWidget {
  final String title;
  final List<DocumentSnapshot> documents;

  TitleButton({
    @required this.title,
    @required this.documents,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, "/home/job/show", arguments: {
        "title": this.title,
        "documents": this.documents,
      }),
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              this.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
