import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/login_data/login_data.dart';
import 'package:myride901/features/auth/otp_verification/otp_varification_bloc.dart';
import 'package:myride901/features/auth/widget/authentication_bg.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:pinput/pinput.dart';

class OTPVerificationPage extends StatefulWidget {
  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final _otpVerificationBloc = OTPVerificationBloc();
  AppThemeState _appTheme = AppThemeState();
  var _arguments;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _arguments =
        (ModalRoute.of(context)?.settings.arguments as ItemArgument).data;
    _otpVerificationBloc.loginData = _arguments['loginData'] as LoginData?;
    _otpVerificationBloc.fromLogin = _arguments['fromLogin'] as bool;
    super.didChangeDependencies();
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
          stream: _otpVerificationBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: BlocProvider<OTPVerificationBloc>(
                  bloc: _otpVerificationBloc,
                  child: AuthenticationBG(
                    isFull: false,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30, bottom: 30, left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment(-1, 0),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child:
                                      SvgPicture.asset(AssetImages.back_icon))),
                          SizedBox(
                            height: 55,
                          ),
                          Text(
                            StringConstants.label_enter_your_4_digit,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                color: _appTheme.primaryColor,
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                StringConstants.label_not_received_code_yet,
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 15),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  _otpVerificationBloc.btnResendClicked(
                                      context: context);
                                },
                                child: Text(
                                  StringConstants.label_please_resend,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 55,
                          ),
                          pinPut(),
                          SizedBox(
                            height: 40,
                          ),
                          BlueButton(
                            onPress: () {
                              _otpVerificationBloc.btnSubmitClicked(
                                  context: context);
                            },
                            text: StringConstants.verify,
                          )
                        ],
                      ),
                    ),
                  )),
            );
          }),
    );
  }

  Widget pinPut() {
    AppThemeState _appTheme = AppThemeState();
    double width = (((MediaQuery.of(context).size.width - 80) / 6) - 5);
    width = width > 50 ? 50 : width;
    final pinPutDecoration = PinTheme(
        width: width,
        height: width,
        textStyle:
            GoogleFonts.roboto(fontSize: 25.0, color: _appTheme.primaryColor),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _appTheme.primaryOpactiyColor),
          borderRadius: BorderRadius.circular(10.0),
        ));
    return Pinput(
      showCursor: true,
      length: 6,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      onSubmitted: (String pin) {
        print(pin);
        FocusScope.of(context).requestFocus(FocusNode());
      },
      focusNode: _otpVerificationBloc.fnCode,
      controller: _otpVerificationBloc.txtCode,
      submittedPinTheme: pinPutDecoration,
      focusedPinTheme: pinPutDecoration.copyDecorationWith(
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: _appTheme.primaryColor,
        ),
      ),
      followingPinTheme: pinPutDecoration,
      pinAnimationType: PinAnimationType.scale,
    );
  }
}
