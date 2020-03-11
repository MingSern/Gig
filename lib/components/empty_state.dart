import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String imagePath;
  final String message;

  EmptyState({
    @required this.imagePath,
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 2.5 / 1.5,
              child: Image(
                image: AssetImage(this.imagePath),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 60),
              child: Text(
                this.message,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
