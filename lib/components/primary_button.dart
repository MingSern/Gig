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

    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      width: user.loading ? 45 : this.width,
      height: 45,
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
        child: user.loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
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
        onPressed: user.loading ? null : this.onPressed,
      ),
    );
  }
}
