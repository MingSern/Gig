import 'package:Gig/components/primary_button.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/models/image_manager.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/dialogs.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdditionalInfoScreen extends StatelessWidget {
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
      user.account.setImageUrl(imageUrl);
    }

    void verifyAccount() async {
      if (imageManager.image != null) {
        await uploadImage();
      }

      await user.verifyAccount(user.account).then((_) {
        if (user.containsError) {
          user.showErrorMessage(context);
        } else {
          Navigator.pushNamed(context, "/verification");
        }
      });
    }

    void optionDialog() {
      Dialogs.confirmationDialog(
        context: context,
        title: "Select image",
        content: "Select your image from",
        onCancel: "gallery",
        onConfirm: "camera",
      ).then((onSelect) {
        if (onSelect == true) {
          openCamera();
        } else if (onSelect == false) {
          openGallery();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: RoundButton(
          provider: user,
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
        title: Text("Additional info"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: <Widget>[
                imageManager.image == null
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
                        backgroundImage: FileImage(imageManager.image),
                      ),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Palette.ashGrey,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: optionDialog,
                ),
              ],
            ),
            PrimaryButton(
              text: "Next",
              onPressed: verifyAccount,
            ),
          ],
        ),
      ),
    );
  }
}
