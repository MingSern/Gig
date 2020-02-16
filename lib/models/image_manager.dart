import 'dart:io';
import 'package:Gig/models/base.dart';
import 'package:Gig/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageManager extends Base {
  User user;
  File image;
  bool loading;

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
}
