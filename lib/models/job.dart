import 'package:Gig/models/base.dart';
import 'package:Gig/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = Firestore.instance;
final accounts = "accounts";
final pendings = "pendings";
final chatRooms = "chatRooms";
final posts = "posts";
final shortlists = "shortlists";
final jobs = "jobs";

class Job extends Base {
  String userId;
  String fullname;
  String businessName;
  dynamic job;
  QuerySnapshot availableJobs;

  void update(User user) {
    this.userId = user.userId;
    this.businessName = user.account.businessName;
    this.fullname = user.account.fullname;
    notifyListeners();
  }

  void setAvailableJobs(QuerySnapshot availableJobs) {
    this.availableJobs = availableJobs;
    notifyListeners();
  }

  void setJob(dynamic job) {
    this.job = job;
    notifyListeners();
  }

  // employer -----------------------------------------------------------------------------------------
  Future<void> createJob(var workPosition, var wages, var location, var description) async {
    isLoading(true);

    var key = this.createKey();

    var data = {
      "key": key,
      "uid": this.userId,
      "workPosition": workPosition,
      "wages": wages,
      "location": location,
      "description": description,
      "businessName": this.businessName,
      "createdAt": this.getCurrentTime(),
      "appliedBy": [],
    };

    await firestore.collection(jobs).document(key).setData(data).catchError((error) {
      setErrorMessage(error.message);
    });

    await firestore.collection(accounts).document(this.userId).collection(posts).add(data).catchError((error) {
      setErrorMessage(error.message);
    });

    isLoading(false);
  }

  Stream<QuerySnapshot> getJobs() {
    return firestore.collection(accounts).document(this.userId).collection(posts).orderBy("createdAt", descending: true).snapshots();
  }

  Future<QuerySnapshot> getAvailableJobs() async {
    var availableJobs = await firestore.collection(jobs).orderBy("createdAt", descending: true).getDocuments();
    this.setAvailableJobs(availableJobs);

    return availableJobs;
  }

  Future<void> acceptPending(String jobseekerId, String key) async {
    isLoading(true);

    await Future.wait([
      this.movePendingToShortlist(this.userId, key), // update pending to shortlist for [employer]
      this.movePendingToShortlist(jobseekerId, key), // update pending to shortlist for [jobseeker]
    ]);

    isLoading(false);
  }

  Future<void> movePendingToShortlist(String uid, String key) async {
    var ref = firestore.collection(accounts).document(uid).collection(pendings).document(key);
    var doc = await ref.get();

    await ref.delete().catchError((error) {
      setErrorMessage(error.message);
    });

    doc.data["updatedAt"] = this.getCurrentTime();

    await firestore.collection(accounts).document(uid).collection("shortlists").add(doc.data).catchError((error) {
      setErrorMessage(error.message);
    });
  }

  Future<void> declinePending(String key) async {
    isLoading(true);

    /// delete pending for [employer] and [jobseeker]
    var declined = {
      "declined": true,
    };

    await firestore.collection(accounts).document(this.userId).collection(pendings).document(key).updateData(declined).catchError((error) {
      setErrorMessage(error.message);
    });

    isLoading(false);
  }

  // jobseeker -----------------------------------------------------------------------------------------
  Future<void> applyJob() async {
    isLoading(true);

    var key = this.createKey();
    var currentTime = this.getCurrentTime();

    /// update data to [jobs]
    var appliedBy = {
      "appliedBy": FieldValue.arrayUnion([this.userId]),
    };

    var theJob = firestore.collection(jobs).document(this.job["key"]);

    await theJob.updateData(appliedBy).catchError((error) {
      setErrorMessage(error.message);
    });

    this.setJob(await theJob.get());

    /// set data to [employer]
    var data = {
      "key": key,
      "uid": this.userId,
      "name": this.fullname,
      "updatedAt": currentTime,
      "declined": false,
    };

    await firestore.collection(accounts).document(this.job["uid"]).collection(pendings).document(key).setData(data).catchError((error) {
      setErrorMessage(error.message);
    });

    /// set data to [jobseeker]
    var employerData = {
      "key": key,
      "uid": this.job["uid"],
      "workPosition": this.job["workPosition"],
      "wages": this.job["wages"],
      "location": this.job["location"],
      "description": this.job["description"],
      "businessName": this.job["businessName"],
      "createdAt": this.job["createdAt"],
      "updatedAt": currentTime,
      "declined": false,
    };

    await firestore.collection(accounts).document(this.userId).collection(pendings).document(key).setData(employerData).catchError((error) {
      setErrorMessage(error.message);
    });

    isLoading(false);
  }

  Stream<QuerySnapshot> getPendings() {
    return firestore.collection(accounts).document(this.userId).collection(pendings).orderBy("updatedAt", descending: true).snapshots();
  }

  Stream<QuerySnapshot> getShortlists() {
    return firestore.collection(accounts).document(this.userId).collection("shortlists").orderBy("updatedAt", descending: true).snapshots();
  }

  // methods -----------------------------------------------------------------------------------------
  String createKey() {
    var ref = firestore.collection(accounts).document();
    return ref.documentID;
  }

  int getCurrentTime() {
    return new DateTime.now().millisecondsSinceEpoch;
  }
}
