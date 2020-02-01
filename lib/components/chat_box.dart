import 'package:Gig/models/user.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBox extends StatelessWidget {
  final uid;
  final message;
  final createdAt;

  ChatBox({
    @required this.uid,
    @required this.message,
    @required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: user.userId == this.uid
                    ? EdgeInsets.only(
                        right: 20,
                        bottom: 10,
                        left: Device.getMaxWidth(context) * 0.3,
                      )
                    : EdgeInsets.only(
                        left: 20,
                        bottom: 10,
                        right: Device.getMaxWidth(context) * 0.3,
                      ),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: user.userId == this.uid ? Palette.mustard : Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: user.userId == this.uid ? Radius.circular(20) : Radius.circular(3),
                    bottomRight: user.userId == this.uid ? Radius.circular(3) : Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: user.userId == this.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      this.message,
                      style: TextStyle(
                        color: Palette.ashGrey,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      Device.getTimeAgo(this.createdAt),
                      style: TextStyle(
                        color: Palette.ashGrey,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
