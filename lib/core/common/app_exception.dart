import 'package:flutter/material.dart';

abstract class AppException implements Exception {
  void onException({BuildContext context, Function onButtonClick});
}

class NoInternetException extends AppException {
  @override
  void onException({BuildContext? context, Function? onButtonClick}) {
    print("Please check your Internet Connection");
  }
}

class CustomException extends AppException {
  String exception;

  CustomException(this.exception);

  @override
  void onException({BuildContext? context, Function? onButtonClick}) {
    print(exception);
  }
}

class ImagePickerException extends AppException {
  final String? error;

  ImagePickerException({this.error});

  @override
  void onException({BuildContext? context, Function? onButtonClick}) {
    print("Error while fetching image");
  }
}
