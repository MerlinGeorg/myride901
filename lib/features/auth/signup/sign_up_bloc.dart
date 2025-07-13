import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/login_data/login_data.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/auth/onboard/onboard_bloc.dart';
import 'package:myride901/core/services/analytic_services.dart';

class SignUpBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  FocusNode fnFirstName = FocusNode();
  FocusNode fnLastName = FocusNode();
  FocusNode fnEmail = FocusNode();
  FocusNode fnPassword = FocusNode();
  FocusNode fnConfirmPassword = FocusNode();
  bool isAcceptTermsAndPolicy = false;

  var arguments;

  @override
  void dispose() {
    mainStreamController.close();
  }

  bool? checkValidation() {
    if (Validation.checkIsEmpty(
        textEditingController: txtFirstName,
        msg: StringConstants.pleaseEnterFirstName)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtLastName,
        msg: StringConstants.pleaseEnterLastName)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtEmail,
        msg: StringConstants.pleaseEnterEmail)) {
      return false;
    } else if (Validation.isNotValidEmail(textEditingController: txtEmail)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtPassword,
        msg: StringConstants.pleaseEnterPassword)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtConfirmPassword,
        msg: StringConstants.pleaseEnterConfirmPassword)) {
      return false;
    } else if (Validation.isNotValidPassword(
        textEditingController: txtPassword,
        msg: StringConstants.pleaseEnterValidPassword)) {
      return false;
    } else if (txtPassword.text != txtConfirmPassword.text) {
      CommonToast.getInstance().displayToast(
          message:
              StringConstants.Password_and_Confirm_Password_does_not_match);
      return false;
    } else if (!isAcceptTermsAndPolicy) {
      CommonToast.getInstance().displayToast(
          message:
              'Please accept the Privacy Policy and Terms of Use if you would like to use MyRide901');
    } else {
      return true;
    }
  }

  void btnGoogleClicked({BuildContext? context}) {
    OnBoardBloc onBoardBloc = OnBoardBloc();
    onBoardBloc.btnGoogleClicked(context: context);
  }

  void btnAppleClicked({BuildContext? context}) {
    OnBoardBloc onBoardBloc = OnBoardBloc();
    onBoardBloc.btnAppleClicked(context: context);
  }

  void btnSignInClicked({BuildContext? context}) {
    if (arguments != null) {
      Navigator.pop(context!);
    } else {
      Navigator.pushNamed(context!, RouteName.login,
          arguments: ItemArgument(data: true));
    }
  }

  void btnBackClicked({BuildContext? context}) => Navigator.pop(context!);

  void btnSignUpClicked({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    if (checkValidation() ?? false) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getUserRepository()
          .signUp(
              email: txtEmail.text,
              password: txtPassword.text,
              first_name: txtFirstName.text,
              last_name: txtLastName.text)
          .then((values) {
        CommonToast.getInstance().displayToast(message: values.message ?? '');
        locator<AnalyticsService>().sendAnalyticsEvent(
            eventName: "Register", clickevent: "User Registered");

        Navigator.of(context, rootNavigator: false).pushNamed(
            RouteName.otpVerification,
            arguments: ItemArgument(data: {
              'loginData': LoginData.fromJson(values.result),
              'fromLogin': false
            }));
      }).catchError((onError) {
        print(onError);
      });
    }
  }
}
