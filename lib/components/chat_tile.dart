import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:Gig/utils/time.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final name;
  final lastMessage;
  final createdAt;
  final onTap;

  ChatTile({
    @required this.name,
    @required this.lastMessage,
    @required this.createdAt,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: this.onTap,
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
                      Device.getFirstLetter(this.name),
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
                              this.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              Time.getDateTime(this.createdAt),
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
                              this.lastMessage,
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
        ),
        Container(
          margin: const EdgeInsets.only(left: 90, right: 20),
          height: 0.5,
          color: Colors.grey[400],
        )
      ],
    );
  }
}
