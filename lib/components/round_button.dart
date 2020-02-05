import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoundButton extends StatelessWidget {
  RoundButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
    this.name,
    this.margin = const EdgeInsets.all(5),
    this.fillColor = Colors.transparent,
    this.splashColor = Colors.black12,
  });

  final IconData icon;
  final GestureTapCallback onPressed;
  final String name;
  final EdgeInsets margin;
  final Color fillColor;
  final Color splashColor;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    Job job = Provider.of<Job>(context);

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
              Icon(
                this.icon,
                color: user.loading || job.loading ? Colors.black54 : Colors.black,
              ),
              this.name != null
                  ? CircleAvatar(
                      radius: 18,
                      backgroundColor: Palette.mustard,
                      child: Text(
                        Device.getFirstLetter(this.name),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        onPressed: user.loading || job.loading ? null : this.onPressed,
      ),
    );
  }
}
