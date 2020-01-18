import 'package:Gig/components/round_button.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
      body: ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(left: 90, right: 20),
            height: 0.5,
            color: Colors.grey[300],
          );
        },
        itemBuilder: (context, index) {
          return chat(context);
        },
      ),
    );
  }

  Widget chat(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, "/chat/room"),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Palette.mustard,
                child: Text(
                  "L",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "lioncity manpower pte ltd",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "1:20pm",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "We received your application asdasdkajsdnakjdsn",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.redAccent,
                        child: Text(
                          "2",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[50],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
