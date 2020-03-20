import 'package:Gig/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  static List<DocumentSnapshot> hybridListPreferences(
      {@required List<DocumentSnapshot> documents, @required User user}) {
    List<DocumentSnapshot> preferedJobs = [];

    preferedJobs = documents.where((document) {
      double wages = double.parse(document["wages"]);
      bool within = wages >= user.account.preferedWages.start && wages <= user.account.preferedWages.end;
      bool match = user.account.preferedCategories.contains(document["category"]);

      if (within || match) {
        return true;
      }

      return false;
    }).toList();

    return preferedJobs;
  }

  static double jaccard(List<String> listA, List<String> listB) {
    int a = listA.length;
    int b = listB.length;
    int sum = a + b;
    int intersaction = listA.where((item) => listB.contains(item)).toList().length;
    int union = sum - intersaction < 0 ? -(sum - intersaction) : sum - intersaction;

    double similarityIndex = intersaction / union;

    return similarityIndex;
  }

  static bool verifyMessage(String message) {
    bool result = message.toLowerCase().replaceAll(" ", "").contains("transfermoney");

    return result;
  }
}
