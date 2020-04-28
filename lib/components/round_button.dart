import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  RoundButton({
    Key key,
    this.icon,
    @required this.onPressed,
    this.loading = false,
    this.name,
    this.imageUrl,
    this.margin = const EdgeInsets.all(5),
    this.fillColor = Colors.transparent,
    this.splashColor = Colors.black12,
    this.inverted = false,
  });

  final bool loading;
  final IconData icon;
  final GestureTapCallback onPressed;
  final String name;
  final String imageUrl;
  final EdgeInsets margin;
  final Color fillColor;
  final Color splashColor;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    Color handleColor() {
      if (this.loading) {
        return this.loading ? this.inverted ? Colors.grey : Colors.black54 : Colors.black;
      }

      if (this.inverted) {
        return Colors.white;
      }

      return Colors.black;
    }

    Function handleOnPressed() {
      if (this.loading) {
        return this.loading ? null : this.onPressed;
      }

      return this.onPressed;
    }

    Widget handleAvatar() {
      if (this.imageUrl?.isNotEmpty ?? false) {
        if (this.imageUrl != "null") {
          return Container(
            height: 36,
            width: 36,
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

      if (this.name != null) {
        return CircleAvatar(
          radius: 18,
          backgroundColor: Palette.mustard,
          child: Text(
            Device.getFirstLetter(this.name),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }

      return Container();
    }

    return Container(
      margin: this.margin,
      child: RawMaterialButton(
        elevation: 0,
        highlightElevation: 0,
        constraints: BoxConstraints.tightFor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        fillColor: this.fillColor,
        splashColor: this.splashColor,
        child: Padding(
          padding: this.name != null ? const EdgeInsets.all(3.0) : const EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              this.icon != null
                  ? Icon(
                      this.icon,
                      color: handleColor(),
                    )
                  : Container(),
              handleAvatar(),
            ],
          ),
        ),
        onPressed: handleOnPressed(),
      ),
    );
  }
}
