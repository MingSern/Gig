import 'package:Gig/components/round_button.dart';
import 'package:Gig/models/image_manager.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ImageManager imageManager = Provider.of<ImageManager>(context);

    void openGallery() {
      imageManager.openGallery();
    }

    void openCamera() {
      imageManager.openCamera();
    }

    void uploadImage() {
      imageManager.uploadImage();
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
          RoundButton(icon: Icons.done, onPressed: uploadImage),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundColor: Palette.mustard,
            backgroundImage: imageManager.image != null
                ? FileImage(imageManager.image)
                : CachedNetworkImageProvider(
                    imageManager.imageUrl,
                  ),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.image),
                onPressed: openGallery,
              ),
              SizedBox(width: 50),
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: openCamera,
              ),
            ],
          )
        ],
      ),
    );
  }
}
