import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/my_ride_textform_field.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_form_bloc.dart';
import 'package:myride901/features/toolkit/accident_report/widget/accident_report_app.dart';
import 'package:myride901/features/toolkit/accident_report/widget/accident_report_header.dart';
import 'package:myride901/features/toolkit/accident_report/widget/prevous_button.dart';
import 'package:myride901/features/tabs/service_event/widget/header.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _formKey = new GlobalKey<FormState>();

class AccidentReportForm1Page extends StatefulWidget {
  const AccidentReportForm1Page({Key? key}) : super(key: key);

  @override
  _AccidentReportForm1PageState createState() =>
      _AccidentReportForm1PageState();
}

class _AccidentReportForm1PageState extends State<AccidentReportForm1Page> {
  final _accidentReportFormBloc = AccidentReportFormBloc();

  VehicleProfile _selectedItem = VehicleProfile.getInstance();

  List<DropdownMenuItem<VehicleProfile>> _dropdownList = [];

  bool initial = false;

  List<DropdownMenuItem<VehicleProfile>> _buildFavouriteFoodModelDropdown(
      List itemList) {
    List<DropdownMenuItem<VehicleProfile>> items = [];
    if (!initial) {
      if (itemList.isNotEmpty) {
        _selectedItem = itemList[0];
        initial = true;
      }
    }
    for (VehicleProfile item in itemList) {
      items.add(DropdownMenuItem(
          value: item,
          child: Text(item.Nickname ?? "",
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff121212)))));
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    _accidentReportFormBloc.getVehicleList(
        context: context, isProgressBar: true);
    _accidentReportFormBloc.fillPage1();
  }

  _onChangeItem(VehicleProfile? value) async {
    //  widget.onVehicleSelect.call(value);
    setState(() {
      _selectedItem = value!;
      _accidentReportFormBloc.vehicleProfile = value;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        "vehicle_id", _accidentReportFormBloc.vehicleProfile!.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);

    return StreamBuilder<bool>(
        initialData: null,
        stream: _accidentReportFormBloc.mainStream,
        builder: (context, snapshot) {
          _dropdownList = _buildFavouriteFoodModelDropdown(
              _accidentReportFormBloc.arrVehicle);

          return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AccidentReportAppBar(
                onPress: _accidentReportFormBloc.btnSaveDraft1,
              ),
              body: BlocProvider<AccidentReportFormBloc>(
                bloc: _accidentReportFormBloc,
                child: ColoredBox(
                  color: Color(0xffF9FBFF),
                  child: Column(
                    children: [
                      Expanded(child: _form(focus)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              PreviousButton(
                                onTap: () => Navigator.pop(context),
                              ),
                              Spacer(),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: BlueButton(
                                  text: StringConstants.next.toUpperCase(),
                                  onPress: () {
                                    _accidentReportFormBloc
                                        .btnNextPage1(context);
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

  _form(FocusScopeNode focus) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      children: [
        AccidentReportHeader(
          currentStep: 1,
          title: StringConstants.accidentDetail,
          subTitle: "",
        ),
        SizedBox(height: 20),
        Header(
          textEditingController: TextEditingController(),
          onVehicleSelect: (value) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            setState(() {
              _accidentReportFormBloc.selectedVehicle = value;
              _accidentReportFormBloc.vehicleProfile =
                  _accidentReportFormBloc.arrVehicle[value];
              _selectedItem = _accidentReportFormBloc.arrVehicle[value];
              prefs.setString("vehicle_id", _selectedItem.id.toString());
            });
          },
          vehicleList: _accidentReportFormBloc.arrVehicle,
          selectedVehicle: _accidentReportFormBloc.selectedVehicle,
        ),
        SizedBox(height: 10),
        MyRideTextFormField(
          isSVG: true,
          hasSuffixIcon: true,
          textInputAction: TextInputAction.next,
          readOnly: true,
          textEditingController: _accidentReportFormBloc.txtTime,
          textColor: Colors.black,
          onClick: () async {
            final selectedTime =
                await _accidentReportFormBloc.openTime(context: context);
            if (selectedTime != null && mounted) {
              setState(() {
                _accidentReportFormBloc.txtTime.text = selectedTime;
              });
            }
          },
          suffixIcon: SvgPicture.asset(AssetImages.time),
          hintText: StringConstants.hint_time_of_accident,
        ),
        SizedBox(height: 10),
        MyRideTextFormField(
          textInputAction: TextInputAction.next,
          isSVG: true,
          hasSuffixIcon: true,
          readOnly: true,
          textEditingController: _accidentReportFormBloc.txtData,
          textColor: Colors.black,
          onClick: () {
            _accidentReportFormBloc.btnDateClicked(context: context);
          },
          suffixIcon: SvgPicture.asset(AssetImages.calendar1),
          hintText: StringConstants.hint_date_of_accident,
        ),
        SizedBox(height: 10),
        MyRideTextFormField(
          textEditingController: _accidentReportFormBloc.txtStreet,
          hintText: StringConstants.hint_street,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => focus.nextFocus(),
        ),
        SizedBox(height: 10),
        MyRideTextFormField(
          textEditingController: _accidentReportFormBloc.txtCity,
          hintText: StringConstants.hint_city,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => focus.nextFocus(),
        ),
        SizedBox(height: 10),
        MyRideTextFormField(
          textEditingController: _accidentReportFormBloc.txtProvince,
          hintText: StringConstants.hint_province,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => focus.nextFocus(),
        ),
        SizedBox(height: 20),
        Text(
          StringConstants.label_my_speed_at_time,
          style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.of(context).primaryColor),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            SizedBox(
              height: 30,
              width: 25,
              child: Radio(
                value: 1,
                groupValue: _accidentReportFormBloc.mySpeedRadioGroup,
                onChanged: (value) {
                  setState(() {
                    _accidentReportFormBloc.mySpeedRadioGroup = value as int;
                  });
                },
                activeColor: AppTheme.of(context).primaryColor,
              ),
            ),
            Text(
              StringConstants.kph,
              style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.of(context).primaryColor),
            ),
            SizedBox(width: 20),
            SizedBox(
              width: 30,
              height: 30,
              child: Radio(
                value: 2,
                groupValue: _accidentReportFormBloc.mySpeedRadioGroup,
                onChanged: (value) {
                  setState(() {
                    _accidentReportFormBloc.mySpeedRadioGroup = value as int;
                  });
                },
                activeColor: AppTheme.of(context).primaryColor,
              ),
            ),
            Text(
              StringConstants.mph,
              style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.of(context).primaryColor),
            ),
          ],
        ),
        SizedBox(height: 10),
        MyRideTextFormField(
          textEditingController: _accidentReportFormBloc.txtMySpeed,
          textInputType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => focus.nextFocus(),
        ),
        SizedBox(height: 20),
        Text(StringConstants.label_other_driver_speed,
            style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.of(context).primaryColor)),
        Row(
          children: [
            SizedBox(
              height: 30,
              width: 25,
              child: Radio(
                value: 1,
                groupValue: _accidentReportFormBloc.otherSpeedRadioGroup,
                onChanged: (value) {
                  setState(() {
                    _accidentReportFormBloc.otherSpeedRadioGroup = value as int;
                  });
                },
                activeColor: AppTheme.of(context).primaryColor,
              ),
            ),
            Text(StringConstants.kph,
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.of(context).primaryColor)),
            SizedBox(width: 20),
            SizedBox(
                width: 30,
                height: 30,
                child: Radio(
                  value: 2,
                  groupValue: _accidentReportFormBloc.otherSpeedRadioGroup,
                  onChanged: (value) {
                    setState(() {
                      _accidentReportFormBloc.otherSpeedRadioGroup =
                          value as int;
                    });
                  },
                  activeColor: AppTheme.of(context).primaryColor,
                )),
            Text(StringConstants.mph,
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.of(context).primaryColor)),
          ],
        ),
        SizedBox(height: 10),
        MyRideTextFormField(
          textEditingController: _accidentReportFormBloc.txtOtherDriverSpeed,
          textInputType: TextInputType.phone,
          onEditingComplete: () => focus.unfocus(),
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextInputAction textInputAction;
  final VoidCallback onEditingComplete;

  const CustomTextField({
    this.textInputAction = TextInputAction.done,
    this.onEditingComplete = _onEditingComplete,
  });

  static _onEditingComplete() {}

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
    );
  }
}
