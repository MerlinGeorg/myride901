import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/my_ride_dialog.dart';
import 'package:myride901/features/auth/create_new_password/create_new_password_bloc.dart';
import 'package:myride901/features/auth/widget/authentication_bg.dart';
import 'package:myride901/features/auth/widget/autho_textformfield.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';

class CreateNewPasswordPage extends StatefulWidget {
  @override
  _CreateNewPasswordPageState createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  final _createNewPasswordBloc = CreateNewPasswordBloc();
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    super.initState();
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
          stream: _createNewPasswordBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: BlocProvider<CreateNewPasswordBloc>(
                  bloc: _createNewPasswordBloc,
                  child: AuthenticationBG(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30, bottom: 30, left: 20, right: 20),
                      child: ListView(
                        physics: ClampingScrollPhysics(),
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
                          SvgPicture.asset(AssetImages.pass_lock),
                          SizedBox(
                            height: 25,
                          ),
                          Center(
                            child: Text(
                              StringConstants.create_new_password,
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
                            StringConstants.create_new_password_sub_text,
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
                              isVisibleToggle: true,
                              obscureText: true,
                              hintText: StringConstants.new_password,
                              prefixIcon: AssetImages.lock,
                              textInputAction: TextInputAction.next,
                              textEditingController: TextEditingController()),
                          SizedBox(
                            height: 25,
                          ),
                          AuthoTextFormField(
                              isVisibleToggle: true,
                              obscureText: true,
                              hintText: StringConstants.confirm_password,
                              prefixIcon: AssetImages.lock,
                              textInputAction: TextInputAction.done,
                              textEditingController: TextEditingController()),
                          SizedBox(
                            height: 25,
                          ),
                          BlueButton(
                            onPress: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return CustomDialogBox.created(
                                      onPress: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            RouteName.login,
                                            ModalRoute.withName('/'));
                                      },
                                    );
                                  });
                            },
                            text: StringConstants.create,
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          }),
    );
  }
}
