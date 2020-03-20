import 'package:Gig/enum/enum.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class WarningMessage extends StatelessWidget {
  final WarningLevel level;
  final String message;
  final EdgeInsets margin;

  WarningMessage({
    @required this.message,
    this.level = WarningLevel.danger,
    this.margin = const EdgeInsets.fromLTRB(15, 15, 15, 0),
  });

  Color handleTextColor() {
    switch (this.level) {
      case WarningLevel.danger:
        return Colors.red;
        break;
      case WarningLevel.danger:
        return Colors.orange;
        break;
      default:
        return Colors.red;
    }
  }

  Color handleBackgroundColor() {
    switch (this.level) {
      case WarningLevel.danger:
        return Palette.cherryRed.withOpacity(0.5);
        break;
      case WarningLevel.caution:
        return Colors.yellow.withOpacity(0.5);
        break;
      default:
        return Palette.cherryRed.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: this.margin,
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: this.handleBackgroundColor(),
      ),
      child: Text(
        this.message,
        style: TextStyle(
          color: this.handleTextColor(),
        ),
      ),
    );
  }
}
