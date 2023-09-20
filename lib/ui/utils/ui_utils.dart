import 'package:flutter/material.dart';

import '../helper/color.dart';
import 'constants.dart';

class UiUtils {
  static void setSnackBar(String title, String msg, BuildContext context, bool showAction, {Function? onPressedAction, Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                textAlign: showAction ? TextAlign.start : TextAlign.start,
                style: const TextStyle(color: ColorsRes.white, fontWeight: FontWeight.w700, fontSize: 14.0)),
            const SizedBox(height: 5.0),
            Text(msg,
                textAlign: showAction ? TextAlign.start : TextAlign.start,
                maxLines: 2,
                style: const TextStyle(
                  color: ColorsRes.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                )),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      duration: duration ?? const Duration(seconds: 2),
      backgroundColor: ColorsRes.blueColor,
      action: showAction
          ? SnackBarAction(
        label: "Retry",
        onPressed: onPressedAction as void Function(),
        textColor: ColorsRes.white,
      )
          : null,
      elevation: 2.0,
    ));
  }

  static void modalLoading(BuildContext context, String title) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: space),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The loading indicator
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text(title)
                ],
              ),
            ),
          );
        });
  }

  static void okAlertDialog(BuildContext context, String title, String message, onPressed) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: const Text("OK"),
        )
      ],
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}