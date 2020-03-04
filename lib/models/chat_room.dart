import 'package:Gig/models/base.dart';
import 'package:Gig/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = Firestore.instance;

class ChatRoom extends Base {
  // String userId;
  User user;
  dynamic listener;
  // String listenerId;
  // String listenerName;
  String key;
  bool exists = false;
  List<dynamic> chatRooms;

  ChatRoom() {
    this.chatRooms = new List<dynamic>();
  }

  void update(User user) {
    this.user = user;
    notifyListeners();
  }

  // Get -----------------------------------------------------------------------------------------
  Stream<QuerySnapshot> getChatRooms() {
    return firestore
        .collection("accounts")
        .document(this.user.userId)
        .collection("chatRooms")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getMessages() {
    return firestore
        .collection("chatRooms")
        .document(this.key)
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  // Methods -----------------------------------------------------------------------------------------
  void open(dynamic listener) async {
    this.closePreviousRoom();

    this.listener = listener;

    if (this.user.userId.compareTo(this.listener["uid"]) > -1) {
      this.key = this.user.userId + "_" + this.listener["uid"];
    } else {
      this.key = this.listener["uid"] + "_" + this.user.userId;
    }

    var chatRoom =
        await firestore.collection("chatRooms").document(this.key).collection("messages").getDocuments();

    if (chatRoom.documents.length > 0) {
      this.exists = true;
    } else {
      this.exists = false;
    }

    notifyListeners();
  }

  void closePreviousRoom() {
    this.exists = false;
    this.key = null;
    this.listener = null;
    notifyListeners();
  }

  Future<void> createTalkerChatRoom(num createdAt) async {
    var listenerData = {
      "uid": this.listener["uid"],
      "name": this.listener["name"],
      "lastMessage": "",
      "createdAt": createdAt,
    };

    /// for talker
    await firestore
        .collection("accounts")
        .document(this.user.userId)
        .collection("chatRooms")
        .document(this.key)
        .setData(listenerData)
        .catchError((error) {
      setErrorMessage(error.message);
    });
  }

  Future<void> createListenerChatRoom(num createdAt) async {
    var talkerData = {
      "uid": this.user.userId,
      "name": this.user.account.businessName.isEmpty
          ? this.user.account.fullname
          : this.user.account.businessName,
      "lastMessage": "",
      "createdAt": createdAt,
    };

    /// for listener
    await firestore
        .collection("accounts")
        .document(this.listener["uid"])
        .collection("chatRooms")
        .document(this.key)
        .setData(talkerData)
        .catchError((error) {
      setErrorMessage(error.message);
    });
  }

  Future<void> createMessage(String message) async {
    isLoading(true);

    if (!this.exists) {
      var createdAt = new DateTime.now().millisecondsSinceEpoch;
      await Future.wait([this.createTalkerChatRoom(createdAt), this.createListenerChatRoom(createdAt)]);
      this.exists = true;
    }

    var messageData = {
      "uid": this.user.userId,
      "to": this.key.split("_").where((id) => id != this.user.userId).toList().first,
      "message": message,
      "createdAt": new DateTime.now().millisecondsSinceEpoch,
    };

    await firestore
        .collection("chatRooms")
        .document(this.key)
        .collection("messages")
        .add(messageData)
        .catchError((error) {
      setErrorMessage(error.message);
    });

    this.updateLastMessage(message);

    isLoading(false);
  }

  Future<void> updateLastMessage(String message) async {
    var lastMessage = {
      "lastMessage": message,
      "createdAt": new DateTime.now().millisecondsSinceEpoch,
    };

    await firestore
        .collection("accounts")
        .document(this.user.userId)
        .collection("chatRooms")
        .document(this.key)
        .updateData(lastMessage)
        .catchError((error) {
      setErrorMessage(error.message);
    });

    await firestore
        .collection("accounts")
        .document(this.listener["uid"])
        .collection("chatRooms")
        .document(this.key)
        .updateData(lastMessage)
        .catchError((error) {
      setErrorMessage(error.message);
    });
  }
}
