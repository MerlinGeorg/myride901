import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/services/shared_preference.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/login_data/login_data.dart';

class EditProfileBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;

  TextEditingController txtFirstname = TextEditingController();
  TextEditingController txtLastname = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  File? file;
  User? user;
  @override
  void dispose() {
    mainStreamController.close();
  }

  bool checkValidation() {
    if (Validation.checkIsEmpty(
        textEditingController: txtFirstname,
        msg: StringConstants.pleaseEnterFirstName)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtLastname,
        msg: StringConstants.pleaseEnterLastName)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtEmail,
        msg: StringConstants.pleaseEnterEmail)) {
      return false;
    } else if (Validation.isNotValidEmail(textEditingController: txtEmail)) {
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
          .updateProfile(
              first_name: txtFirstname.text,
              last_name: txtLastname.text,
              profile_image: file,
              email: txtEmail.text)
          .then((value) {
        var loginData = AppComponentBase.getInstance().getLoginData();
        loginData.user?.firstName = txtFirstname.text;
        loginData.user?.lastName = txtLastname.text;
        loginData.user?.email = txtEmail.text;
        SharedPreference pref =
            AppComponentBase.getInstance().getSharedPreference();
        pref.setUserDetail(loginData);
        AppComponentBase.getInstance().setLoginData(loginData);
        CommonToast.getInstance().displayToast(message: value);
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  void btnDeleteAccount({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    AppComponentBase.getInstance()
        .getApiInterface()
        .getUserRepository()
        .deleteAccount()
        .then((value) {
      AppComponentBase.getInstance().clearData();
      SharedPreference pref =
          AppComponentBase.getInstance().getSharedPreference();
      pref.clearData();

      logout();

      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          RouteName.root, (route) => false,
          arguments: ItemArgument(data: {}));
    }).catchError((onError) {
      print(onError);
    });
  }

  void logout() {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getUserRepository()
        .logout()
        .then((value) {})
        .catchError((onError) {
      print(onError);
    });
  }
}
