import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class SmallCard extends StatelessWidget {
  final String workPosition;
  final String businessName;
  final String wages;
  final String location;
  final num createdAt;
  final GestureTapCallback onPressed;
  final bool rejected;

  SmallCard({
    @required this.workPosition,
    @required this.businessName,
    @required this.wages,
    @required this.location,
    @required this.createdAt,
    @required this.onPressed,
    this.rejected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: this.rejected ? Colors.grey[100] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: this.rejected ? Colors.transparent : Colors.grey[300],
            blurRadius: 15.0,
            offset: Offset(0.0, 4.0),
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: RawMaterialButton(
        onPressed: this.rejected ? null : this.onPressed,
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
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Palette.mustard,
                  child: Text(
                    Device.getFirstLetter(this.businessName),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
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
                ),
              ],
            ),
            this.rejected
                ? Text(
                    "Rejected",
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
                  Device.getDateTime(this.createdAt),
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
