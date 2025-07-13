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
import 'package:myride901/features/toolkit/accident_report/accident_report_form_bloc.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccidentReportFormClosingPage extends StatefulWidget {
  const AccidentReportFormClosingPage({Key? key}) : super(key: key);

  @override
  _AccidentReportFormClosingPage createState() =>
      _AccidentReportFormClosingPage();
}

class _AccidentReportFormClosingPage
    extends State<AccidentReportFormClosingPage> {
  final _accidentReportFormBloc = AccidentReportFormBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _accidentReportFormBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
                resizeToAvoidBottomInset: true,
                body: BlocProvider<AccidentReportFormBloc>(
                  bloc: _accidentReportFormBloc,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Text(
                          'Share Auto Accident Form',
                          style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.of(context).blackColor),
                        ),
                        Image.asset(
                          AssetImages.accidentReportCloseImage,
                          height: 250,
                          fit: BoxFit.fill,
                          width: 300,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          margin: new EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StringConstants.accidentCloseSubTitle,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.of(context).lightGrey),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: BlueButton(
                            hasIcon: true,
                            icon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                AssetImages.share_1,
                                height: 20,
                                width: 20,
                                color: Colors.white,
                              ),
                            ),
                            text: StringConstants.share.toUpperCase(),
                            onPress: () async {
                              // SharedPreferences prefs = await SharedPreferences.getInstance();
                              // prefs.clear();
                              // _accidentReportFormBloc.openSheet(context, (){
                              // });
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              print("${prefs.getString("vehicle_id")}");
                              print("${prefs.getString("accident_id")}");
                              print(
                                  "------------${prefs.getString("accident_id")}");
                              Navigator.pushNamed(
                                  context, RouteName.shareReportUserSelection,
                                  arguments: ItemArgument(data: {
                                    'isGuest': 1,
                                  }));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}
