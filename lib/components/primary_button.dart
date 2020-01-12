import 'package:Gig/models/base.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.width = 150,
  });

  final String text;
  final GestureTapCallback onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Container(
      margin: const EdgeInsets.all(5),
      child: RawMaterialButton(
        elevation: 0,
        highlightElevation: 15,
        fillColor: Palette.mustard,
        splashColor: Colors.black12,
        highlightColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        constraints: BoxConstraints.tight(Size(this.width, 45)),
        child: user.viewState == ViewState.busy
            ? SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
                  backgroundColor: Palette.mustard,
                ),
              )
            : Text(
                this.text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 15,
                ),
              ),
        onPressed: user.viewState == ViewState.busy ? null : this.onPressed,
      ),
    );
  }
}
