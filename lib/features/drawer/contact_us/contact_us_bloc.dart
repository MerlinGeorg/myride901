import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class ContactUsBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMail = TextEditingController();
  TextEditingController txtSubject = TextEditingController();
  TextEditingController txtMessage = TextEditingController();
  @override
  void dispose() {
    mainStreamController.close();
  }

  bool checkValidation() {
    // return true;
    if (Validation.checkIsEmpty(
        textEditingController: txtName, msg: StringConstants.pleaseEnterName)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtMail,
        msg: StringConstants.pleaseEnterEmail)) {
      return false;
    } else if (Validation.isNotValidEmail(textEditingController: txtMail)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtSubject,
        msg: StringConstants.Please_enter_summary)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtMessage,
        msg: StringConstants.Please_enter_message)) {
      return false;
    } else {
      return true;
    }
  }

  void btnAddClicked({BuildContext? context}) {
    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .contactUs(
              name: txtName.text,
              email: txtMail.text,
              subject: txtSubject.text,
              message: txtMessage.text)
          .then((value) {
        CommonToast.getInstance().displayToast(message: value);
        Navigator.pop(context!);
      }).catchError((onError) {
        print(onError);
      });
    }
  }
}
