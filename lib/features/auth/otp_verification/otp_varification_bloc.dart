import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/services/shared_preference.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/login_data/login_data.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class OTPVerificationBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  TextEditingController txtCode = TextEditingController();
  FocusNode fnCode = FocusNode();
  bool fromLogin = false;
  LoginData? loginData;
  bool checkValidation() {
    if (Validation.checkIsEmpty(
        textEditingController: txtCode, msg: StringConstants.pleaseEnterCode)) {
      return false;
    } else {
      return true;
    }
  }

  void btnSubmitClicked({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getUserRepository()
          .verifyCodePassword(
              email: loginData?.user?.email ?? '', code: txtCode.text)
          .then((value) async {
        if (fromLogin) {
          SharedPreference pref =
              AppComponentBase.getInstance().getSharedPreference();
          pref.setUserDetail(loginData);
          pref.setUserName(loginData);
          AppComponentBase.getInstance().setLoginData(loginData!);
          await Utils.getDetail();
          loginData = AppComponentBase.getInstance().getLoginData();

          Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              RouteName.onboarding, (route) => false,
              arguments: ItemArgument(data: {}));
        } else {
          CommonToast.getInstance().displayToast(message: value);
          Navigator.pop(context);
          Navigator.pop(context);
        }
        //   showDialog(
        //       context: context,
        //       barrierDismissible: false,
        //       builder: (BuildContext context) {
        //         return  CustomDialogBox.verified(
        //   onPress: () {
        //
        //
        //   },
        // );});
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  void btnResendClicked({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    AppComponentBase.getInstance()
        .getApiInterface()
        .getUserRepository()
        .resendCodePassword(email: loginData?.user?.email ?? '')
        .then((value) {
      CommonToast.getInstance().displayToast(message: value);
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void dispose() {
    mainStreamController.close();
  }
}
