import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/my_ride_textform_field.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/drawer/contact_us/contact_us_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _contactUsBloc = ContactUsBloc();
  AppThemeState _appTheme = AppThemeState();
  String version = "";
  String OS = "";
  bool isSupport = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ItemArgument? _arguments =
          (ModalRoute.of(context)!.settings.arguments as ItemArgument?);
      if (_arguments != null && _arguments.data != null) {
        isSupport = true;
        setState(() {});
      }
    });
    getData();
  }

  void getData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version + '(' + packageInfo.buildNumber + ')';
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      OS = 'Android v$release';
    }

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      OS = '$systemName v$version';
    }
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
          stream: _contactUsBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: AppTheme.of(context).primaryColor,
                  leading: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(AssetImages.left_arrow),
                      )),
                  title: Text(
                    isSupport ? 'Contact Support' : 'Contact Us',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                body: BlocProvider<ContactUsBloc>(
                  bloc: _contactUsBloc,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Color.fromRGBO(155, 44, 59, 1),
                          Color.fromRGBO(155, 44, 59, 1),
                          Color.fromRGBO(155, 44, 59, 1),
                          AppTheme.of(context).primaryColor,
                        ],
                            begin: Alignment.bottomRight,
                            end: Alignment.centerLeft)),
                    height: double.infinity,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          child: Image.asset(
                            AssetImages.contact_us_bg,
                            height: 150,
                            fit: BoxFit.fitWidth,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                            top: 150,
                            right: 0,
                            left: 0,
                            bottom: 0,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20.0),
                                  topRight: const Radius.circular(20.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView(
                                      padding: const EdgeInsets.all(0),
                                      physics: ClampingScrollPhysics(),
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        MyRideTextFormField(
                                          textEditingController:
                                              _contactUsBloc.txtName,
                                          hintText: 'Name*',
                                          textInputAction: TextInputAction.next,
                                          onFieldSubmitted: (_) =>
                                              FocusScope.of(context)
                                                  .nextFocus(),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        MyRideTextFormField(
                                          textEditingController:
                                              _contactUsBloc.txtMail,
                                          hintText: 'Email*',
                                          textInputAction: TextInputAction.next,
                                          onFieldSubmitted: (_) =>
                                              FocusScope.of(context)
                                                  .nextFocus(),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        MyRideTextFormField(
                                          textEditingController:
                                              _contactUsBloc.txtSubject,
                                          hintText: 'Summary*',
                                          textInputAction: TextInputAction.done,
                                          onFieldSubmitted: (_) =>
                                              FocusScope.of(context).unfocus(),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        MessageTextFields(
                                          txtMessage: _contactUsBloc.txtMessage,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        EmailLabel(
                                          email: AppComponentBase.getInstance()
                                                  .getLoginData()
                                                  .user
                                                  ?.email ??
                                              '',
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  BlueButton(
                                    text: 'SEND MESSAGE',
                                    onPress: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      _contactUsBloc.btnAddClicked(
                                          context: context);
                                    },
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}

class MessageTextFields extends StatelessWidget {
  final TextEditingController? txtMessage;
  MessageTextFields({Key? key, this.txtMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      controller: txtMessage,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromRGBO(208, 208, 208, 1), width: 1.0),
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
          borderSide:
              BorderSide(color: Color(0xff121212).withOpacity(0.2), width: 0.0),
        ),
        hintText: null,
        alignLabelWithHint: true,
        labelText: 'Message',
        labelStyle: GoogleFonts.roboto(
            color: Color(0xff121212).withOpacity(0.7),
            fontWeight: FontWeight.w400,
            fontSize: 15),
        hintStyle: GoogleFonts.roboto(
            color: Color(0xff121212).withOpacity(0.5),
            fontWeight: FontWeight.w400,
            fontSize: 12),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: AppTheme.of(context).primaryColor, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      ),
      autofocus: false,
    );
  }
}

class EmailLabel extends StatelessWidget {
  final String email;

  EmailLabel({Key? key, this.email = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          AssetImages.mail_2_bg,
          width: 25,
          height: 25,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          'User ID: $email',
          style: GoogleFonts.roboto(
              fontSize: 13, color: AppTheme.of(context).primaryColor),
        )
      ],
    );
  }
}
