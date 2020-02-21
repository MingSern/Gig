import 'package:Gig/components/round_button.dart';
import 'package:Gig/models/image_manager.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/device.dart';
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
      imageManager.openGallery().then((_) {
        Navigator.pop(context);
      });
    }

    void openCamera() {
      imageManager.openCamera().then((_) {
        Navigator.pop(context);
      });
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

    Future<bool> onWillPop() {
      if (!imageManager.loading) {
        imageManager.setImage(null);
        return Future.value(true);
      }

      return Future.value(false);
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: RoundButton(
            inverted: true,
            loading: imageManager.loading,
            icon: Icons.arrow_back,
            onPressed: () {
              imageManager.setImage(null);
              Device.goBack(context);
            },
          ),
          title: Text(
            "Edit image",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            RoundButton(
              inverted: true,
              loading: imageManager.loading,
              icon: Icons.mode_edit,
              onPressed: showBottomSheet,
            ),
            imageManager.image != null
                ? RoundButton(
                    inverted: true,
                    loading: imageManager.loading,
                    icon: Icons.done,
                    onPressed: uploadImage,
                  )
                : Container(),
          ],
        ),
        body: Center(
          child: Container(
            width: Device.getMaxWidth(context),
            height: Device.getMaxWidth(context),
            child: Hero(
              tag: "profile",
              child: user.account.imageUrl != null
                  ? imageManager.image != null
                      ? Image.file(
                          imageManager.image,
                          fit: BoxFit.cover,
                        )
                      : Image(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(user.account.imageUrl),
                        )
                  : Container(
                      color: Palette.mustard,
                      child: Center(
                        child: Text(
                          Device.getFirstLetter(
                            user.account.businessName.isEmpty
                                ? user.account.fullname
                                : user.account.businessName,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
