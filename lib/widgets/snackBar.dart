import 'package:flutter/material.dart';

void showSnackbar({
  @required BuildContext context,
  @required String content,
  @required String label,
  @required Function labelPressAction
  }) {
  final Widget snackBar=SnackBar(
    duration: Duration(days: 1),
    content: Text(content),
    action: SnackBarAction(
      label: label,
      onPressed: labelPressAction,
    ),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}

