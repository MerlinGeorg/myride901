import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myride901/main.dart';
import 'package:myride901/core/themes/app_theme.dart';

class CommonToast {
  static CommonToast? _instance;
  AppThemeState _appTheme = AppThemeState();
  static CommonToast getInstance() {
    if (_instance == null) {
      _instance = CommonToast();
    }
    return _instance!;
  }

  void displayToast({String message = ''}) {
    FToast fToast = FToast();
    fToast.removeCustomToast();
    fToast.init(navigatorKey.currentContext!);
    Widget toast = Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: _appTheme.primaryColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      toastDuration: Duration(seconds: 3),
      gravity: ToastGravity.CENTER,
    );
  }
}
