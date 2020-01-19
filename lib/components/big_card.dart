import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  final String workPosition;
  final String businessName;
  final String wages;
  final String location;
  final num createdAt;
  final GestureTapCallback onPressed;

  BigCard({
    @required this.workPosition,
    @required this.businessName,
    @required this.wages,
    @required this.location,
    @required this.createdAt,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0),
                ),
              ),
            ),
            Expanded(
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
                            Text(
                              this.workPosition,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 19,
                              ),
                            ),
                            Text(
                              this.businessName,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          Device.getTimeAgo(this.createdAt),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
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
                        Text(
                          this.location,
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
    );
  }
}