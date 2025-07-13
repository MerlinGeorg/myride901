import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_home/accident_report_home_bloc.dart';
import 'package:myride901/features/toolkit/accident_report/widget/home_button.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/core/services/analytic_services.dart';

class AccidentReportHomePage extends StatefulWidget {
  const AccidentReportHomePage({Key? key}) : super(key: key);

  @override
  _AccidentReportHomePageState createState() => _AccidentReportHomePageState();
}

class _AccidentReportHomePageState extends State<AccidentReportHomePage> {
  final _accidentReportHomeBloc = AccidentReportHomeBloc();

  @override
  void initState() {
    locator<AnalyticsService>().logScreens(name: "Accident Reporting Page");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        initialData: null,
        stream: _accidentReportHomeBloc.mainStream,
        builder: (context, snapshot) {
          return Scaffold(
              resizeToAvoidBottomInset: true,
              body: BlocProvider<AccidentReportHomeBloc>(
                bloc: _accidentReportHomeBloc,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: 60),
                      Text(
                        'Report an Accident',
                        style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.of(context).blackColor),
                      ),
                      SizedBox(height: 20),
                      Image.asset(
                        AssetImages.accidentReportImage,
                        height: 250,
                        fit: BoxFit.fill,
                        width: 300,
                      ),
                      SizedBox(height: 30),
                      Container(
                        margin: new EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StringConstants.accidentSubtitle,
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
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringConstants.admit_liability,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.of(context).primaryColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              HomeButton(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Spacer(),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: BlueButton(
                                  text: StringConstants.label_continue
                                      .toUpperCase(),
                                  onPress: () async {
                                    Navigator.pushNamed(
                                        context, RouteName.accidentReportForm1);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ));
        });
  }
}
