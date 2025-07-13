import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/widgets/check_box.dart';
import 'package:myride901/features/auth/signup/sign_up_bloc.dart';
import 'package:myride901/features/auth/widget/autho_textformfield.dart';
import 'package:myride901/features/auth/widget/authentication_bg.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _signUpBloc = SignUpBloc();
  AppThemeState _appTheme = AppThemeState();

  double systemVersion = 0;

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _signUpBloc.arguments =
          (ModalRoute.of(context)?.settings.arguments as ItemArgument);
    });
  }

  @override
  Widget build(BuildContext context) {
    double space = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        800;

    space = space + ((Platform.isIOS && systemVersion >= 13) ? 0 : 60);
    space = space < 30 ? 30 : space;

    _appTheme = AppTheme.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _signUpBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: BlocProvider<SignUpBloc>(
                  bloc: _signUpBloc,
                  child: AuthenticationBG(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30, bottom: 20, left: 20, right: 20),
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                          overscroll.disallowIndicator();
                          return true;
                        },
                        child: ListView(
                          physics: ClampingScrollPhysics(),
                          children: [
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      _signUpBloc.btnBackClicked(
                                          context: context);
                                    },
                                    child: SvgPicture.asset(
                                        AssetImages.back_icon)),
                                SizedBox(
                                  width: 60,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${StringConstants.label_welcome},',
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w700,
                                          color: _appTheme.primaryColor,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      StringConstants.label_sign_up_to_continue,
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black.withOpacity(0.5),
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            AuthoTextFormField(
                                textEditingController: _signUpBloc.txtFirstName,
                                hintText: StringConstants.firstName,
                                textInputAction: TextInputAction.next,
                                prefixIcon: AssetImages.user,
                                focusNode: _signUpBloc.fnFirstName,
                                onFieldSubmitted: (str) {
                                  FocusScope.of(context)
                                      .requestFocus(_signUpBloc.fnLastName);
                                }),
                            SizedBox(
                              height: 25,
                            ),
                            AuthoTextFormField(
                                textEditingController: _signUpBloc.txtLastName,
                                hintText: StringConstants.lastName,
                                textInputAction: TextInputAction.next,
                                prefixIcon: AssetImages.user,
                                focusNode: _signUpBloc.fnLastName,
                                onFieldSubmitted: (str) {
                                  FocusScope.of(context)
                                      .requestFocus(_signUpBloc.fnEmail);
                                }),
                            SizedBox(
                              height: 25,
                            ),
                            AuthoTextFormField(
                                textEditingController: _signUpBloc.txtEmail,
                                hintText: StringConstants.email,
                                textInputAction: TextInputAction.next,
                                isSVG: false,
                                prefixIcon: AssetImages.mail,
                                focusNode: _signUpBloc.fnEmail,
                                onFieldSubmitted: (str) {
                                  FocusScope.of(context)
                                      .requestFocus(_signUpBloc.fnPassword);
                                }),
                            SizedBox(
                              height: 25,
                            ),
                            AuthoTextFormField(
                              textEditingController: _signUpBloc.txtPassword,
                              hintText: StringConstants.password,
                              textInputAction: TextInputAction.next,
                              prefixIcon: AssetImages.lock,
                              isVisibleToggle: true,
                              obscureText: true,
                              focusNode: _signUpBloc.fnPassword,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            AuthoTextFormField(
                              textEditingController:
                                  _signUpBloc.txtConfirmPassword,
                              hintText: StringConstants.confirm_password,
                              prefixIcon: AssetImages.lock,
                              isVisibleToggle: true,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).unfocus(),
                              obscureText: true,
                              focusNode: _signUpBloc.fnConfirmPassword,
                            ),
                            Text(
                              StringConstants.label_pass_valid,
                              style: GoogleFonts.roboto(
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                  fontSize: 10),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyRideCheckBox(
                                  isChecked: _signUpBloc.isAcceptTermsAndPolicy,
                                  size: Size(20, 20),
                                  onCheckClick: (value) {
                                    setState(() {
                                      _signUpBloc.isAcceptTermsAndPolicy =
                                          !_signUpBloc.isAcceptTermsAndPolicy;
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text: StringConstants
                                          .check_here_to_indicate_that,
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: _appTheme.primaryColor
                                              .withOpacity(0.3)),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pushNamed(context,
                                                  RouteName.webViewDisplayPage,
                                                  arguments:
                                                      ItemArgument(data: {
                                                    'url': StringConstants
                                                        .linkPrivacy,
                                                    'title': 'Privacy Policy',
                                                    'id': 2
                                                  }));
                                            },
                                          style: GoogleFonts.roboto(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: _appTheme.primaryColor),
                                        ),
                                        TextSpan(
                                          text: ' and ',
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: _appTheme.primaryColor
                                                  .withOpacity(0.3)),
                                        ),
                                        TextSpan(
                                          text: 'Terms of Use.',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pushNamed(context,
                                                  RouteName.webViewDisplayPage,
                                                  arguments: ItemArgument(
                                                      data: {
                                                        'url': StringConstants
                                                            .linkTerms,
                                                        'title': 'Terms Of Use',
                                                        'id': 3
                                                      }));
                                            },
                                          style: GoogleFonts.roboto(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: _appTheme.primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            BlueButton(
                              onPress: () {
                                _signUpBloc.btnSignUpClicked(context: context);
                              },
                              text: StringConstants.signUp,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            orDivider(),
                            SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Utils.socialButton(
                                  context: context,
                                  onPress: () {
                                    _signUpBloc.btnGoogleClicked(
                                        context: context);
                                  },
                                  bgColor: Colors.white,
                                  titleColor: Colors.black,
                                  title: StringConstants.btn_signup_with_google,
                                  icon: AssetImages.google),
                            ),
                            /*Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Utils.socialButton(
                                  context: context,
                                  onPress: () {
                                    _signUpBloc.btnFacebookClicked(
                                        context: context);
                                  },
                                  bgColor: Colors.white,
                                  titleColor: Colors.black,
                                  title:
                                      StringConstants.btn_signup_with_facebook,
                                  icon: AssetImages.facebook),
                            ),*/
                            if (Platform.isIOS && systemVersion >= 13)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Utils.socialButton(
                                    context: context,
                                    onPress: () {
                                      _signUpBloc.btnAppleClicked(
                                          context: context);
                                    },
                                    bgColor: Colors.white,
                                    titleColor: Colors.black,
                                    title:
                                        StringConstants.btn_signup_with_apple,
                                    icon: AssetImages.apple),
                              ),
                            SizedBox(
                              height: space,
                            ),
                            footer()
                          ],
                        ),
                      ),
                    ),
                  )),
            );
          }),
    );
  }

  Widget orDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            height: 1,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          StringConstants.changed_your_mind,
          style: GoogleFonts.roboto(
              color: Colors.black.withOpacity(0.5), letterSpacing: 0.5),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  Widget footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          StringConstants.already_have_an_account,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              fontSize: 11,
              color: Color(0xff121212).withOpacity(0.5)),
        ),
        SizedBox(
          width: 6,
        ),
        InkWell(
          onTap: () {
            _signUpBloc.btnSignInClicked(context: context);
          },
          child: Text(
            StringConstants.sign_in,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500, fontSize: 11, color: Colors.red),
          ),
        )
      ],
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
