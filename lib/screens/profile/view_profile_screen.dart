import 'package:Gig/components/description_card.dart';
import 'package:Gig/components/loading.dart';
import 'package:Gig/components/primary_button.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/chat_room.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/checker.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    ChatRoom chatRoom = Provider.of<ChatRoom>(context);
    var account;
    UserType userType;

    if (user.otherUser != null) {
      account = user.otherUser["account"];
      userType = Checker.getUserType(account["userType"]);
    }

    String handleFullname() {
      return account["businessName"] ?? account["fullname"];
    }

    void viewChatRoom() {
      var listener = {
        // "imageUrl": account["imageUrl"],
        "name": account["businessName"] ?? account["fullname"],
        "uid": account["uid"],
      };

      chatRoom.open(listener);
      Navigator.pushNamed(context, "/chat/room");
    }

    return Scaffold(
      appBar: AppBar(
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
      ),
      body: user.loading
          ? Loading()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: account["imageUrl"] == null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundColor: Palette.mustard,
                                child: Text(
                                  Device.getFirstLetter(handleFullname()),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: account["imageUrl"],
                                    fadeOutCurve: Curves.easeIn,
                                    fadeInDuration: Duration(milliseconds: 500),
                                  ),
                                ),
                              ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            handleFullname(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            account["email"],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            account["phoneNumber"],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(100),
                              bottomRight: Radius.circular(100),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    user.otherUser["length"],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  userType == UserType.employer ? Text("Jobs") : Text("Shortlists"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: PrimaryButton(
                          width: 125,
                          text: "Message",
                          onPressed: viewChatRoom,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: user.otherUser["descriptions"].length,
                    itemBuilder: (context, index) {
                      var document = user.otherUser["descriptions"].elementAt(index);

                      return DescriptionCard(
                        title: document["title"],
                        child: Text(document["description"]),
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
