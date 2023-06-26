import 'package:flutter/material.dart';

import '../helper/color.dart';

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
}