import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/base.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/algorithm.dart';
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
  List<DocumentSnapshot> preferedJobs;
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
    this.preferedJobs = Algorithm.hybridListPreferences(
      documents: this.availableJobs,
      user: this.user,
    );

    this.preferedJobs.removeWhere((job) {
      return this.availableJobs.sublist(0, 5).contains(job);
    });

    notifyListeners();
  }

  void setJob(dynamic job) {
    this.job = job;
    notifyListeners();
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
      "createdAt": this.getCurrentTime(),
      "pendings": [],
      "shortlists": [],
      "declines": [],
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
    isLoading(true);

    QuerySnapshot availableJobs;

    if (limit != null) {
      availableJobs =
          await firestore.collection(jobs).orderBy("createdAt", descending: true).limit(limit).getDocuments();
    } else {
      availableJobs = await firestore.collection(jobs).orderBy("createdAt", descending: true).getDocuments();
    }

    this.setAvailableJobs(availableJobs.documents);

    isLoading(false);
  }

  Future<void> acceptPending(String jobseekerId, String key) async {
    isLoading(true);

    await Future.wait([
      this.movePendingToShortlist(
          this.user.userId, key, jobseekerId), // update pending to shortlist for [employer]
      this.movePendingToShortlist(
          jobseekerId, key, this.user.userId) // update pending to shortlist for [jobseeker]
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
    this.getAvailableJobs();

    isLoading(false);
  }

  Future<void> movePendingToShortlist(String uid, String key, String oid) async {
    isLoading(true);

    DocumentSnapshot document = await firestore.collection(accounts).document(uid).get();
    List documentPendings = List.from(document.data["pendings"]);
    List theAcceptedJob = documentPendings.where((job) => job["key"] == key && job["uid"] == oid).toList();
    Map newShortlist = theAcceptedJob.first;

    /// update pending and shortlist data for [jobseeker] and [employer]
    documentPendings.removeWhere((job) => job["key"] == key && job["uid"] == oid);
    newShortlist["status"] = JobStatus.shortlisted.toString();
    newShortlist["updatedAt"] = this.getCurrentTime();

    var updateData = {
      "pendings": documentPendings,
      "shortlists": FieldValue.arrayUnion([newShortlist]),
    };

    await firestore.collection(accounts).document(uid).updateData(updateData).catchError((error) {
      setErrorMessage(error.message);
    });

    isLoading(false);
  }

  Future<void> declinePending(String jobseekerId, String key, String message) async {
    isLoading(true);

    await Future.wait([
      this.updateJobToDecline(
          this.user.userId, key, jobseekerId, message), // update pending to shortlist for [employer]
      this.updateJobToDecline(
          jobseekerId, key, this.user.userId, message), // update pending to shortlist for [jobseeker]
    ]);

    /// update data for [jobs]
    var updateData = {
      "pendings": FieldValue.arrayRemove([jobseekerId]),
      "declines": FieldValue.arrayUnion([jobseekerId]),
    };

    var theJob = firestore.collection(jobs).document(key);

    await theJob.updateData(updateData).catchError((error) {
      setErrorMessage(error.message);
    });

    this.setJob(await theJob.get());
    this.getAvailableJobs();

    isLoading(false);
  }

  Future<void> updateJobToDecline(String uid, String key, String oid, String message) async {
    isLoading(true);

    DocumentSnapshot document = await firestore.collection(accounts).document(uid).get();
    List documentPendings = List.from(document.data["pendings"]);
    List theDeclinedJob = documentPendings.where((job) => job["key"] == key && job["uid"] == oid).toList();
    Map declinedJob = theDeclinedJob.first;

    /// update pending data for [jobseeker] and [employer]
    documentPendings.removeWhere((job) => job["key"] == key && job["uid"] == oid);
    declinedJob["status"] = JobStatus.declined.toString();
    declinedJob["updatedAt"] = this.getCurrentTime();
    declinedJob["message"] = message.trim();
    documentPendings.add(declinedJob);

    var updateData = {
      "pendings": documentPendings,
    };

    await firestore.collection(accounts).document(uid).updateData(updateData).catchError((error) {
      setErrorMessage(error.message);
    });

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
    this.getAvailableJobs();

    /// set data to [employer]
    var updateEmployersPendingData = {
      "pendings": FieldValue.arrayUnion([
        {
          "key": this.job["key"],
          "uid": this.user.userId,
          "workPosition": this.job["workPosition"],
          "imageUrls": this.job["imageUrls"],
          "name": this.user.account.fullname,
          "updatedAt": currentTime,
          "status": JobStatus.pending.toString(),
        }
      ]),
    };

    var employerPending = firestore
        .collection(accounts)
        .document(this.job["uid"])
        .updateData(updateEmployersPendingData)
        .catchError((error) {
      setErrorMessage(error.message);
    });

    /// set data to [jobseeker]
    var updateJobseekersPendingData = {
      "pendings": FieldValue.arrayUnion([
        {
          "key": this.job["key"],
          "uid": this.job["uid"],
          "workPosition": this.job["workPosition"],
          "imageUrls": this.job["imageUrls"],
          "wages": this.job["wages"],
          "location": this.job["location"],
          "description": this.job["description"],
          "businessName": this.job["businessName"],
          "category": this.job["category"],
          "createdAt": this.job["createdAt"],
          "updatedAt": currentTime,
          "status": JobStatus.pending.toString(),
        }
      ]),
    };

    var jobseekerPending = firestore
        .collection(accounts)
        .document(this.user.userId)
        .updateData(updateJobseekersPendingData)
        .catchError((error) {
      setErrorMessage(error.message);
    });

    await Future.wait([
      employerPending,
      jobseekerPending,
    ]);

    isLoading(false);
  }

  Stream<DocumentSnapshot> getPendingsAndShortLists() {
    return firestore.collection(accounts).document(this.user.userId).snapshots();
  }

  // methods -----------------------------------------------------------------------------------------
  String createKey() {
    var ref = firestore.collection(accounts).document();
    return ref.documentID;
  }

  int getCurrentTime() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  Future<List> jaccardCategory() async {
    List<String> preferedCategories = List.from(user.account.preferedCategories);
    QuerySnapshot snapshot = await firestore
        .collection(accounts)
        .where("userType", isEqualTo: "UserType.jobseeker")
        .getDocuments();

    List<dynamic> otherUsers = snapshot.documents.where((document) {
      bool documentExist = document.data["preferedCategories"] != null;
      bool notCurrentUser = document.data["uid"] != this.user.userId;

      return (documentExist && notCurrentUser);
    }).toList();

    otherUsers = otherUsers.map((otherUser) {
      List<String> categories = List.from(preferedCategories);
      List otherPreferedCategories = otherUser["preferedCategories"];

      int a = categories.length;
      int b = otherPreferedCategories.length;
      int sum = a + b;
      int intersaction = categories.where((item) => otherPreferedCategories.contains(item)).toList().length;
      int union = sum - intersaction < 0 ? -(sum - intersaction) : sum - intersaction;

      double similarityIndex = intersaction / union;

      return {
        "uid": otherUser["uid"],
        "preferedCategories": otherUser["preferedCategories"],
        "A": a,
        "B": b,
        "A n B": intersaction,
        "A u B": union,
        "similarityIndex": similarityIndex,
      };
    }).toList();

    otherUsers.sort((b, a) {
      return a["similarityIndex"].compareTo(b["similarityIndex"]);
    });

    return otherUsers;
  }

  // Future<List> jaccardAppliedJobs() async {
  //   QuerySnapshot snapshot = await firestore
  //       .collection(accounts)
  //       .where("userType", isEqualTo: "UserType.jobseeker")
  //       .getDocuments();

  //   List<dynamic> otherJobSeeker = snapshot.documents.where((document) {
  //     return document["uid"];
  //   }).toList();

  //   QuerySnapshot anotherSnapshot = await firestore
  //       .collection(accounts)
  //       .where("uid", isEqualTo: otherJobSeeker)
  //       .getDocuments(;);

  //   otherUsers = otherUsers.map((otherUser) {
  //     List<String> categories = List.from(preferedCategories);
  //     categories.removeWhere((category) => !otherUser["preferedCategories"].contains(category));

  //     List otherPreferedCategories = otherUser["preferedCategories"];
  //     int other = otherPreferedCategories.length; // |A|
  //     int user = preferedCategories.length; // |B|
  //     int intersaction = categories.length; // |A n B|
  //     int otherUnionUser = other + user; // |A u B|

  //     double similarityIndex = intersaction / (otherUnionUser - intersaction);

  //     return {
  //       "uid": otherUser["uid"],
  //       "preferedCategories": otherUser["preferedCategories"],
  //       "A": user,
  //       "B": other,
  //       "A n B": intersaction,
  //       "A u B": otherUnionUser,
  //       "similarityIndex": similarityIndex,
  //     };
  //   }).toList();

  //   otherUsers.sort((b, a) {
  //     return a["similarityIndex"].compareTo(b["similarityIndex"]);
  //   });

  //   return otherUsers;
  // }
}
