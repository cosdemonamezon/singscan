import 'package:flutter/material.dart';

class LoadingDialog {
  static Future<void> open(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.5),
      builder: (BuildContext buildContext) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              child: SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        );
      },
    );
  }

  static void close(BuildContext context) {
    Navigator.pop(context);
  }
}
