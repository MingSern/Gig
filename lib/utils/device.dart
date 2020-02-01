import 'package:flutter/material.dart';

class Device {
  static dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  static goBack(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.maybePop(context);
  }

  static getMaxWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static getMaxHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static getFirstLetter(String string) {
    return string.substring(0, 1).toUpperCase();
  }

  static getTimeAgo(var timestamp) {
    var createdAt = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = new DateTime.now().difference(createdAt);

    if (diff.inDays > 365) return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";

    if (diff.inDays > 30) return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";

    if (diff.inDays > 7) return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";

    if (diff.inDays > 0) return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";

    if (diff.inHours > 0) return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";

    if (diff.inMinutes > 0) return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";

    return "Just now";
  }
}
