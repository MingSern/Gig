import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/base.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = Firestore.instance;
final accounts = "accounts";
final pendings = "pendings";
final chatRooms = "chatRooms";
final posts = "posts";
final shortlists = "shortlists";
final jobs = "jobs";

class Job extends Base {
  User user;
  dynamic job;
  List<DocumentSnapshot> availableJobs;
  List<String> preferedCategories = [];
  double preferedWages = 10;
  List<String> accountIds = [];
  List<Map> accountImageUrls = [];

  Job() {
    this.getAvailableJobs();
  }

  void update(User user) {
    this.user = user;
    notifyListeners();
  }

  void setAvailableJobs(List<DocumentSnapshot> availableJobs) {
    this.availableJobs = List.from(availableJobs);
    notifyListeners();
  }

  void setJob(dynamic job) {
    this.job = job;
    // notifyListeners();
  }

  // employer -----------------------------------------------------------------------------------------
  Future<void> createJob(var workPosition, var wages, var location, var description, var category) async {
    isLoading(true);

    var key = this.createKey();
    var imageUrl = Generator.getImageUrl();

    var data = {
      "key": key,
      "uid": this.user.userId,
      "workPosition": workPosition,
      "imageUrls": [imageUrl],
      "wages": wages,
      "location": location,
      "description": description,
      "category": category,
      "businessName": this.user.account.businessName,
      // "imageUrl": this.user.account.imageUrl,
      "createdAt": this.getCurrentTime(),
      "pendings": [],
      "shortlists": [],
      "rejects": [],
    };

    var createNewJob = firestore.collection(jobs).document(key).setData(data).catchError((error) {
      setErrorMessage(error.message);
    });

    var createPostAtHome = firestore
        .collection(accounts)
        .document(this.user.userId)
        .collection(posts)
        .document(key)
        .setData(data)
        .catchError((error) {
      setErrorMessage(error.message);
    });

    await Future.wait([
      createNewJob,
      createPostAtHome,
    ]);

    isLoading(false);
  }

  Future<void> deleteJob(String documentId) async {
    isLoading(true);

    var deleteTheJob = firestore.collection(jobs).document(documentId).delete().catchError((error) {
      setErrorMessage(error.message);
    });

    var deletePostAtHome = firestore
        .collection(accounts)
        .document(this.user.userId)
        .collection(posts)
        .document(documentId)
        .delete()
        .catchError((error) {
      setErrorMessage(error.message);
    });

    await Future.wait([
      deleteTheJob,
      deletePostAtHome,
    ]);

    isLoading(false);
  }

