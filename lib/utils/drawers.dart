import 'package:flutter/material.dart';

class Drawers {
  static bottom({
    @required BuildContext context,
    @required List<Widget> children,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
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

  static keyboard({
    @required BuildContext context,
    @required Widget child,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: child,
        );
      },
    );
  }
}
