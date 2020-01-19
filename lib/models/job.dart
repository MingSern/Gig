import 'package:Gig/models/base.dart';
import 'package:Gig/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = Firestore.instance;

class Job extends Base {
  String userId;
  String businessName;
  QuerySnapshot availableJobs;

  void update(User user) {
    this.userId = user.userId;
    this.businessName = user.account.businessName;
    notifyListeners();
  }

  void setAvailableJobs(QuerySnapshot availableJobs) {
    this.availableJobs = availableJobs;
    notifyListeners();
  }

  // employer -----------------------------------------------------------------------------------------
  Future<void> createJob(var workPosition, var wages, var location, var description) async {
    isLoading(true);

    var data = {
      "id": this.userId,
      "workPosition": workPosition,
      "wages": wages,
      "location": location,
      "description": description,
      "businessName": this.businessName,
      "createdAt": new DateTime.now().millisecondsSinceEpoch,
    };

    await firestore.collection("jobs").add(data).catchError((error) {
      setErrorMessage(error.message);
    });

    await firestore.collection("accounts").document(this.userId).collection("post").add(data).catchError((error) {
      setErrorMessage(error.message);
    });

    isLoading(false);
  }

  Stream<QuerySnapshot> getJobs() {
    return firestore.collection("accounts").document(this.userId).collection("post").orderBy("createdAt", descending: true).snapshots();
  }

  Future<QuerySnapshot> getAvailableJobs() async {
    var availableJobs = await firestore.collection("jobs").orderBy("createdAt", descending: true).getDocuments();
    this.setAvailableJobs(availableJobs);

    return availableJobs;
  }
}
