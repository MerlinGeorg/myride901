import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/my_ride_textform_field.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_form_bloc.dart';
import 'package:myride901/features/toolkit/accident_report/widget/accident_report_app.dart';
import 'package:myride901/features/toolkit/accident_report/widget/accident_report_header.dart';
import 'package:myride901/features/toolkit/accident_report/widget/prevous_button.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';

class AccidentReportForm2Page extends StatefulWidget {
  const AccidentReportForm2Page({Key? key}) : super(key: key);

  @override
  _AccidentReportForm2PageState createState() =>
      _AccidentReportForm2PageState();
}

class _AccidentReportForm2PageState extends State<AccidentReportForm2Page> {
  final _accidentReportFormBloc = AccidentReportFormBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _accidentReportFormBloc.fillPage2();
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
                appBar: AccidentReportAppBar(
                  onPress: _accidentReportFormBloc.btnSaveDraft2,
                ),
                body: BlocProvider<AccidentReportFormBloc>(
                  bloc: _accidentReportFormBloc,
                  child: ColoredBox(
                    color: Color(0xffF9FBFF),
                    child: Column(
                      children: [
                        Expanded(
                            child: ListView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          children: [
                            AccidentReportHeader(
                              currentStep: 2,
                              title: StringConstants.vehicle_damage_report,
                              subTitle: "",
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${StringConstants.description_of_your_vehicle_damage}',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.of(context).primaryColor),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            MyRideTextFormField(
                              textInputType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLine: 12,
                              maxText: 1000,
                              minLine: 6,
                              textEditingController:
                                  _accidentReportFormBloc.txtYourVehicleDamage,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${StringConstants.description_of_other_vehicle_damage}',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.of(context).primaryColor),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            MyRideTextFormField(
                              textInputType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLine: 12,
                              maxText: 1000,
                              minLine: 6,
                              textEditingController:
                                  _accidentReportFormBloc.txtOtherVehicleDamage,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${StringConstants.description_of_accident_happen}',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.of(context).primaryColor),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            MyRideTextFormField(
                              textInputType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLine: 12,
                              maxText: 1000,
                              minLine: 6,
                              textEditingController:
                                  _accidentReportFormBloc.txtAccidentHappen,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                PreviousButton(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Spacer(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: BlueButton(
                                    text: StringConstants.next.toUpperCase(),
                                    onPress: () {
                                      _accidentReportFormBloc
                                          .btnNextPage2(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}
