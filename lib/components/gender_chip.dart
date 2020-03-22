import 'package:flutter/material.dart';

class GenderChip extends StatelessWidget {
  final String gender;
  final String age;

  GenderChip({
    @required this.gender,
    @required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: this.gender == "Male" ? Colors.blueAccent : Colors.pinkAccent,
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              this.gender,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2),
            child: Text(
              this.age,
              style: TextStyle(
                color: this.gender == "Male" ? Colors.blueAccent : Colors.pinkAccent,
              ),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
