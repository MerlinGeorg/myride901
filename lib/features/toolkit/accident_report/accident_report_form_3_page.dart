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

class AccidentReportForm3Page extends StatefulWidget {
  const AccidentReportForm3Page({Key? key}) : super(key: key);

  @override
  _AccidentReportForm3PageState createState() =>
      _AccidentReportForm3PageState();
}

class _AccidentReportForm3PageState extends State<AccidentReportForm3Page> {
  final _accidentReportFormBloc = AccidentReportFormBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);

    _accidentReportFormBloc.fillPage3();
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
                  onPress: _accidentReportFormBloc.btnSaveDraft3,
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
                              currentStep: 3,
                              title: StringConstants.firstPartyDetail,
                              subTitle: "",
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            MyRideTextFormField(
                              textEditingController:
                                  _accidentReportFormBloc.txtMyName,
                              hintText: StringConstants.hint_my_name,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => focus.nextFocus(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyRideTextFormField(
                              textEditingController:
                                  _accidentReportFormBloc.txtMyAddress,
                              hintText: StringConstants.hint_my_address,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => focus.nextFocus(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyRideTextFormField(
                              maxText: 14,
                              textInputType: TextInputType.phone,
                              textEditingController:
                                  _accidentReportFormBloc.txtMyContactNumber,
                              hintText: StringConstants.hint_my_contact_number,
                              textInputAction: TextInputAction.next,
                              ifs: [
                                MaskTextInputFormatter(
                                    mask: '(###) ###-####',
                                    initialText: _accidentReportFormBloc
                                        .txtMyContactNumber.text)
                              ],
                              onEditingComplete: () => focus.nextFocus(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyRideTextFormField(
                              textInputType: TextInputType.text,
                              textEditingController:
                                  _accidentReportFormBloc.txtLicensePlateNum,
                              hintText:
                                  StringConstants.hint_my_license_plate_number,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => focus.nextFocus(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyRideTextFormField(
                              textInputType: TextInputType.text,
                              textEditingController:
                                  _accidentReportFormBloc.txtDriverLicenseNum,
                              hintText:
                                  StringConstants.hint_my_driver_license_number,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => focus.nextFocus(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyRideTextFormField(
                              maxLine: 3,
                              minLine: 2,
                              textInputType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              textEditingController: _accidentReportFormBloc
                                  .txtInsuranceCompanyNameAndPolicyNum,
                              hintText:
                                  StringConstants.hint_my_insurance_company,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyRideTextFormField(
                              maxLine: 2,
                              textEditingController: _accidentReportFormBloc
                                  .txtVehicleMakeModelYear,
                              hintText: StringConstants.hint_my_vehicle_make,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => focus.nextFocus(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyRideTextFormField(
                              maxLine: 3,
                              minLine: 2,
                              textInputType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              textEditingController:
                                  _accidentReportFormBloc.txtInjuriesDetail,
                              hintText:
                                  StringConstants.hint_detail_of_any_injuries,
                            ),
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
                                          .btnNextPage3(context);
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
