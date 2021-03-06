import 'package:Gig/components/chat_tile.dart';
import 'package:Gig/components/empty_state.dart';
import 'package:Gig/models/chat_room.dart';
import 'package:Gig/models/image_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ImageManager imageManager = Provider.of<ImageManager>(context);
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
            return EmptyState(
              imagePath: "assets/empty_message.png",
              message: "No new messages for now 🤷",
            );
          }

          return ListView(
            children: snapshot.data.documents.map((document) {
              if (document["uid"] != null) {
                imageManager.addAccountId(document["uid"]);
              }

              return ChatTile(
                name: document["name"],
                imageUrl: imageManager.getImageUrl(document["uid"]),
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
