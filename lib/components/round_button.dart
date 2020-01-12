import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoundButton extends StatelessWidget {
  RoundButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
    this.margin = const EdgeInsets.all(5),
    this.fillColor = Colors.transparent,
    this.splashColor = Colors.black12,
  });

  final IconData icon;
  final GestureTapCallback onPressed;
  final EdgeInsets margin;
  final Color fillColor;
  final Color splashColor;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Container(
      margin: this.margin,
      child: RawMaterialButton(
        elevation: 0,
        highlightElevation: 0,
        constraints: BoxConstraints.tight(Size(45, 45)),
        shape: CircleBorder(),
        fillColor: this.fillColor,
        splashColor: this.splashColor,
        child: Icon(
          this.icon,
          color: user.viewState == ViewState.busy ? Colors.black54 : Colors.black,
        ),
        onPressed: user.viewState == ViewState.busy ? null : this.onPressed,
      ),
    );
  }
}
