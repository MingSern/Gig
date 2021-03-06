import 'package:Gig/components/floaty_card.dart';
import 'package:flutter/material.dart';

class DescriptionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData icon;
  final GestureTapCallback onEdit;
  final GestureTapCallback onDelete;

  DescriptionCard({
    @required this.title,
    @required this.child,
    this.icon,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return FloatyCard(
      child: RawMaterialButton(
        onPressed: this.onEdit,
        onLongPress: this.onDelete,
        splashColor: Colors.grey[200],
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: <Widget>[
                  this.icon == null
                      ? Container()
                      : Row(
                          children: <Widget>[
                            Icon(
                              this.icon,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                  Text(
                    this.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            this.child,
          ],
        ),
      ),
    );
  }
}
