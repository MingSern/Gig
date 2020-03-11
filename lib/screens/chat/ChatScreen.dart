import 'package:Gig/components/chat_tile.dart';
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
      appBar: AppBar(
        title: Text(
          "Messages",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: chatRoom.getChatRooms(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          if (!snapshot.hasData) {
            return Container();
          }

          if (snapshot.data.documents.length == 0) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Seems like you don't have any"),
                  Text("messages yet 🤷"),
                ],
              ),
            );
          }

          return ListView(
            children: snapshot.data.documents.map((document) {
              return ChatTile(
                name: document["name"],
                imageUrl: document["imageUrl"],
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
