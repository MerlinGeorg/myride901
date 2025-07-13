import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/drawer/support/support_bloc.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _supportBloc = SupportBloc();
  AppThemeState _appTheme = AppThemeState();
  bool? isReceiveImpEmail,
      isCarRecallNotification,
      isSpecialOfferEmail,
      isDueDateEmail;

  @override
  void initState() {
    isReceiveImpEmail = false;
    isCarRecallNotification = false;
    isSpecialOfferEmail = false;
    isDueDateEmail = false;
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
          stream: _supportBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
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
                    StringConstants.app_support,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                body: BlocProvider<SupportBloc>(
                  bloc: _supportBloc,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      AppTheme.of(context).primaryColor,
                      Color.fromRGBO(155, 44, 59, 1)
                    ], begin: Alignment.bottomRight, end: Alignment.center)),
                    height: double.infinity,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          child: Image.asset(
                            AssetImages.support_bg,
                            height: 180,
                            fit: BoxFit.fitWidth,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                            top: 170,
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
                              child: ListView(
                                padding: const EdgeInsets.all(0),
                                physics: ClampingScrollPhysics(),
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    StringConstants.support_sub_header,
                                    style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        color: _appTheme.lightGrey,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        AssetImages.faq,
                                        width: 15,
                                        height: 15,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        StringConstants.support_step_1,
                                        style: GoogleFonts.roboto(
                                            fontSize: 17,
                                            color: _appTheme.primaryColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    StringConstants.support_step_1_text,
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        color: _appTheme.lightGrey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  BlueButton(
                                    onPress: () {
                                      Navigator.pushNamed(
                                          context, RouteName.webViewDisplayPage,
                                          arguments: ItemArgument(data: {
                                            'url': StringConstants.linkFaq,
                                            'title': 'FAQ',
                                            'id': 5
                                          }));
                                    },
                                    text: StringConstants.read_faq,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  /*Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AssetImages.updates,
                                        width: 15,
                                        height: 15,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        StringConstants.support_step_2,
                                        style: GoogleFonts.roboto(
                                            fontSize: 17,
                                            color: _appTheme.primaryColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    StringConstants.support_step_2_text,
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        color: _appTheme.lightGrey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  BlueButton(
                                    text: 'Check For Updates'.toUpperCase(),
                                    onPress: () {},
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),*/
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AssetImages.support_ic,
                                          width: 15,
                                          height: 15,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          StringConstants.support_step_3,
                                          style: GoogleFonts.roboto(
                                              fontSize: 17,
                                              color: _appTheme.primaryColor,
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      StringConstants.support_step_3_text,
                                      style: GoogleFonts.roboto(
                                          fontSize: 15,
                                          color: _appTheme.lightGrey,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  BlueButton(
                                    text: 'Contact Support'.toUpperCase(),
                                    onPress: () {
                                      Navigator.of(context).pushNamed(
                                          RouteName.contactUs,
                                          arguments: ItemArgument(data: true));
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
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
