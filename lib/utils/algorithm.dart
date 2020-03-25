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

  // static List<DocumentSnapshot> hybridListPreferences(
  //     {@required List<DocumentSnapshot> documents, @required User user}) {
  //   List<DocumentSnapshot> preferredJobs = [];

  //   preferredJobs = documents.where((document) {
  //     double wages = double.parse(document["wages"]);
  //     bool within = wages >= user.account.preferredWages.start && wages <= user.account.preferredWages.end;
  //     bool match = user.account.preferredCategories.contains(document["category"]);

  //     if (within && match) {
  //       return true;
  //     }

  //     return false;
  //   }).toList();

  //   return preferredJobs;
  // }

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
