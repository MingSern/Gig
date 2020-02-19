import 'package:flutter/material.dart';

class Drawers {
  static bottom({
    @required BuildContext context,
    @required List<Widget> children,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      },
    );
  }
}
