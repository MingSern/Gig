import 'package:Gig/components/chat_box.dart';
import 'package:Gig/components/date.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/rounded_nav_bar.dart';
import 'package:Gig/components/warning_message.dart';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/chat_room.dart';
import 'package:Gig/models/image_manager.dart';
import 'package:Gig/models/screen_controller.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/algorithm.dart';
import 'package:Gig/utils/palette.dart';
import 'package:Gig/utils/time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenController controller = Provider.of<ScreenController>(context);
    ImageManager imageManager = Provider.of<ImageManager>(context);
    ChatRoom chatRoom = Provider.of<ChatRoom>(context);
    User user = Provider.of<User>(context);

    Future<bool> onWillPop() {
      controller.goTo(context: context, screenIndex: 2);

      return Future.value(false);
    }

    Widget checkMessage(DocumentSnapshot document) {
      if (document["uid"] != user.userId && user.isJobSeeker()) {
        bool verified = Algorithm.verifyMessage(document["message"]);

        if (verified) {
          return WarningMessage(
            level: WarningLevel.danger,
            message: "The message above indicates a potential scam.",
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          );
        }
      }

      return Container();
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Row(
            children: <Widget>[
              RoundButton(
                icon: Icons.arrow_back,
                name: chatRoom.listener["name"],
                imageUrl: imageManager.getImageUrl(chatRoom.listener["uid"]),
                onPressed: () => controller.goTo(context: context, screenIndex: 2),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment(0, 0),
                  child: Text(
                    chatRoom.listener["name"],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              RoundButton(
                // icon: Icons.more_horiz,
                onPressed: null,
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: StreamBuilder(
                stream: chatRoom.getMessages(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  if (snapshot.hasError) {
                    return Container();
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      var lastIndex = snapshot.data.documents.length - 1;
                      var document = snapshot.data.documents.elementAt(index);
                      var currentDate = Time.getDate(document["createdAt"]);
                      var nextDate;

                      if (index != lastIndex) {
                        var nextDoc = snapshot.data.documents.elementAt(index + 1);
                        nextDate = Time.getDate(nextDoc["createdAt"]);
                      }

                      return Column(
                        children: <Widget>[
                          user.isJobSeeker()
                              ? index == lastIndex
                                  ? WarningMessage(
                                      message:
                                          "Please be aware of scams. Keep in mind that normal employers will not ask for any sensitive or bank informations from you.",
                                    )
                                  : Container()
                              : Container(),
                          currentDate != nextDate ? Date(date: currentDate) : Container(),
                          ChatBox(
                            uid: document["uid"],
                            message: document["message"],
                            createdAt: document["createdAt"],
                          ),
                          checkMessage(document),
                          index == 0 ? SizedBox(height: 10) : Container(),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Keyboard(controller: textController),
          ],
        ),
      ),
    );
  }
}

class Keyboard extends StatelessWidget {
  final TextEditingController controller;

  Keyboard({
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ChatRoom chatRoom = Provider.of<ChatRoom>(context);

    void sendMessage() {
      String message = controller.text.trim();

      if (message.isNotEmpty) {
        chatRoom.createMessage(message).then((_) {
          if (chatRoom.containsError) {
            chatRoom.showErrorMessage(context);
          }
        });

        controller.clear();
      }
    }

    return RoundedNavBar(
      expandable: true,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
      items: <Widget>[
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(2.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 80.0,
              ),
              child: SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.vertical,
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  controller: controller,
                  maxLines: null,
                  decoration: InputDecoration.collapsed(hintText: "Type a message..."),
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 3),
          child: RaisedButton(
            color: Palette.ashGrey,
            onPressed: sendMessage,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Text(
              "Send",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
