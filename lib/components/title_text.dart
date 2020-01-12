import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  TitleText({
    @required this.title,
    @required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    List<String> texts = [this.title, this.subtitle];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      alignment: Alignment(-1, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: texts.map((text) {
          return Text(
            text,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          );
        }).toList(),
      ),
    );
  }
}
