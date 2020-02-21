import 'package:flutter/material.dart';

class Drawers {
  static bottom({
    @required BuildContext context,
    @required List<Widget> children,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: children.length,
          itemBuilder: (context, index) {
            return children[index];
          },
          separatorBuilder: (context, index) {
            return Divider(
              indent: 20,
              endIndent: 20,
              height: 1,
              color: Colors.grey,
            );
          },
        );
      },
    );
  }
}
