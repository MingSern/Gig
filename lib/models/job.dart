import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/base.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/algorithm.dart';
import 'package:Gig/utils/generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

final firestore = Firestore.instance;
final accounts = "accounts";
final pendings = "pendings";
final chatRooms = "chatRooms";
final posts = "posts";
final shortlists = "shortlists";
final jobs = "jobs";

class Job extends Base {
  User user;
  bool jobExist;
  dynamic job;
  List<DocumentSnapshot> availableJobs;
  List<DocumentSnapshot> preferredJobs;
  List<DocumentSnapshot> latestJobs;
  List<DocumentSnapshot> nearYouJobs;
  List<DocumentSnapshot> recommendedJobs;
  List<String> preferredCategories;
  double preferredWages;

  Job() {
    this.reset();
  }

  void update(User user) {
    this.user = user;

    if (this.user != null && this.user.isJobSeeker() && !this.jobExist) {
      this.getAllJobs();
    }

    if (this.user.authStatus == AuthStatus.notSignedIn) {
      this.reset();
    }
  }

  void reset() {
    this.jobExist = false;
    this.availableJobs = new List<DocumentSnapshot>();
    this.preferredJobs = new List<DocumentSnapshot>();
    this.latestJobs = new List<DocumentSnapshot>();
    this.nearYouJobs = new List<DocumentSnapshot>();
    this.recommendedJobs = new List<DocumentSnapshot>();
    this.preferredCategories = new List<String>();
    this.preferredWages = 10;
  }

  void setAvailableJobs(List<DocumentSnapshot> availableJobs) {
    this.availableJobs = List.from(availableJobs);
  }

  void setRecommendedJobs(List<DocumentSnapshot> recommendedJobs) {
    this.recommendedJobs = recommendedJobs;
  }

  void setPreferredJobs(List<DocumentSnapshot> preferredJobs) {
    this.preferredJobs = preferredJobs;
  }

  void setLatestJobs(List<DocumentSnapshot> latestJobs) {
    this.latestJobs = latestJobs;
  }

  void setNearYouJobs(List<DocumentSnapshot> nearYouJobs) {
    this.nearYouJobs = nearYouJobs;
  }

  void setJob(dynamic job) {
    this.job = job;
    notifyListeners();
  }

  // employer -----------------------------------------------------------------------------------------
  Future<void> createJob(
      var workPosition, var wages, var location, var description, var category, var age, var gender) async {
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
      "age": age,
      "gender": gender,
      "pendings": [],
      "shortlists": [],
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

  Future<void> getAllJobs() async {
    isLoading(true);

    await Future.wait([
      this.getRecommendedJobs(),
      this.getPreferredJobs(),
      this.getAvailableJobs(),
    ]);

    this.jobExist = true;
    notifyListeners();

    isLoading(false);
  }

  Future<void> getAvailableJobs() async {
    QuerySnapshot availableJobs =
        await firestore.collection(jobs).orderBy("createdAt", descending: true).getDocuments();

    this.setAvailableJobs(availableJobs.documents);
  }

  Future<void> getRecommendedJobs() async {
    DocumentSnapshot document =
        await firestore.collection("recommendedJobs").document(this.user?.userId).get();

    if (document.exists) {
      List recommendedJob = document.data["recommendedJobs"] ?? [];

      var results = await Future.wait(recommendedJob.map((job) {
        return firestore.collection(jobs).where("key", isEqualTo: job["id"]).getDocuments();
      }));

      List<DocumentSnapshot> documents = [];

      results.forEach((result) {
        documents.addAll(result.documents);
      });

      this.setRecommendedJobs(documents);
    } else {
      this.setRecommendedJobs([]);
    }
  }

  Future<void> getPreferredJobs() async {
    QuerySnapshot availableJobs =
        await firestore.collection(jobs).orderBy("createdAt", descending: true).getDocuments();

    this.getLatestJobs(availableJobs.documents);
    await this.getNearYouJobs(availableJobs.documents);

    List<DocumentSnapshot> preferredJobs =
        Algorithm.hybridListPreferences(documents: availableJobs.documents, user: this.user);

    this.setPreferredJobs(preferredJobs);
  }

  void getLatestJobs(List<DocumentSnapshot> documents) {
    this.setLatestJobs(documents.take(20).toList());
  }

  Future<void> getNearYouJobs(List<DocumentSnapshot> documents) async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .timeout(Duration(seconds: 1), onTimeout: () => null);

    if (position == null) {
      position = Position(longitude: 101.7937736, latitude: 3.0399107);
    }

    List<DocumentSnapshot> nearYouJobs = [];

    for (var document in documents) {
      List location = document.data["location"];
      double latitude = double.parse(location[1]);
      double longitude = double.parse(location.last);

      double distanceInMeters =
          await Geolocator().distanceBetween(latitude, longitude, position.latitude, position.longitude);
      document.data["distance"] = distanceInMeters;
      nearYouJobs.add(document);
    }

    nearYouJobs.sort((a, b) {
      return a.data["distance"].compareTo(b.data["distance"]);
    });

    this.setNearYouJobs(nearYouJobs);
  }

  Future<void> acceptPending(String jobseekerId, String key) async {
    isLoading(true);

    await Future.wait([
      // update pending to shortlist for [employer]
      this.movePendingToShortlist(this.user.userId, key, jobseekerId),
      // update pending to shortlist for [jobseeker]
      this.movePendingToShortlist(jobseekerId, key, this.user.userId),
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
    this.getAllJobs();

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
    this.getAllJobs();

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
    this.getAllJobs();

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
          "age": this.job["age"],
          "gender": this.job["gender"],
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
    List<String> preferredCategories = List.from(user.account.preferredCategories);
    QuerySnapshot snapshot = await firestore
        .collection(accounts)
        .where("userType", isEqualTo: "UserType.jobseeker")
        .getDocuments();

    List<dynamic> otherUsers = snapshot.documents.where((document) {
      bool documentExist = document.data["preferredCategories"] != null;
      bool notCurrentUser = document.data["uid"] != this.user.userId;

      return (documentExist && notCurrentUser);
    }).toList();

    otherUsers = otherUsers.map((otherUser) {
      List<String> categories = List.from(preferredCategories);
      List otherPreferredCategories = otherUser["preferredCategories"];

      int a = categories.length;
      int b = otherPreferredCategories.length;
      int sum = a + b;
      int intersaction = categories.where((item) => otherPreferredCategories.contains(item)).toList().length;
      int union = sum - intersaction < 0 ? -(sum - intersaction) : sum - intersaction;

      double similarityIndex = intersaction / union;

      return {
        "uid": otherUser["uid"],
        "preferredCategories": otherUser["preferredCategories"],
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
  //     List<String> categories = List.from(preferredCategories);
  //     categories.removeWhere((category) => !otherUser["preferredCategories"].contains(category));

  //     List otherPreferredCategories = otherUser["preferredCategories"];
  //     int other = otherPreferredCategories.length; // |A|
  //     int user = preferredCategories.length; // |B|
  //     int intersaction = categories.length; // |A n B|
  //     int otherUnionUser = other + user; // |A u B|

  //     double similarityIndex = intersaction / (otherUnionUser - intersaction);

  //     return {
  //       "uid": otherUser["uid"],
  //       "preferredCategories": otherUser["preferredCategories"],
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
