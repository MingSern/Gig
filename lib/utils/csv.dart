import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class CSV {
  static create(List<DocumentSnapshot> documents) async {
    List<List<String>> csvData = [
      <String>[
        "Id",
        "Business Name",
        "Work Position",
        "Category",
        "Wages",
        "Preferred Age",
        "Preferred Gender",
        "Location",
        "Job Description"
      ],
      ...documents.map(
        (document) => [
          document.data["Id"],
          document.data["businessName"],
          document.data["workPosition"],
          document.data["category"],
          document.data["wages"],
          document.data["age"],
          document.data["gender"],
          document.data["location"],
          document.data["description"],
        ],
      ),
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    final String dir = (await getExternalStorageDirectory()).path;
    final String path = "$dir/jobs.csv";
    final File file = File(path);

    await file.writeAsString(csv);
    print(path);
    print("Save to csv done.");
  }
}