  Stream<QuerySnapshot> getJobs() {
    return firestore
        .collection(accounts)
        .document(this.user.userId)
        .collection(posts)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Future<void> getAvailableJobs({int limit}) async {
    QuerySnapshot availableJobs;

    if (limit != null) {
      availableJobs =
          await firestore.collection(jobs).orderBy("createdAt", descending: true).limit(limit).getDocuments();
    } else {
      availableJobs = await firestore.collection(jobs).orderBy("createdAt", descending: true).getDocuments();
    }

    this.setAvailableJobs(availableJobs.documents);
  }

  Future<void> acceptPending(String jobseekerId, String key) async {
    isLoading(true);

    await Future.wait([
      this.movePendingToShortlist(this.user.userId, key), // update pending to shortlist for [employer]
      this.movePendingToShortlist(jobseekerId, key), // update pending to shortlist for [jobseeker]
    ]);

    /// update data for [jobs]
    var updateData = {
      "pendings": FieldValue.arrayRemove([jobseekerId]),
      "shortlists": FieldValue.arrayUnion([jobseekerId]),
    };

    var theJob = firestore.collection(jobs).document(key);

    await theJob.updateData(updateData).catchError((error) {
      setErrorMessage(error.message);
    });

    this.setJob(await theJob.get());

    isLoading(false);
  }

  Future<void> movePendingToShortlist(String uid, String key) async {
    var ref = firestore.collection(accounts).document(uid).collection(pendings).document(key);
    var doc = await ref.get();

    await ref.delete().catchError((error) {
      setErrorMessage(error.message);
    });

    /// update data for [jobs]
    doc.data["status"] = JobStatus.shortlisted.toString();
    doc.data["updatedAt"] = this.getCurrentTime();

    await firestore
        .collection(accounts)
        .document(uid)
        .collection(shortlists)
        .add(doc.data)
        .catchError((error) {
      setErrorMessage(error.message);
    });
  }

  Future<void> declinePending(String jobseekerId, String key) async {
    isLoading(true);

    var status = {
      "status": JobStatus.declined.toString(),
    };

    /// update pending for [employer] and [jobseeker]
    var employerPending = firestore
        .collection(accounts)
        .document(this.user.userId)
        .collection(pendings)
        .document(key)
        .updateData(status)
        .catchError((error) {
      setErrorMessage(error.message);
    });

    var jobseekerPending = firestore
        .collection(accounts)
        .document(jobseekerId)
        .collection(pendings)
        .document(key)
        .updateData(status)
        .catchError((error) {
      setErrorMessage(error.message);
    });

    await Future.wait([
      employerPending,
      jobseekerPending,
    ]);

    /// update data for [jobs]
    var updateData = {
      "pendings": FieldValue.arrayRemove([jobseekerId]),
      "rejects": FieldValue.arrayUnion([jobseekerId]),
    };

    // var theJob = firestore.collection(jobs).document(key);

    firestore.collection(jobs).document(key).updateData(updateData).catchError((error) {
      setErrorMessage(error.message);
    });

    // this.setJob(await theJob.get());

    isLoading(false);
  }

  // jobseeker -----------------------------------------------------------------------------------------
  Future<void> applyJob() async {
    isLoading(true);

    var currentTime = this.getCurrentTime();

    /// update data to [jobs]
    var pendingsList = {
      "pendings": FieldValue.arrayUnion([this.user.userId]),
    };

    var theJob = firestore.collection(jobs).document(this.job["key"]);

    await theJob.updateData(pendingsList).catchError((error) {
      setErrorMessage(error.message);
    });

    this.setJob(await theJob.get());

    /// set data to [employer]
    var data = {
      "key": this.job["key"],
      "uid": this.user.userId,
      "workPosition": this.job["workPosition"],
      "imageUrls": this.job["imageUrls"],
      "name": this.user.account.fullname,
      "category": this.job["category"],
      // "imageUrl": this.user.account.imageUrl,
      "updatedAt": currentTime,
      "status": JobStatus.pending.toString(),
    };

    var employerPending = firestore
        .collection(accounts)
        .document(this.job["uid"])
        .collection(pendings)
        .document(this.job["key"])
        .setData(data)
        .catchError((error) {
      setErrorMessage(error.message);
    });

    /// set data to [jobseeker]
    var employerData = {
      "key": this.job["key"],
      "uid": this.job["uid"],
      "workPosition": this.job["workPosition"],
      "imageUrls": this.job["imageUrls"],
      "wages": this.job["wages"],
      "location": this.job["location"],
      "description": this.job["description"],
      "businessName": this.job["businessName"],
      "category": this.job["category"],
      // "imageUrl": this.job["imageUrl"],
      "createdAt": this.job["createdAt"],
      "updatedAt": currentTime,
      "status": JobStatus.pending.toString(),
    };

    var jobseekerPending = firestore
        .collection(accounts)
        .document(this.user.userId)
        .collection(pendings)
        .document(this.job["key"])
        .setData(employerData)
        .catchError((error) {
      setErrorMessage(error.message);
    });

    await Future.wait([
      employerPending,
      jobseekerPending,
    ]);

    isLoading(false);
  }

  Stream<QuerySnapshot> getPendings() {
    return firestore
        .collection(accounts)
        .document(this.user.userId)
        .collection(pendings)
        .orderBy("updatedAt", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getShortlists() {
    return firestore
        .collection(accounts)
        .document(this.user.userId)
        .collection("shortlists")
        .orderBy("updatedAt", descending: true)
        .snapshots();
  }

  // methods -----------------------------------------------------------------------------------------
  String createKey() {
    var ref = firestore.collection(accounts).document();
    return ref.documentID;
  }

  int getCurrentTime() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  // void setWages(double wages) {
  //   this.preferedWages = wages;
  //   notifyListeners();
  // }

  // void setCategories(String category) {
  //   if (this.preferedCategories.contains(category)) {
  //     this.preferedCategories.remove(category);
  //   } else {
  //     this.preferedCategories.add(category);
  //   }

  //   notifyListeners();
  // }

  // void resetFilter() {
  //   this.preferedCategories = [];
  //   this.preferedWages = 10;
  //   notifyListeners();
  // }
}
