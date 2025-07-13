import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/auth/widget/autho_textformfield.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/drawer/setting/change_password/change_password_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _changePasswordBloc = ChangePasswordBloc();
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    // TODO: implement initState
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
          stream: _changePasswordBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: _appTheme.primaryColor,
                leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AssetImages.left_arrow),
                    )),
                title: Text(
                  StringConstants.app_change_password,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              body: BlocProvider<ChangePasswordBloc>(
                  bloc: _changePasswordBloc,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          children: [
                            AuthoTextFormField(
                                textEditingController:
                                    _changePasswordBloc.txtCurrentPassword,
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                hintText: StringConstants.hint_old_password,
                                isVisibleToggle: true,
                                prefixIcon: AssetImages.lock),
                            SizedBox(
                              height: 20,
                            ),
                            AuthoTextFormField(
                              prefixIcon: AssetImages.lock,
                              textEditingController:
                                  _changePasswordBloc.txtNewPassword,
                              textInputAction: TextInputAction.next,
                              obscureText: true,
                              hintText: StringConstants.hint_new_password,
                              isVisibleToggle: true,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            AuthoTextFormField(
                              textEditingController:
                                  _changePasswordBloc.txtConfirmPassword,
                              obscureText: true,
                              prefixIcon: AssetImages.lock,
                              textInputAction: TextInputAction.done,
                              hintText:
                                  StringConstants.hint_confirm_new_password,
                              isVisibleToggle: true,
                            ),
                            Text(
                              StringConstants.label_pass_valid,
                              style: GoogleFonts.roboto(
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                  fontSize: 10),
                            ),
                          ],
                        ),
                        Spacer(),
                        BlueButton(
                          text: StringConstants.update_password.toUpperCase(),
                          onPress: () {
                            _changePasswordBloc.btnSaveClicked(
                                context: context);
                          },
                        )
                      ],
                    ),
                  )),
            );
          }),
    );
  }
}
