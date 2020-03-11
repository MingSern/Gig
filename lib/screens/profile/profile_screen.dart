import 'package:Gig/components/description_card.dart';
import 'package:Gig/components/empty_state.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/secondary_button.dart';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/dialogs.dart';
import 'package:Gig/utils/palette.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    void logout() {
      Dialogs.confirmationDialog(
        context: context,
        title: "Log out",
        content: "Are you sure you want to log out?",
        onConfirm: "Logout",
      ).then((onConfirm) {
        if (onConfirm ?? false) {
          user.logoutAccount();
        }
      });
    }

    void addDescription() {
      var arguments = {
        "isAdding": true,
        "documentId": "",
        "title": "",
        "description": "",
      };

      Navigator.pushNamed(context, "/profile/description/add", arguments: arguments);
    }

    void onEdit(dynamic document) {
      var arguments = {
        "isAdding": false,
        "documentId": document.documentID,
        "title": document["title"],
        "description": document["description"],
      };

      Navigator.pushNamed(context, "/profile/description/add", arguments: arguments);
    }

    void onDelete(dynamic document) {
      Dialogs.confirmationDialog(
        context: context,
        title: "Delete",
        content: "Are you sure you want to delete this description?",
        onConfirm: "Delete",
      ).then((onConfirm) {
        if (onConfirm ?? false) {
          user.deleteDescription(document.documentID);
        }
      });
    }

    void editImage() {
      Navigator.pushNamed(context, "/profile/image/edit");
    }

    Widget handleAvatar() {
      if (user.account.imageUrl.isNotEmpty) {
        return CircleAvatar(
          radius: 50,
          backgroundColor: Palette.mustard,
          backgroundImage: CachedNetworkImageProvider((user.account.imageUrl)),
        );
      }

      return CircleAvatar(
        radius: 50,
        backgroundColor: Palette.mustard,
        child: Text(
          Device.getFirstLetter(
            user.account.businessName.isEmpty ? user.account.fullname : user.account.businessName,
          ),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        actions: <Widget>[
          RoundButton(
            icon: Icons.exit_to_app,
            onPressed: logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: editImage,
                    child: Hero(
                      tag: "profile",
                      child: handleAvatar(),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          blurRadius: 15.0,
                          offset: Offset(0.0, 4.0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        user.account.userType == UserType.employer
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      user.applied,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text("Applied"),
                                  ],
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                user.shortlisted,
                                style: TextStyle(fontSize: 20),
                              ),
                              Text("Shortlisted"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.account.businessName.isEmpty ? user.account.fullname : user.account.businessName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        user.account.email,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SecondaryButton(
                    text: "Add description",
                    onPressed: addDescription,
                    smaller: true,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            StreamBuilder(
              stream: user.getDescriptions(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container();
                }

                if (!snapshot.hasData) {
                  return Container();
                }

                if (snapshot.data.documents.length == 0) {
                  return EmptyState(
                    imagePath: "assets/empty_profile.png",
                    message: "Add description to boost your profile 🔥",
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    var document = snapshot.data.documents.elementAt(index);

                    return DescriptionCard(
                      title: document["title"],
                      child: Text(document["description"]),
                      onEdit: () => onEdit(document),
                      onDelete: () => onDelete(document),
                    );
                  },
                );
              },
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
