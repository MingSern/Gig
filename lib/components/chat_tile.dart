import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:Gig/utils/time.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String lastMessage;
  final int createdAt;
  final VoidCallback onTap;
  final int quantity;

  ChatTile({
    @required this.name,
    @required this.imageUrl,
    @required this.lastMessage,
    @required this.createdAt,
    @required this.onTap,
    this.quantity = 0,
  });

  @override
  Widget build(BuildContext context) {
    Widget handleAvatar() {
      if (this.imageUrl?.isNotEmpty ?? false) {
        if (this.imageUrl != "null") {
          return Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: this.imageUrl,
                fadeOutCurve: Curves.easeIn,
                fadeInDuration: Duration(milliseconds: 500),
              ),
            ),
          );
        }
      }

      return CircleAvatar(
        radius: 28,
        backgroundColor: Palette.mustard,
        child: Text(
          Device.getFirstLetter(this.name),
          style: TextStyle(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

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
                  child: handleAvatar(),
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
                                color: Colors.grey,
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
                          this.quantity == 0
                              ? Container()
                              : CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Palette.lapizBlue,
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
