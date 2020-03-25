import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:Gig/utils/time.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  final String workPosition;
  final String businessName;
  final String imageUrl;
  final String wages;
  final String location;
  final num createdAt;
  final GestureTapCallback onPressed;
  final bool isEmpty;

  BigCard({
    this.workPosition,
    this.businessName,
    this.imageUrl,
    this.wages,
    this.location,
    this.createdAt,
    this.onPressed,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: this.isEmpty ? 0.5 : 1,
      child: Container(
        width: Device.getMaxWidth(context) * 0.85,
        margin: const EdgeInsets.only(bottom: 25, top: 8, right: 10, left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              blurRadius: 10.0,
              offset: Offset(0.0, 4.0),
            ),
          ],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: RawMaterialButton(
          onPressed: this.onPressed,
          splashColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                  ),
                  child: this.imageUrl == null
                      ? Image.asset(
                          "assets/empty_image.png",
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: this.imageUrl,
                          fadeOutCurve: Curves.easeIn,
                          fadeInDuration: Duration(milliseconds: 500),
                        ),
                ),
              ),
              this.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text("Can't find any jobs for you. 😢"),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
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
                              ],
                            ),
                            Text(
                              "RM ${this.wages}/hr",
                              style: TextStyle(
                                color: Palette.mustard,
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                              ),
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
                                Container(
                                  width: 200,
                                  child: Text(
                                    this.location,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  Time.getDateTime(createdAt),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
