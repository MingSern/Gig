import 'package:Gig/components/warning_message.dart';
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
  final GestureTapCallback onLongPress;
  final bool declined;
  final String message;

  SmallCard({
    @required this.workPosition,
    @required this.businessName,
    @required this.imageUrl,
    @required this.wages,
    @required this.location,
    @required this.createdAt,
    @required this.onPressed,
    this.onLongPress,
    this.declined = false,
    this.message,
  });

  Widget handleAvatar() {
    if (this.imageUrl?.isNotEmpty ?? false) {
      if (this.imageUrl != "null") {
        return Container(
          height: 70,
          width: 70,
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
    return Opacity(
      opacity: this.declined ? 0.6 : 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: this.declined ? Colors.grey[200] : Colors.white,
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
          onLongPress: this.onLongPress,
          onPressed: this.declined ? null : this.onPressed,
          splashColor: Colors.grey[200],
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
                  ? WarningMessage(
                      margin: const EdgeInsets.only(top: 10),
                      message: this.message == null || this.message == ""
                          ? "${this.businessName} declined your application."
                          : this.message,
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
      ),
    );
  }
}
