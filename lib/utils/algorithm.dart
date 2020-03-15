import 'package:Gig/models/user.dart';
import 'package:flutter/material.dart';

class Algorithm {
  static bool search({@required var document, @required String keyword}) {
    bool match = document["workPosition"].toLowerCase().replaceAll(" ", "").contains(keyword) ||
        document["businessName"].toLowerCase().replaceAll(" ", "").contains(keyword) ||
        document["description"].toLowerCase().replaceAll(" ", "").contains(keyword) ||
        document["category"].toLowerCase().replaceAll(" ", "").contains(keyword) ||
        document["location"].toLowerCase().replaceAll(" ", "").contains(keyword);

    return match;
  }

  static bool preferences({@required document, @required User user}) {
    int difference = user.account.preferedWages - int.parse(document["wages"]);
    bool match = user.account.preferedCategories.contains(document["category"]);

    if ((difference > -5 && difference < 5) || match) {
      return true;
    }

    return false;
  }

  static bool none() {
    return true;
  }
}
