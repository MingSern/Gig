import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/rounded_nav_bar.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Someone"),
        centerTitle: true,
        actions: <Widget>[
          RoundButton(
            icon: Icons.more_horiz,
            onPressed: () {},
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (content, index) {
                return index % 2 == 0 ? userChatBox() : otherChatBox();
              },
            ),
          ),
          _keyboard(),
        ],
      ),
    );
  }

  Widget userChatBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: 20, bottom: 10, left: Device.getMaxWidth(context) * 0.3),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Palette.mustard,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      // message
                      Text(
                        "Hey there, can you tell me more about the job?",
                        style: TextStyle(
                          color: Palette.ashGrey,
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      // time stamp
                      Text("1:20pm", style: TextStyle(color: Palette.ashGrey, fontSize: 10.0)),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget otherChatBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 20, bottom: 10, right: Device.getMaxWidth(context) * 0.3),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(3),
                        bottomRight: Radius.circular(20),
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // message
                      Text(
                        "Hello, yes we are a compnay that likes to keep things clean.",
                        style: TextStyle(
                          color: Palette.ashGrey,
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      // time stamp
                      Text("1:21pm", style: TextStyle(color: Palette.ashGrey, fontSize: 10.0)),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _keyboard() {
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
            onPressed: textController.clear,
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
