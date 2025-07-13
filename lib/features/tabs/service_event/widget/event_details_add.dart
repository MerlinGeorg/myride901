import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/tabs/service_event/add_service_event/add_service_event_bloc.dart';
import 'package:myride901/widgets/my_ride_textform_field.dart';

class EventDetailAdd extends StatefulWidget {
  final TextEditingController? textEditingControllerDate;
  final TextEditingController? textEditingControllerName;
  final TextEditingController? textEditingControllerMile;
  final FocusScopeNode? focus;
  final AddServiceEventBloc? addServiceEventBloc;
  final bool value;
  final bool? isAdd;

  const EventDetailAdd({
    Key? key,
    this.textEditingControllerDate,
    this.textEditingControllerName,
    this.textEditingControllerMile,
    this.focus,
    this.isAdd,
    this.addServiceEventBloc,
    this.value = false,
  }) : super(key: key);

  @override
  _EventDetailAddState createState() => _EventDetailAddState();
}

class _EventDetailAddState extends State<EventDetailAdd> {
  AppThemeState _appTheme = AppThemeState();
  bool updateMileage = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SvgPicture.asset(AssetImages.ellipse_red),
              SizedBox(width: 15),
              Text(
                StringConstants.event_details,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.5,
                    color: AppTheme.of(context).primaryColor),
              )
            ],
          ),
          SizedBox(height: 20),
          MyRideTextFormField(
            textEditingController: widget.textEditingControllerName,
            hintText: 'Event name*',
            readOnly: widget.value,
            maxText: 256,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => widget.focus?.unfocus(),
          ),
          SizedBox(height: 20),
          MyRideTextFormField(
            textEditingController: widget.textEditingControllerDate,
            hintText: 'Event date*',
            textInputAction: TextInputAction.next,
            readOnly: widget.value,
            suffixIcon: AssetImages.calendar_1,
            hasSuffixIcon: true,
            onClick: () async {
              if (!widget.value) {
                var date = await showDatePicker(
                  context: context,
                  initialDatePickerMode: DatePickerMode.day,
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: _appTheme.primaryColor,
                          onPrimary: Colors.white,
                          surface: _appTheme.whiteColor,
                          onSurface: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                  initialDate: widget.textEditingControllerDate?.text == ''
                      ? DateTime.now()
                      : DateFormat(AppComponentBase.getInstance()
                              .getLoginData()
                              .user
                              ?.date_format)
                          .parse(widget.textEditingControllerDate?.text ?? ''),
                  firstDate: DateTime(1901),
                  lastDate: DateTime(2025, 12, 31),
                );
                if (date != null) {
                  widget.textEditingControllerDate?.text = DateFormat(
                          AppComponentBase.getInstance()
                              .getLoginData()
                              .user
                              ?.date_format)
                      .format(date);
                  widget.focus?.nextFocus();
                }
              }
            },
          ),
          SizedBox(height: 20),
          MyRideTextFormField(
            hintText: 'Mileage*',
            textInputAction: TextInputAction.done,
            readOnly: widget.value,
            textInputType: TextInputType.number,
            onEditingComplete: () => widget.focus?.unfocus(),
            textEditingController: widget.textEditingControllerMile,
            ifs: [
              CustomTextInputFormatter(),
            ],
          ),
          if (widget.isAdd == true) SizedBox(height: 10),
          if (widget.isAdd == true)
            CheckboxListTile(
              fillColor: WidgetStateProperty.all(
                _appTheme.whiteColor,
              ),
              overlayColor: WidgetStateProperty.all(
                _appTheme.whiteColor,
              ),
              checkColor: _appTheme.primaryColor,
              side: WidgetStateBorderSide.resolveWith(
                (Set<WidgetState> states) => BorderSide(
                  color: _appTheme.primaryColor,
                  width: 2,
                ),
              ),
              title: Text(
                'Update vehicle mileage',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              value: updateMileage,
              onChanged: (bool? newValue) {
                setState(() {
                  updateMileage = newValue ?? false;
                  widget.addServiceEventBloc?.boxValue = updateMileage;
                  print('Nikitos');
                  print(widget.addServiceEventBloc?.boxValue);
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }
}
