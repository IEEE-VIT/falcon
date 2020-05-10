import 'package:flutter/material.dart';

void showSnackbar({
  @required BuildContext context,
  @required String content,
  @required String label,
  @required Function labelPressAction,
  Key key,
  }) {
  final Widget snackBar=SnackBar(
    //key: key!=null ? key : Key('snackBarKey'),
    duration: Duration(days: 1),
    content: Text(content),
    action: SnackBarAction(
    key: key!=null ? key : Key('snackBarKey'),
      label: label,
      onPressed: labelPressAction,
    ),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}

