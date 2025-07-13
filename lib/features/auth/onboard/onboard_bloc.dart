import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/services/shared_preference.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/login_data/login_data.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/terms_and_policy_dialog.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class OnBoardBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;

  @override
  void dispose() {
    mainStreamController.close();
  }

  void btnGoogleClicked({BuildContext? context}) {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    _googleSignIn.signIn().then((value) {
      List<String> arr = (value?.displayName ?? '').split(" ");
      showDialog(
          context: context!,
          builder: (BuildContext contexts) {
            return TermsAndPolicyDialog(
              onAgree: () {
                AppComponentBase.getInstance()
                    .getApiInterface()
                    .getUserRepository()
                    .loginWithGoogle(
                        email: value?.email,
                        first_name: arr.length >= 1 ? arr[0] : "",
                        last_name: arr.length >= 2 ? arr[1] : "",
                        google_profile_id: value?.id)
                    .then((value) async {
                  SharedPreference pref =
                      AppComponentBase.getInstance().getSharedPreference();
                  pref.setUserDetail(value);
                  pref.setUserName(value);
                  AppComponentBase.getInstance().setLoginData(value);
                  await Utils.getDetail();
                  LoginData loginData =
                      AppComponentBase.getInstance().getLoginData();

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
                }).catchError((onError) {
                  print(onError);
                });
              },
              onCancel: () {},
            );
          });
    }).catchError((onError) {
      print(onError);
    });
  }

  void btnAppleClicked({BuildContext? context}) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      showDialog(
          context: context!,
          builder: (BuildContext contexts) {
            return TermsAndPolicyDialog(
              onAgree: () {
                AppComponentBase.getInstance()
                    .getApiInterface()
                    .getUserRepository()
                    .loginWithApple(
                        email: credential.email ?? "",
                        first_name: credential.givenName ?? "",
                        last_name: credential.familyName ?? "",
                        apple_profile_id: credential.userIdentifier)
                    .then((value) async {
                  SharedPreference pref =
                      AppComponentBase.getInstance().getSharedPreference();
                  pref.setUserDetail(value);
                  pref.setUserName(value);
                  AppComponentBase.getInstance().setLoginData(value);
                  await Utils.getDetail();
                  LoginData loginData =
                      AppComponentBase.getInstance().getLoginData();
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
                }).catchError((onError) {
                  print(onError);
                });
              },
              onCancel: () {},
            );
          });
    } catch (e) {
      print("Sign in failed: $e");
    }
  }

  void btnEmailClicked({BuildContext? context}) {
    Navigator.pushNamed(context!, RouteName.login);
  }
}
