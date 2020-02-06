import 'package:flutter/material.dart';

class Date extends StatelessWidget {
  final String date;

  Date({
    @required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        this.date,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }
}
