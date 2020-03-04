import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:Gig/utils/time.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SmallCard extends StatelessWidget {
  final String workPosition;
  final String businessName;
  final String imageUrl;
  final String wages;
  final String location;
  final num createdAt;
  final GestureTapCallback onPressed;
  final bool declined;

  SmallCard({
    @required this.workPosition,
    @required this.businessName,
    @required this.imageUrl,
    @required this.wages,
    @required this.location,
    @required this.createdAt,
    @required this.onPressed,
    this.declined = false,
  });

  Widget handleAvatar() {
    if (this.imageUrl != null) {
      return CircleAvatar(
        radius: 35,
        backgroundColor: Palette.mustard,
        backgroundImage: CachedNetworkImageProvider(this.imageUrl),
      );
    }

    return CircleAvatar(
      radius: 35,
      backgroundColor: Palette.mustard,
      child: Text(
        Device.getFirstLetter(this.businessName),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: this.declined ? Colors.grey[100] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: this.declined ? Colors.transparent : Colors.grey[300],
            blurRadius: 15.0,
            offset: Offset(0.0, 4.0),
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: RawMaterialButton(
        onPressed: this.declined ? null : this.onPressed,
        splashColor: Colors.grey[200],
        highlightColor: Colors.transparent,
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                this.handleAvatar(),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          this.workPosition,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          this.businessName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            this.declined
                ? Text(
                    "Declined",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Text(
                    "RM ${this.wages}/hr",
                    style: TextStyle(
                      color: Palette.mustard,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.grey,
                  size: 16,
                ),
                SizedBox(
                  width: 2,
                ),
                Text(
                  this.location,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Text(
                  Time.getDateTime(this.createdAt),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
