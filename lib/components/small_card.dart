import 'package:flutter/material.dart';

class SmallCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String body;
  final String location;
  final String day;
  final GestureTapCallback onPressed;

  SmallCard({
    @required this.title,
    @required this.subtitle,
    @required this.body,
    @required this.location,
    @required this.day,
    @required this.onPressed,
  });

  @override
  _SmallCardState createState() => _SmallCardState();
}

class _SmallCardState extends State<SmallCard> {
  Color mustard = Color(0xFFFCD569);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 15.0,
            offset: Offset(0.0, 4.0),
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: RawMaterialButton(
        onPressed: widget.onPressed,
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
                  backgroundColor: mustard,
                  child: Text(
                    widget.subtitle.substring(0, 1).toUpperCase(),
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
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 19,
                        ),
                      ),
                      Text(
                        widget.subtitle,
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
            Text(
              widget.body,
              style: TextStyle(
                color: mustard,
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
                  widget.location,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Text(
                  widget.day,
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
