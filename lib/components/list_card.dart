import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final String fullname;
  final String workPosition;
  final String imageUrl;
  final GestureTapCallback onPressed;
  final bool declined;
  final GestureTapCallback onAccept;
  final GestureTapCallback onReject;

  ListCard({
    @required this.fullname,
    @required this.workPosition,
    @required this.imageUrl,
    @required this.onPressed,
    this.declined = false,
    this.onAccept,
    this.onReject,
  });

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
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            RawMaterialButton(
              onPressed: this.declined ? null : this.onPressed,
              splashColor: Colors.grey[200],
              padding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BuildUser(
                    imageUrl: this.imageUrl,
                    fullname: this.fullname,
                  ),
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
                  SizedBox(height: 5),
                  this.onAccept == null && this.onReject == null
                      ? Container()
                      : this.declined
                          ? Text(
                              "Declined",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : Container(height: 40),
                ],
              ),
            ),
            this.onAccept == null && this.onReject == null
                ? Container()
                : this.declined
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: BuildButtons(
                          onAccept: this.onAccept,
                          onReject: this.onReject,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class BuildUser extends StatelessWidget {
  final String fullname;
  final String imageUrl;

  BuildUser({
    @required this.fullname,
    @required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    Widget handleAvatar() {
      if (this.imageUrl == null || this.imageUrl.isEmpty || this.imageUrl == "null") {
        return CircleAvatar(
          radius: 35,
          backgroundColor: Palette.mustard,
          child: Text(
            Device.getFirstLetter(this.fullname),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }

      return CircleAvatar(
        radius: 35,
        backgroundColor: Colors.grey[100],
        backgroundImage: CachedNetworkImageProvider(this.imageUrl),
      );
    }

    return Row(
      children: <Widget>[
        handleAvatar(),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              this.fullname,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
            Text(
              "is applying a position for",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BuildButtons extends StatelessWidget {
  final onAccept;
  final onReject;

  BuildButtons({
    @required this.onAccept,
    @required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          onPressed: this.onReject,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(
                Icons.clear,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                "Reject",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        FlatButton(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          onPressed: this.onAccept,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(
                Icons.done,
                color: Colors.green,
              ),
              SizedBox(width: 10),
              Text(
                "Accept",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
