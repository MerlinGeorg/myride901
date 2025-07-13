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

class AccidentReportForm4Page extends StatefulWidget {
  const AccidentReportForm4Page({Key? key}) : super(key: key);

  @override
  _AccidentReportForm4PageState createState() =>
      _AccidentReportForm4PageState();
}

class _AccidentReportForm4PageState extends State<AccidentReportForm4Page> {
  final _accidentReportFormBloc = AccidentReportFormBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    _accidentReportFormBloc.fillPage4();
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
                  onPress: _accidentReportFormBloc.btnSaveDraft4,
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
                              currentStep: 4,
                              title: StringConstants.secondPartyDetail,
                              subTitle: "",
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            MyRideTextFormField(
                              textEditingController:
                                  _accidentReportFormBloc.txtOtherDriverName,
                              hintText: StringConstants.hint_other_driver_name,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => focus.nextFocus(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyRideTextFormField(
                              textEditingController:
                                  _accidentReportFormBloc.txtOtherDriverAddress,
                              hintText:
                                  StringConstants.hint_other_driver_address,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => focus.nextFocus(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyRideTextFormField(
                              maxText: 14,
                              textInputType: TextInputType.phone,
                              textEditingController: _accidentReportFormBloc
                                  .txtOtherDriverContactNumber,
                              hintText: StringConstants
                                  .hint_other_driver_contact_number,
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
                              textEditingController: _accidentReportFormBloc
                                  .txtOtherDriverLicensePlateNum,
                              hintText: StringConstants
                                  .hint_other_driver_license_plate_number,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => focus.nextFocus(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyRideTextFormField(
                              textInputType: TextInputType.text,
                              textEditingController: _accidentReportFormBloc
                                  .txtOtherDriversDriverLicenseNum,
                              hintText: StringConstants
                                  .hint_other_drivers_driver_license_number,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => focus.nextFocus(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyRideTextFormField(
                              maxLine: 2,
                              minLine: 2,
                              textInputType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              textEditingController: _accidentReportFormBloc
                                  .txtOtherDriverInsuranceCompanyNameAndPolicyNum,
                              hintText: StringConstants
                                  .hint_other_driver_insurance_company,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyRideTextFormField(
                              maxLine: 2,
                              minLine: 2,
                              textInputType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              textEditingController: _accidentReportFormBloc
                                  .txtOtherDriverVehicleMakeModelYear,
                              hintText: StringConstants
                                  .hint_other_driver_vehicle_make,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyRideTextFormField(
                              maxLine: 2,
                              minLine: 2,
                              textInputType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              textEditingController: _accidentReportFormBloc
                                  .txtNameAddressDriverVehicle,
                              hintText: StringConstants
                                  .hint_other_drive_name_detail_of_any_injuries,
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
                                          .btnNextPage4(context);
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
