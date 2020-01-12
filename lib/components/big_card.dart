import 'package:flutter/material.dart';

class BigCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String body;
  final String location;
  final String day;
  final GestureTapCallback onPressed;

  BigCard({
    @required this.title,
    @required this.subtitle,
    @required this.body,
    @required this.location,
    @required this.day,
    @required this.onPressed,
  });

  @override
  _BigCardState createState() => _BigCardState();
}

class _BigCardState extends State<BigCard> {
  Color mustard = Color(0xFFFCD569);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25, top: 8, right: 20),
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
        onPressed: widget.onPressed,
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
                        Text(
                          widget.day,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
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
