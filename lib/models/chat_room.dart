import 'package:Gig/models/base.dart';
import 'package:Gig/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = Firestore.instance;

class ChatRoom extends Base {
  String userId;
  String listenerId;
  String listenerName;
  String key;
  bool exists = false;
  List<dynamic> chatRooms;

  ChatRoom() {
    this.chatRooms = new List<dynamic>();
  }

  void update(User user) {
    this.userId = user.userId;
    notifyListeners();
  }

  // Get -----------------------------------------------------------------------------------------
  Stream<QuerySnapshot> getChatRooms() {
    return firestore
        .collection("accounts")
        .document(this.userId)
        .collection("chatRooms")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getMessages() {
    return firestore.collection("chatRooms").document(this.key).collection("messages").orderBy("createdAt", descending: true).snapshots();
  }

  // Methods -----------------------------------------------------------------------------------------
  void open(dynamic listener) async {
    this.closePreviousRoom();

    this.listenerName = listener["name"];
    this.listenerId = listener["uid"];

    if (this.userId.compareTo(this.listenerId) > -1) {
      this.key = this.userId + this.listenerId;
    } else {
      this.key = this.listenerId + this.userId;
    }

    var chatRoom = await firestore.collection("chatRooms").document(this.key).get();

    if (chatRoom != null) {
      this.exists = true;
    } else {
      this.exists = false;
    }

    notifyListeners();
  }

  void closePreviousRoom() {
    this.exists = false;
    this.key = null;
    this.listenerName = null;
    this.listenerId = null;
    notifyListeners();
  }

  Future<void> createTalkerChatRoom() async {
    var listener = await firestore.collection("accounts").document(this.listenerId).get();

    var talkerData = {
      "uid": listener["uid"],
      "name": listener["businessName"],
      "lastMessage": "",
      "createdAt": new DateTime.now().millisecondsSinceEpoch,
    };

    /// for talker [jobseeker]
    await firestore
        .collection("accounts")
        .document(this.userId)
        .collection("chatRooms")
        .document(this.key)
        .setData(talkerData)
        .catchError((error) {
      setErrorMessage(error.message);
    });
  }

  Future<void> createListenerChatRoom() async {
    var talker = await firestore.collection("accounts").document(this.userId).get();
    print(talker["fullname"]);
    var listenerData = {
      "uid": talker["uid"],
      "name": talker["fullname"],
      "lastMessage": "",
      "createdAt": new DateTime.now().millisecondsSinceEpoch,
    };

    /// for listener [employer]
    await firestore
        .collection("accounts")
        .document(this.listenerId)
        .collection("chatRooms")
        .document(this.key)
        .setData(listenerData)
        .catchError((error) {
      setErrorMessage(error.message);
    });
  }

  Future<void> createMessage(String message) async {
    isLoading(true);

    if (!this.exists) {
      await Future.wait([this.createTalkerChatRoom(), this.createListenerChatRoom()]);
      this.exists = true;
    }

    var messageData = {
      "uid": this.userId,
      "message": message,
      "createdAt": new DateTime.now().millisecondsSinceEpoch,
    };

    await firestore.collection("chatRooms").document(this.key).collection("messages").add(messageData).catchError((error) {
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
        .document(this.userId)
        .collection("chatRooms")
        .document(this.key)
        .updateData(lastMessage)
        .catchError((error) {
      setErrorMessage(error.message);
    });

    await firestore
        .collection("accounts")
        .document(this.listenerId)
        .collection("chatRooms")
        .document(this.key)
        .updateData(lastMessage)
        .catchError((error) {
      setErrorMessage(error.message);
    });
  }
}
