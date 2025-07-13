import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/services/shared_preference.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/login_data/login_data.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/auth/onboard/onboard_bloc.dart';

class LoginBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();
  Stream<bool> get mainStream => mainStreamController.stream;
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  FocusNode fnEmail = FocusNode();
  FocusNode fnPassword = FocusNode();
  var arguments;

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
    } else if (Validation.checkIsEmpty(
        textEditingController: txtPassword,
        msg: StringConstants.pleaseEnterPassword)) {
      return false;
    } else {
      return true;
    }
  }

  void btnGoogleClicked({BuildContext? context}) {
    OnBoardBloc onBoardBloc = OnBoardBloc();
    onBoardBloc.btnGoogleClicked(context: context!);
  }

  void btnAppleClicked({BuildContext? context}) {
    OnBoardBloc onBoardBloc = OnBoardBloc();
    onBoardBloc.btnAppleClicked(context: context!);
  }

  void btnSignInClicked({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getUserRepository()
          .login(email: txtEmail.text, password: txtPassword.text)
          .then((value) async {
        var user = value.toJson()['user'] as User;
        if (user.emailVerifiedAt == null) {
          Navigator.of(context, rootNavigator: false).pushNamed(
              RouteName.otpVerification,
              arguments:
                  ItemArgument(data: {'loginData': value, 'fromLogin': true}));
        } else {
          SharedPreference pref =
              AppComponentBase.getInstance().getSharedPreference();
          pref.setUserDetail(value);
          pref.setUserName(value);
          await AppComponentBase.getInstance().setLoginData(value);

          await Utils.getDetail();
          LoginData loginData = AppComponentBase.getInstance().getLoginData();

          if (loginData.user?.status == "0") {
            // account deleted
            pref.clearData();

            Utils.showAlertDialogCallBack1(
              context: context,
              message:
                  "You can't access the app because you have deleted your account",
              isOnlyOK: true,
              okBtnName: "OK",
              onOkClick: () => {},
            );
          } else {
            loginData.user!.totalVehicles == 0
                ? Navigator.of(context, rootNavigator: true)
                    .pushNamedAndRemoveUntil(
                        RouteName.onboarding, (route) => false,
                        arguments: ItemArgument(data: {}))
                : Navigator.of(context, rootNavigator: true)
                    .pushNamedAndRemoveUntil(
                        RouteName.dashboard, (route) => false,
                        arguments: ItemArgument(data: {}));
          }
        }
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  void btnSignUpClicked({BuildContext? context}) {
    print(arguments);
    if (arguments != null) {
      Navigator.pop(context!);
    } else {
      Navigator.pushNamed(context!, RouteName.signUp,
          arguments: ItemArgument(data: true));
    }
  }

  void btnForgotPasswordClicked({BuildContext? context}) {
    Navigator.pushNamed(context!, RouteName.forgotPassword);
  }
}
