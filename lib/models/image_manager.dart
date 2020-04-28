import 'dart:io';
import 'package:Gig/models/base.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/debounce.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageManager extends Base {
  User user;
  File image;
  List<String> accountIds;
  List<Map> accountImageUrls;
  Debounce debounce;

  ImageManager() {
    this.accountIds = new List<String>();
    this.accountImageUrls = new List<Map>();
    this.debounce = new Debounce(milliseconds: 1000);
  }

  void update(User user) {
    this.user = user;
    notifyListeners();
  }

  void setImage(dynamic image) {
    this.image = image;
    notifyListeners();
  }

  Future<void> openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 20);

    if (image != null) {
      this.setImage(image);
    }
  }

  Future<void> openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 20);

    if (image != null) {
      this.setImage(image);
    }
  }

  Future<String> uploadImage() async {
    isLoading(true);

    String filename = this.basename(this.image.path);
    StorageReference firebaseStorage = FirebaseStorage.instance.ref().child(this.user.userId).child(filename);
    StorageUploadTask uploadTask = firebaseStorage.putFile(this.image);

    await uploadTask.onComplete;

    isLoading(false);

    return await firebaseStorage.getDownloadURL();
  }

  String basename(String filename) {
    return filename.split("/").last;
  }

  void getAccount() async {
    if (this.accountIds.isNotEmpty || this.accountIds != null) {
      for (var id in this.accountIds) {
        var document = await firestore.collection("accounts").document(id).get();

        this.accountImageUrls.add({
          "uid": "${document["uid"]}",
          "imageUrl": "${document["imageUrl"]}",
        });
      }

      // notifyListeners();
    }
  }

  void addAccountId(String uid) {
    if (!this.accountIds.contains(uid)) {
      this.accountIds.add(uid);

      debounce.run(() {
        this.getAccount();
      });
    }
  }

  String getImageUrl(String uid) {
    for (var imageUrl in this.accountImageUrls) {
      if (imageUrl["uid"] == uid) {
        return imageUrl["imageUrl"];
      }
    }

    return null;
  }
}
