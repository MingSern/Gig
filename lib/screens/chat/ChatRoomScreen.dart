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

    Widget date(var date) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          date,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            RoundButton(
              icon: Icons.arrow_back,
              name: chatRoom.listenerName,
              onPressed: () => Device.goBack(context),
            ),
            Expanded(
              child: Align(
                alignment: Alignment(0, 0),
                child: Text(
                  chatRoom.listenerName,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            RoundButton(
              icon: Icons.more_horiz,
              onPressed: () {},
            ),
          ],
        ),
        centerTitle: true,
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

                if (snapshot.hasError) {
                  return Container();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    var lastIndex = snapshot.data.documents.length - 1;
                    var document = snapshot.data.documents.elementAt(index);
                    var currentDate = Device.getDate(document["createdAt"]);
                    var nextDate;

                    if (index != lastIndex) {
                      var nextDoc = snapshot.data.documents.elementAt(index + 1);
                      nextDate = Device.getDate(nextDoc["createdAt"]);
                    }

                    return Column(
                      children: <Widget>[
                        currentDate != nextDate ? date(currentDate) : Container(),
                        ChatBox(
                          uid: document["uid"],
                          message: document["message"],
                          createdAt: document["createdAt"],
                        ),
                        index == 0 ? SizedBox(height: 10) : Container(),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _Keyboard(controller: textController),
        ],
      ),
    );
  }
}

class _Keyboard extends StatelessWidget {
  final TextEditingController controller;

  _Keyboard({
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
                  controller: controller,
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
}
