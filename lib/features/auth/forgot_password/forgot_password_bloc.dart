import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class ForgotPasswordBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();
  Stream<bool> get mainStream => mainStreamController.stream;
  TextEditingController txtEmail = TextEditingController();
  @override
  void dispose() {
    mainStreamController.close();
  }

  bool checkValidation() {
    if (Validation.checkIsEmpty(
        textEditingController: txtEmail,
        msg: StringConstants.pleaseEnterEmail)) {
      return false;
    } else if (Validation.isNotValidEmail(textEditingController: txtEmail)) {
      return false;
    } else {
      return true;
    }
  }

  void btnBackClicked({BuildContext? context}) {
    Navigator.pop(context!);
  }

  void btnSendClicked({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getUserRepository()
          .forgotPassword(email: txtEmail.text)
          .then((value) {
        CommonToast.getInstance().displayToast(message: value);
        Navigator.of(context).pop();
      }).catchError((onError) {
        print(onError);
      });
    }
  }
}
