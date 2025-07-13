import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/my_ride_textform_field.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_form_bloc.dart';
import 'package:myride901/features/toolkit/accident_report/widget/accident_report_app.dart';
import 'package:myride901/features/toolkit/accident_report/widget/accident_report_header.dart';
import 'package:myride901/features/toolkit/accident_report/widget/prevous_button.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AccidentReportForm6Page extends StatefulWidget {
  const AccidentReportForm6Page({Key? key}) : super(key: key);

  @override
  _AccidentReportForm6PageState createState() =>
      _AccidentReportForm6PageState();
}

class _AccidentReportForm6PageState extends State<AccidentReportForm6Page> {
  final _accidentReportFormBloc = AccidentReportFormBloc();
  bool enableWitnessAddBtn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    _accidentReportFormBloc.fillPage6();
    return StreamBuilder<bool>(
        initialData: null,
        stream: _accidentReportFormBloc.mainStream,
        builder: (context, snapshot) {
          return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AccidentReportAppBar(
                onPress: _accidentReportFormBloc.btnSaveDraft6,
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
                              currentStep: 6,
                              title: StringConstants.witnesses,
                              subTitle: "",
                            ),
                            SizedBox(height: 20),
                            witnessView(
                              '${StringConstants.witnesses} 1',
                              focus,
                              _accidentReportFormBloc.txtWitnessName1,
                              _accidentReportFormBloc.txtWitnessContact1,
                              _accidentReportFormBloc.txtWitnessAddress1,
                              _accidentReportFormBloc
                                  .txtWitnessLicensePlateNumber1,
                            ),
                            witnessView(
                                '${StringConstants.witnesses} 2',
                                focus,
                                _accidentReportFormBloc.txtWitnessName2,
                                _accidentReportFormBloc.txtWitnessContact2,
                                _accidentReportFormBloc.txtWitnessAddress2,
                                _accidentReportFormBloc
                                    .txtWitnessLicensePlateNumber2),
                            witnessView(
                                '${StringConstants.witnesses} 3',
                                focus,
                                _accidentReportFormBloc.txtWitnessName3,
                                _accidentReportFormBloc.txtWitnessContact3,
                                _accidentReportFormBloc.txtWitnessAddress3,
                                _accidentReportFormBloc
                                    .txtWitnessLicensePlateNumber3),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              PreviousButton(
                                  onTap: () => Navigator.pop(context)),
                              Spacer(),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: BlueButton(
                                  text: StringConstants.next.toUpperCase(),
                                  onPress: () {
                                    _accidentReportFormBloc
                                        .btnNextPage6(context);
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
        });
  }

  witnessView(
    String title,
    FocusScopeNode focus,
    TextEditingController name,
    TextEditingController contact,
    TextEditingController address,
    TextEditingController licensePlate,
  ) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.of(context).primaryColor),
        ),
        SizedBox(height: 10),
        MyRideTextFormField(
          textEditingController: name,
          hintText: StringConstants.hint_name,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => focus.nextFocus(),
        ),
        SizedBox(height: 10),
        MyRideTextFormField(
          textInputType: TextInputType.phone,
          textEditingController: contact,
          hintText: StringConstants.hint_contact_number,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => focus.nextFocus(),
          maxText: 14,
          ifs: [
            MaskTextInputFormatter(
                mask: '(###) ###-####', initialText: contact.text)
          ],
        ),
        SizedBox(height: 10),
        MyRideTextFormField(
          textEditingController: address,
          hintText: StringConstants.hint_address,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => focus.nextFocus(),
        ),
        SizedBox(height: 10),
        MyRideTextFormField(
          textEditingController: licensePlate,
          hintText: StringConstants.hint_license_plate_number,
          textInputAction: TextInputAction.done,
          onEditingComplete: () => focus.unfocus(),
        ),
        SizedBox(height: 10),
        Divider(
          thickness: 2,
          color: AppTheme.of(context).primaryColor,
        ),
        SizedBox(height: 30),
      ],
    );
  }
}

class AddWitnessList extends StatelessWidget {
  final String? witnessName;
  final String? witnessPhone;
  final String? witnessAdress;
  final String? witnessLicencePlate;
  final Function? onActionPress;

  const AddWitnessList(
      {Key? key,
      this.onActionPress,
      this.witnessName,
      this.witnessPhone,
      this.witnessAdress,
      this.witnessLicencePlate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onActionPress!('main');
      },
      child: Container(
        height: 50,
        color: AppTheme.of(context).primaryColor.withOpacity(0.8),
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Text(
              '${StringConstants.witnesses} 1',
              style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.of(context).primaryColor),
            ),
            SizedBox(height: 10),
            MyRideTextFormField(
              hintText: StringConstants.hint_name,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10),
            MyRideTextFormField(
              textInputType: TextInputType.phone,
              hintText: StringConstants.hint_contact_number,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10),
            MyRideTextFormField(
              hintText: StringConstants.hint_address,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10),
            MyRideTextFormField(
              hintText: StringConstants.hint_license_plate_number,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 10),
            Divider(
              thickness: 2,
              color: AppTheme.of(context).primaryColor,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

@JsonSerializable()
class AddWitnessListModel {
  @JsonKey(name: "accident_id")
  String? accidentId;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "contact_no")
  String? contactNo;
  @JsonKey(name: "address")
  String? address;
  @JsonKey(name: "license_plate_no")
  String? licensePlateNo;
  @JsonKey(name: "id")
  String? id;

  AddWitnessListModel({
    this.id,
    this.accidentId,
    this.name,
    this.contactNo,
    this.address,
    this.licensePlateNo,
  });

  factory AddWitnessListModel.fromJson(Map<String, dynamic> jsonData) {
    return AddWitnessListModel(
        id: jsonData['id'],
        accidentId: jsonData['accident_id'],
        name: jsonData['name'],
        contactNo: jsonData['contact_no'],
        address: jsonData['address'],
        licensePlateNo: jsonData['license_plate_no']);
  }

  static Map<String, dynamic> toMap(AddWitnessListModel addWitnessListModel) =>
      {
        'id': addWitnessListModel.id,
        'accident_id': addWitnessListModel.accidentId,
        'address': addWitnessListModel.address,
        'contact_no': addWitnessListModel.contactNo,
        'name': addWitnessListModel.name,
        'license_plate_no': addWitnessListModel.licensePlateNo,
      };

  static String encode(List<AddWitnessListModel> addWitnessListModels) =>
      json.encode(
        addWitnessListModels
            .map<Map<String, dynamic>>((addWitnessListModel) =>
                AddWitnessListModel.toMap(addWitnessListModel))
            .toList(),
      );

  static List<AddWitnessListModel> decode(String musics) => (json.decode(musics)
          as List<dynamic>)
      .map<AddWitnessListModel>((item) => AddWitnessListModel.fromJson(item))
      .toList();

// factory Attachments.fromJson(Map<String, dynamic> json) =>
//     _$AttachmentsFromJson(json);
//
// Map<String, dynamic> toJson() => _$AttachmentsToJson(this);
}
