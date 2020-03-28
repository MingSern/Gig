import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({
    @required this.text,
    @required this.onPressed,
    this.loading = false,
    this.width = 150,
  });

  final String text;
  final GestureTapCallback onPressed;
  final double width;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      width: this.loading ? 45 : this.width,
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
        child: this.loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                  backgroundColor: Colors.transparent,
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  this.text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ),
        onPressed: this.loading ? null : this.onPressed,
      ),
    );
  }
}
