// import 'package:firebase_core/firebase_core.dart'; // Firebase disabled
import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/core/presentation/widgets/show_alert_dialog.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  required String title,
  required Exception exception,
}) =>
    showAlertDialog(
      context,
      title: title,
      content: _message(exception),
      defaultActionText: 'OK',
    );

String _message(Exception exception) {
  // Firebase disabled - just return exception string
  return exception.toString();
}
