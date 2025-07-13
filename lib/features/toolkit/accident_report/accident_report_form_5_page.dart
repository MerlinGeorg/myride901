import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/my_ride_textform_field.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_form_bloc.dart';
import 'package:myride901/features/toolkit/accident_report/widget/accident_report_app.dart';
import 'package:myride901/features/toolkit/accident_report/widget/accident_report_header.dart';
import 'package:myride901/features/toolkit/accident_report/widget/prevous_button.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';

class AccidentReportForm5Page extends StatefulWidget {
  const AccidentReportForm5Page({Key? key}) : super(key: key);

  @override
  _AccidentReportForm5PageState createState() =>
      _AccidentReportForm5PageState();
}

class _AccidentReportForm5PageState extends State<AccidentReportForm5Page> {
  final _accidentReportFormBloc = AccidentReportFormBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    _accidentReportFormBloc.fillPage5();
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
                  onPress: _accidentReportFormBloc.btnSaveDraft5,
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
                              currentStep: 5,
                              title: StringConstants.policeDetail,
                              subTitle: "",
                            ),
                            SizedBox(height: 20),
                            MyRideTextFormField(
                              textEditingController:
                                  _accidentReportFormBloc.txtName,
                              hintText: StringConstants.hint_name,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => focus.nextFocus(),
                            ),
                            SizedBox(height: 10),
                            MyRideTextFormField(
                              textInputType: TextInputType.phone,
                              textEditingController:
                                  _accidentReportFormBloc.txtBadgeNo,
                              hintText: StringConstants.hint_badge_num,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => focus.nextFocus(),
                            ),
                            SizedBox(height: 10),
                            MyRideTextFormField(
                              maxText: 14,
                              textInputType: TextInputType.phone,
                              textEditingController:
                                  _accidentReportFormBloc.txtPhone,
                              hintText: StringConstants.hint_phone,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => focus.nextFocus(),
                              ifs: [
                                MaskTextInputFormatter(
                                    mask: '(###) ###-####',
                                    initialText:
                                        _accidentReportFormBloc.txtPhone.text)
                              ],
                            ),
                            SizedBox(height: 10),
                            MyRideTextFormField(
                              textEditingController: _accidentReportFormBloc
                                  .txtLocalPoliceDepartment,
                              hintText:
                                  StringConstants.hint_local_police_department,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => focus.nextFocus(),
                            ),
                            SizedBox(height: 10),
                            MyRideTextFormField(
                              textInputType: TextInputType.phone,
                              textEditingController: _accidentReportFormBloc
                                  .txtIncidentReportNumber,
                              hintText:
                                  StringConstants.hint_incident_report_number,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => focus.nextFocus(),
                            ),
                            SizedBox(height: 10),
                            MyRideTextFormField(
                              textInputType: TextInputType.phone,
                              textEditingController:
                                  _accidentReportFormBloc.txtOccurrenceNumber,
                              hintText: StringConstants.hint_occurrence_number,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () => focus.unfocus(),
                            ),
                            SizedBox(height: 10),
                            SizedBox(height: 15),
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
                                          .btnNextPage5(context);
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
