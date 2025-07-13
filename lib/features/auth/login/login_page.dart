import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:flutter/services.dart';
import 'package:myride901/features/auth/widget/authentication_bg.dart';
import 'package:myride901/features/auth/widget/autho_textformfield.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _loginBloc = LoginBloc();
  AppThemeState _appTheme = AppThemeState();

  double systemVersion = 0;
  String? name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppComponentBase.getInstance()
        .getSharedPreference()
        .getUserName()
        .then((value) {
      if (value != null && value.user != null) {
        name = '${value.user?.firstName ?? ' '} ${value.user?.lastName ?? ' '}';
        _loginBloc.txtEmail.text = value.user?.email ?? '';
      }
      setState(() {});
    });
    if (Platform.isIOS) {
      DeviceInfoPlugin().iosInfo.then((iosInfo) {
        systemVersion = double.parse(iosInfo.systemVersion.split('.')[0]);
        print(systemVersion);
        setState(() {});
      });
      // iOS 13.1, iPhone 11 Pro Max iPhone
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loginBloc.arguments = ModalRoute.of(context)!.settings.arguments == null
          ? null
          : (ModalRoute.of(context)!.settings.arguments as ItemArgument);
    });
  }

  @override
  Widget build(BuildContext context) {
    double space = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        675;

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
          stream: _loginBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: BlocProvider<LoginBloc>(
                  bloc: _loginBloc,
                  child: AuthenticationBG(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30, bottom: 20, left: 20, right: 20),
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${StringConstants.label_welcome}' +
                                    (name == null ? '' : ' ${name}') +
                                    ',',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w700,
                                    color: _appTheme.primaryColor,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                StringConstants.label_sign_in_to_continue,
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          AuthoTextFormField(
                            key: Key('login_email'),
                            textEditingController: _loginBloc.txtEmail,
                            hintText: StringConstants.email,
                            isSVG: false,
                            textInputAction: TextInputAction.next,
                            focusNode: _loginBloc.fnEmail,
                            prefixIcon: AssetImages.mail,
                            onFieldSubmitted: (str) {
                              FocusScope.of(context)
                                  .requestFocus(_loginBloc.fnPassword);
                            },
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          AuthoTextFormField(
                            key: Key('login_password'),
                            textEditingController: _loginBloc.txtPassword,
                            textInputAction: TextInputAction.done,
                            hintText: StringConstants.password,
                            prefixIcon: AssetImages.lock,
                            isVisibleToggle: true,
                            focusNode: _loginBloc.fnPassword,
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment(1, 0),
                            child: InkWell(
                              onTap: () {
                                _loginBloc.btnForgotPasswordClicked(
                                    context: context);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  StringConstants.label_forgot_pass,
                                  style: GoogleFonts.roboto(
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w500,
                                      color: _appTheme.primaryColor,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          BlueButton(
                            onPress: () {
                              _loginBloc.btnSignInClicked(context: context);
                            },
                            text: StringConstants.signIn,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          orDivider(),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Utils.socialButton(
                                context: context,
                                onPress: () {
                                  _loginBloc.btnGoogleClicked(context: context);
                                },
                                bgColor: Colors.white,
                                titleColor: Colors.black,
                                title: StringConstants.btn_login_with_google,
                                icon: AssetImages.google),
                          ),
                          if (Platform.isIOS && systemVersion >= 13)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Utils.socialButton(
                                  context: context,
                                  onPress: () {
                                    _loginBloc.btnAppleClicked(
                                        context: context);
                                  },
                                  bgColor: Colors.white,
                                  titleColor: Colors.black,
                                  title: StringConstants.btn_login_with_apple,
                                  icon: AssetImages.apple),
                            ),
                          SizedBox(
                            height: space,
                          ),
                          footer()
                        ],
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
        InkWell(
          onTap: () {
            _loginBloc.btnSignUpClicked(context: context);
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
            _loginBloc.btnSignUpClicked(context: context);
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
