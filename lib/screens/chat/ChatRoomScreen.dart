import 'package:Gig/components/chat_box.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/rounded_nav_bar.dart';
import 'package:Gig/models/chat_room.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
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
    ChatRoom chatRoom = Provider.of<ChatRoom>(context);

    void sendMessage() {
      String message = textController.text.trim();

      if (message.isNotEmpty) {
        chatRoom.createMessage(message).then((_) {
          if (chatRoom.containsError) {
            chatRoom.showErrorMessage(context);
          }
        });

        textController.clear();
      }
    }

    Widget keyboard() {
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
                    controller: textController,
                    maxLines: null,
                    decoration: InputDecoration.collapsed(hintText: "Type a message..."),
                    onTap: () {},
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

    return Scaffold(
      appBar: AppBar(
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
        title: Text(chatRoom.listenerName),
        centerTitle: true,
        actions: <Widget>[
          RoundButton(
            icon: Icons.more_horiz,
            onPressed: () {},
          ),
        ],
        elevation: 0,
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

                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: snapshot.data.documents.map((document) {
                    return ChatBox(
                      uid: document["uid"],
                      message: document["message"],
                      createdAt: document["createdAt"],
                    );
                  }).toList(),
                );
              },
            ),
          ),
          keyboard(),
        ],
      ),
    );
  }
}
