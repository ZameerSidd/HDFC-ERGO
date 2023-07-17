import 'package:flutter/material.dart';

showAlert(BuildContext context, String infoMessage) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      content: Text(infoMessage),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
      ],
    ),
  );
}
