import 'package:Gig/models/user.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:Gig/utils/time.dart';
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
      mainAxisAlignment: user.userId == this.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        user.userId == this.uid
            ? Padding(
                padding: EdgeInsets.only(left: Device.getMaxWidth(context) * 0.2),
              )
            : Container(),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Palette.ashGrey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  Time.getTime(this.createdAt),
                  style: TextStyle(
                    color: Palette.ashGrey,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        user.userId != this.uid
            ? Padding(
                padding: EdgeInsets.only(right: Device.getMaxWidth(context) * 0.2),
              )
            : Container(),
      ],
    );
  }
}
