import 'package:Gig/components/primary_button.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/models/image_manager.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/dialogs.dart';
import 'package:Gig/utils/drawers.dart';
import 'package:Gig/utils/palette.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    ImageManager imageManager = Provider.of<ImageManager>(context);

    void openGallery() {
      imageManager.openGallery();
    }

    void openCamera() {
      imageManager.openCamera();
    }

    Future<void> uploadImage() async {
      String imageUrl = await imageManager.uploadImage();

      await user.updateProfileImage(imageUrl).then((_) {
        if (user.containsError) {
          user.showErrorMessage(context);
        } else {
          Navigator.pop(context);
          imageManager.setImage(null);
        }
      });
    }

    void showBottomSheet() {
      Drawers.bottom(
        context: context,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("Camera"),
            onTap: openCamera,
          ),
          ListTile(
            leading: Icon(Icons.camera),
            title: Text("Gallery"),
            onTap: openGallery,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
        title: Text("Edit image"),
        centerTitle: true,
        actions: <Widget>[
          RoundButton(
            icon: Icons.done,
            onPressed: uploadImage,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: <Widget>[
                Hero(
                  tag: "profile",
                  child: user.account.imageUrl == null
                      ? CircleAvatar(
                          radius: 70,
                          backgroundColor: Palette.mustard,
                          child: Text(
                            Device.getFirstLetter(
                              user.account.businessName.isEmpty
                                  ? user.account.fullname
                                  : user.account.businessName,
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.black12,
                          backgroundImage: imageManager.image != null
                              ? FileImage(imageManager.image)
                              : CachedNetworkImageProvider(user.account.imageUrl),
                        ),
                ),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Palette.ashGrey,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: showBottomSheet,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
