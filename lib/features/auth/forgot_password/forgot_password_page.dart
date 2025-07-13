import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/features/auth/forgot_password/forgot_password_bloc.dart';
import 'package:myride901/features/auth/widget/authentication_bg.dart';
import 'package:myride901/features/auth/widget/autho_textformfield.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _forgotPasswordBloc = ForgotPasswordBloc();
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double space = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        670;
    space = space < 30 ? 30 : space;
    _appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _forgotPasswordBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              body: BlocProvider<ForgotPasswordBloc>(
                  bloc: _forgotPasswordBloc,
                  child: AuthenticationBG(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30, bottom: 20, left: 20, right: 20),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment(-1, 0),
                              child: InkWell(
                                  onTap: () {
                                    _forgotPasswordBloc.btnBackClicked(
                                        context: context);
                                  },
                                  child:
                                      SvgPicture.asset(AssetImages.back_icon))),
                          Expanded(
                            child: ListView(
                              physics: ClampingScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: 55,
                                ),
                                SvgPicture.asset(AssetImages.pass_lock),
                                SizedBox(
                                  height: 25,
                                ),
                                Center(
                                  child: Text(
                                    StringConstants.label_forgot_password,
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w700,
                                        color: _appTheme.primaryColor,
                                        fontSize: 20),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  StringConstants.forgot_pass_sub_text,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black.withOpacity(0.5),
                                      height: 1.5,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 55,
                                ),
                                AuthoTextFormField(
                                  hintText: StringConstants.email,
                                  prefixIcon: AssetImages.mail,
                                  textEditingController:
                                      _forgotPasswordBloc.txtEmail,
                                  isSVG: false,
                                  textInputAction: TextInputAction.done,
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                BlueButton(
                                  onPress: () {
                                    _forgotPasswordBloc.btnSendClicked(
                                        context: context);
                                  },
                                  text: StringConstants.send,
                                ),
                                SizedBox(
                                  height: space,
                                ),
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      _forgotPasswordBloc.btnBackClicked(
                                          context: context);
                                    },
                                    child: Text(
                                      StringConstants.back_to_login,
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                          color: Colors.red),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            );
          }),
    );
  }
}
