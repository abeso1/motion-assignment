import 'package:flutter/material.dart';

///Class for reusable widgets accross app like loader...
///call ReusableWidgets.function();
class ReusableWidgets {
  static BuildContext? _loaderContext;

  ///loader can't be dismissed on tap (only back button)
  static Future<dynamic> showLoader(
    BuildContext context,
  ) async {
    _loaderContext = context;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white.withOpacity(0.2),
            child: Container(
                height: 45,
                width: 45,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Colors.blue,
                )),
          );
        });
  }

  ///Function to pop loader
  static void popLoader() {
    if (_loaderContext == null || !Navigator.of(_loaderContext!).canPop())
      return;
    Navigator.of(_loaderContext!).pop();
    _loaderContext = null;
  }
}
