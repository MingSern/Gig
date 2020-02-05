import 'package:Gig/components/chat_tile.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/models/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ChatRoom chatRoom = Provider.of<ChatRoom>(context);

    void viewChatRoom(dynamic listener) {
      chatRoom.open(listener);
      Navigator.pushNamed(context, "/chat/room");
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Messages",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        actions: <Widget>[
          RoundButton(
            icon: Icons.search,
            onPressed: () {},
          ),
          RoundButton(
            icon: Icons.more_horiz,
            onPressed: () {},
          )
        ],
      ),
      body: StreamBuilder(
        stream: chatRoom.getChatRooms(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("Only shortlisted chat exist here"),
            );
          }

          return ListView(
            children: snapshot.data.documents.map((document) {
              // print(document["name"]);
              return ChatTile(
                name: document["name"],
                lastMessage: document["lastMessage"],
                createdAt: document["createdAt"],
                onTap: () => viewChatRoom(document),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
