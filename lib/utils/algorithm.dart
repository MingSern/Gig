import 'package:Gig/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Algorithm {
  static List scamPhrases = [
    "transfer money",
    "cash deposit",
    "pay us",
    "application fee",
    "pay fee",
    "pay some fee",
    "payment fee",
    "your bank password",
    "bank password",
    "send money",
    "Nigeria",
    "Prince of Nigeria",
    "get a loan from you",
    "get a loan",
    "i promise to refund",
    "cost you",
    "advanced fee",
    "fee",
    "registration fee",
    "work from home",
    "sign up fee",
    "your password",
    "fined",
    "have been fined",
    "you have been fined",
    "benefits",
    "benefit",
    "charge you",
  ];

  static bool search({@required var document, @required String keyword}) {
    bool match = document["workPosition"].toLowerCase().replaceAll(" ", "").contains(keyword) ||
        document["businessName"].toLowerCase().replaceAll(" ", "").contains(keyword) ||
        document["category"].toLowerCase().replaceAll(" ", "").contains(keyword) ||
        document["location"].first.toLowerCase().replaceAll(" ", "").contains(keyword);

    return match;
  }

  static List<DocumentSnapshot> hybridListPreferences(
      {@required List<DocumentSnapshot> documents, @required User user}) {
    List<DocumentSnapshot> preferredJobs = [];

    preferredJobs = documents.where((document) {
      double wages = double.parse(document["wages"]);
      bool within = wages >= user.account.preferredWages.start && wages <= user.account.preferredWages.end;
      bool match = user.account.preferredCategories.contains(document["category"]);

      if (within && match) {
        return true;
      }

      return false;
    }).toList();

    return preferredJobs;
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
    bool isScam = false;

    for (String text in scamPhrases) {
      String trimmedMessage = message.toLowerCase().replaceAll(" ", "");
      String trimmedText = text.toLowerCase().replaceAll(" ", "");

      if (trimmedMessage.contains(trimmedText)) {
        isScam = true;
        break;
      }
    }

    return isScam;
  }
}
