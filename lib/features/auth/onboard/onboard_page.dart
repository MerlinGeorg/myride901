import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/auth/onboard/onboard_bloc.dart';
import 'package:myride901/features/auth/widget/authentication_bg.dart';

class OnBoardPage extends StatefulWidget {
  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  final _onBoardBloc = OnBoardBloc();
  AppThemeState _appTheme = AppThemeState();
  double systemVersion = 0;
  bool isLoad = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isIOS) {
      DeviceInfoPlugin().iosInfo.then((iosInfo) {
        systemVersion = double.parse(iosInfo.systemVersion.split('.')[0]);
        print(systemVersion);
        setState(() {});
      });
      // iOS 13.1, iPhone 11 Pro Max iPhone
    }
    Future.delayed(Duration(milliseconds: 500), () {
      isLoad = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _onBoardBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              body: BlocProvider<OnBoardBloc>(
                  bloc: _onBoardBloc,
                  child: isLoad
                      ? Container()
                      : AuthenticationBG(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                              children: [
                                Spacer(),
                                SvgPicture.asset(AssetImages.fastCar),
                                Spacer(),
                                Center(
                                  child: Text(
                                    StringConstants
                                        .label_the_time_of_your_vehicle,
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 22),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      StringConstants.label_onboard_subtext,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                          height: 1.5,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black.withOpacity(0.5),
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 5),
                                  child: Utils.socialButton(
                                      context: context,
                                      onPress: () {
                                        _onBoardBloc.btnGoogleClicked(
                                            context: context);
                                      },
                                      bgColor: Colors.white,
                                      titleColor: Colors.black,
                                      title:
                                          StringConstants.btn_login_with_google,
                                      icon: AssetImages.google),
                                ),
                                if (Platform.isIOS && systemVersion >= 13)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 5),
                                    child: Utils.socialButton(
                                        context: context,
                                        onPress: () {
                                          _onBoardBloc.btnAppleClicked(
                                              context: context);
                                        },
                                        bgColor: Colors.white,
                                        titleColor: Colors.black,
                                        title: StringConstants
                                            .btn_login_with_apple,
                                        icon: AssetImages.apple),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 5),
                                  child: Utils.socialButton(
                                      key: "login_email_button",
                                      context: context,
                                      onPress: () {
                                        _onBoardBloc.btnEmailClicked(
                                            context: context);
                                      },
                                      bgColor: _appTheme.primaryColor,
                                      titleColor: Colors.white,
                                      title:
                                          StringConstants.btn_login_with_email,
                                      icon: AssetImages.mail),
                                ),
                                Spacer(),
                                footer()
                              ],
                            ),
                          ),
                        )),
            );
          }),
    );
  }

  Widget footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteName.signUp);
          },
          child: Text(
            StringConstants.dont_have_a_account,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Color(0xff121212).withOpacity(0.5)),
          ),
        ),
        SizedBox(
          width: 6,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteName.signUp);
          },
          child: Text(
            StringConstants.sign_up,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500, fontSize: 12, color: Colors.red),
          ),
        )
      ],
    );
  }
}
