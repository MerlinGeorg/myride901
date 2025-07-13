import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/user_picture.dart';
import 'package:myride901/features/auth/widget/autho_textformfield.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/drawer/setting/edit_profile/edit_profile_bloc.dart';
import 'package:myride901/core/services/analytic_services.dart';
import 'package:myride901/constants/routes.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _editProfileBloc = EditProfileBloc();
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    // TODO: implement initState
    locator<AnalyticsService>().logScreens(name: "Edit Profile Page");
    super.initState();
    _editProfileBloc.user = AppComponentBase.getInstance().getLoginData().user;
    _editProfileBloc.txtEmail.text = _editProfileBloc.user?.email ?? '';
    _editProfileBloc.txtFirstname.text = _editProfileBloc.user?.firstName ?? '';
    _editProfileBloc.txtLastname.text = _editProfileBloc.user?.lastName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, RouteName.dashboard);
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: StreamBuilder<bool>(
          initialData: null,
          stream: _editProfileBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              backgroundColor: _appTheme.primaryColor,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: _appTheme.primaryColor,
                leading: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.dashboard);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AssetImages.left_arrow),
                    )),
                title: Text(
                  StringConstants.app_edit_profile,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              body: BlocProvider<EditProfileBloc>(
                bloc: _editProfileBloc,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 135,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                  height: 90,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(-0.5, -1),
                                      end: Alignment(-0.3, 2.3),
                                      tileMode: TileMode.clamp,
                                      colors: [
                                        _appTheme.primaryColor,
                                        _appTheme.primaryColor,
                                        Color(0xffD03737)
                                      ],
                                    ),
                                  ),
                                  child: Text('')),
                            ),
                            Positioned(
                              top: 40,
                              left: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  Utils.btnSelectImageClicked(
                                    context: context,
                                    getFile: (file) {
                                      if (file != null) {
                                        setState(() {
                                          _editProfileBloc.file = file;
                                          print(_editProfileBloc.file);
                                        });
                                      }
                                    },
                                  );
                                },
                                child: Container(
                                  height: 95,
                                  width: 95,
                                  child: Center(
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          child: UserPictureAsset(
                                            userPicture:
                                                _editProfileBloc.file == null
                                                    ? (_editProfileBloc.user
                                                            ?.displayImage ??
                                                        '')
                                                    : _editProfileBloc.file,
                                            size: Size(93, 93),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: SvgPicture.asset(
                                            AssetImages.camera_icon,
                                            width: 25,
                                            height: 25,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            SizedBox(height: 50),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                StringConstants.firstName,
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff121212).withOpacity(0.6)),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: AuthoTextFormField(
                                hintText: StringConstants.firstName,
                                textInputAction: TextInputAction.next,
                                textEditingController:
                                    _editProfileBloc.txtFirstname,
                                prefixIcon: AssetImages.user,
                                isPrefixIcon: false,
                              ),
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                StringConstants.lastName,
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff121212).withOpacity(0.6)),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: AuthoTextFormField(
                                textEditingController:
                                    _editProfileBloc.txtLastname,
                                textInputAction: TextInputAction.next,
                                prefixIcon: AssetImages.user,
                                isPrefixIcon: false,
                                hintText: StringConstants.lastName,
                              ),
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                StringConstants.email,
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff121212).withOpacity(0.6)),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: AuthoTextFormField(
                                textEditingController:
                                    _editProfileBloc.txtEmail,
                                hintText: StringConstants.email,
                                isPrefixIcon: false,
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: BlueButton(
                          text: StringConstants.update.toUpperCase(),
                          onPress: () {
                            _editProfileBloc.btnSaveClicked(context: context);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 15),
                        child: ElevatedButton(
                          child: Text(
                              StringConstants.delete_account.toUpperCase()),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size.fromHeight(40)),
                          onPressed: () {
                            Utils.showAlertDialogCallBack1(
                              context: context,
                              title: StringConstants.delete_account_popup_title,
                              message:
                                  StringConstants.delete_account_popup_message,
                              isConfirmationDialog: false,
                              isOnlyOK: false,
                              navBtnName: StringConstants.cancel,
                              posBtnName: StringConstants.delete.toUpperCase(),
                              onNavClick: () => {},
                              onPosClick: () {
                                _editProfileBloc.btnDeleteAccount(
                                    context: context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
