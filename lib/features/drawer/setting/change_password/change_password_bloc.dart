import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class ChangePasswordBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;

  @override
  void dispose() {
    mainStreamController.close();
  }

  TextEditingController txtCurrentPassword = TextEditingController();
  TextEditingController txtNewPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  bool checkValidation() {
    if (Validation.checkIsEmpty(
        textEditingController: txtCurrentPassword,
        msg: StringConstants.pleaseEnterCurrentPassword)) {
      return false;
    } else if (Validation.checkLength(
        textEditingController: txtCurrentPassword,
        msg: StringConstants.currentPasswordmustbeAtLeast6CharactersLong,
        length: 6)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtNewPassword,
        msg: StringConstants.pleaseEnterNewPassword)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtConfirmPassword,
        msg: StringConstants.pleaseEnterConfirmPassword)) {
      return false;
    } else if (Validation.isNotValidPassword(
        textEditingController: txtNewPassword,
        msg: StringConstants.pleaseEnterValidPassword)) {
      return false;
    } else if (txtNewPassword.text != txtConfirmPassword.text) {
      CommonToast.getInstance().displayToast(
          message:
              StringConstants.Password_and_Confirm_Password_does_not_match);
      return false;
    } else if (txtConfirmPassword.text == txtCurrentPassword.text) {
      CommonToast.getInstance().displayToast(
          message: StringConstants
              .New_password_must_be_different_from_the_current_password);
      return false;
    } else {
      return true;
    }
  }

  void btnSaveClicked({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getUserRepository()
          .changePassword(
              password: txtNewPassword.text,
              old_password: txtCurrentPassword.text,
              password_confirm: txtConfirmPassword.text)
          .then((value) {
        CommonToast.getInstance().displayToast(message: value);
        Navigator.of(context).pop();
      }).catchError((onError) {
        print(onError);
      });
    }
  }
}
