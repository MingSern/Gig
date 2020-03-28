import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onPressed;
  final double width;
  final bool smaller;
  final bool loading;
  final IconData icon;

  SecondaryButton({
    @required this.text,
    @required this.onPressed,
    this.icon,
    this.width = 150,
    this.smaller = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: this.onPressed == null ? 0.7 : 1,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        width: this.loading ? 45 : this.width,
        height: 45,
        margin: const EdgeInsets.all(5),
        child: RawMaterialButton(
          elevation: 0,
          highlightElevation: 15,
          fillColor: Palette.ashGrey,
          splashColor: Colors.black12,
          highlightColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          constraints: BoxConstraints.tight(Size(this.width, 45)),
          child: this.loading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: Colors.transparent,
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      this.icon != null
                          ? Icon(
                              this.icon,
                              color: Colors.white,
                            )
                          : Container(),
                      this.smaller
                          ? Text(
                              this.text,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            )
                          : Text(
                              this.text,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            )
                    ],
                  ),
                ),
          onPressed: this.loading ? null : this.onPressed,
        ),
      ),
    );
  }
}
