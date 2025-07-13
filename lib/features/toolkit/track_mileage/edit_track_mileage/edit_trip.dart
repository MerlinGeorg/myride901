import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/typeahead_address_field.dart';
import 'package:myride901/widgets/user_picture.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/vehicle_text_field.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/toolkit/track_mileage/edit_track_mileage/edit_trip_bloc.dart';

class EditTripPage extends StatefulWidget {
  const EditTripPage({Key? key}) : super(key: key);

  @override
  _EditTripPageState createState() => _EditTripPageState();
}

class _EditTripPageState extends State<EditTripPage> {
  final _editTripBloc = EditTripBloc();
  AppThemeState _appTheme = AppThemeState();
  var _arguments;

  String? val;
  DateTime? startDate;
  DateTime? endDate;
  bool isProfilePictureVisible = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _arguments =
          (ModalRoute.of(context)?.settings.arguments as ItemArgument).data;
      if (_arguments['trip'] != null) {
        _editTripBloc.trip = _arguments['trip'];
      }
      if (_arguments['selectedVehicle'] != null) {
        _editTripBloc.selectedVehicle = _arguments['selectedVehicle'];
      }
      _editTripBloc.getTripById(context: context);
      val = _editTripBloc.category!.text;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _editTripBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: _appTheme.primaryColor,
                elevation: 0,
                title: Text(
                  StringConstants.edit_mileage_tracker,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Colors.white),
                ),
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(AssetImages.left_arrow),
                  ),
                ),
              ),
              body: BlocProvider<EditTripBloc>(
                bloc: _editTripBloc,
                child: (_editTripBloc.isLoaded)
                    ? Stack(
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          Visibility(
                                            visible: isProfilePictureVisible,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                UserPicture(
                                                  fontSize: 28,
                                                  size: Size(74, 74),
                                                  text:
                                                      _editTripBloc.name ?? '',
                                                  userPicture:
                                                      Utils.getProfileImage(
                                                          _editTripBloc
                                                              .vehicleProfile!),
                                                ),
                                                SizedBox(width: 25),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        StringConstants.vehicle,
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                          color: _appTheme
                                                              .primaryColor
                                                              .withOpacity(0.8),
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        _editTripBloc.name ??
                                                            '',
                                                        overflow: TextOverflow
                                                            .visible,
                                                        maxLines: 1000,
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18,
                                                          color: _appTheme
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10)
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 25),
                                    VehicleTextField(
                                      textEditingController:
                                          _editTripBloc.startDate,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      hintText: "Start Time",
                                      suffixIcon: AssetImages.calendar_1,
                                      hasSuffixIcon: true,
                                      labelText: 'Start Time',
                                      labelStyle: GoogleFonts.roboto(
                                        color:
                                            Color(0xff121212).withOpacity(0.7),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ),
                                      onTap: () async {
                                        var dateTime = await showDatePicker(
                                          context: context,
                                          initialDatePickerMode:
                                              DatePickerMode.day,
                                          initialEntryMode:
                                              DatePickerEntryMode.calendarOnly,
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                colorScheme:
                                                    ColorScheme.fromSeed(
                                                  seedColor:
                                                      _appTheme.primaryColor,
                                                  onPrimary: Colors.white,
                                                  surface: _appTheme.whiteColor,
                                                  onSurface: Colors.black,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                          initialDate: _editTripBloc
                                                  .startDate!.text.isEmpty
                                              ? DateTime.now()
                                              : DateFormat(AppComponentBase
                                                          .getInstance()
                                                      .getLoginData()
                                                      .user
                                                      ?.date_format)
                                                  .parse(_editTripBloc
                                                      .startDate!.text),
                                          firstDate: DateTime(1901),
                                          lastDate: DateTime(2025, 12, 31),
                                        );

                                        if (dateTime != null) {
                                          var time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );

                                          if (time != null) {
                                            dateTime = DateTime(
                                              dateTime.year,
                                              dateTime.month,
                                              dateTime.day,
                                              time.hour,
                                              time.minute,
                                            );

                                            _editTripBloc.startDate?.text =
                                                DateFormat((AppComponentBase
                                                                    .getInstance()
                                                                .getLoginData()
                                                                .user
                                                                ?.date_format ??
                                                            'yyyy-MM-dd') +
                                                        " HH:mm")
                                                    .format(dateTime);

                                            if (_editTripBloc.startDate!.text
                                                    .isNotEmpty &&
                                                _editTripBloc
                                                    .endDate!.text.isNotEmpty) {
                                              DateTime startDate = dateTime;
                                              DateTime endDate = _editTripBloc
                                                      .endDate!.text.isNotEmpty
                                                  ? DateFormat((AppComponentBase
                                                                      .getInstance()
                                                                  .getLoginData()
                                                                  .user
                                                                  ?.date_format ??
                                                              'yyyy-MM-dd') +
                                                          " HH:mm")
                                                      .parse(_editTripBloc
                                                          .endDate!.text)
                                                  : DateTime.now();

                                              Duration duration =
                                                  endDate.difference(startDate);

                                              int days = duration.inDays;
                                              int hours = duration.inHours
                                                  .remainder(24);
                                              int minutes = duration.inMinutes
                                                  .remainder(60);

                                              _editTripBloc.daysController
                                                  ?.text = days.toString();
                                              _editTripBloc.hoursController
                                                  ?.text = hours.toString();
                                              _editTripBloc.minutesController
                                                  ?.text = minutes.toString();
                                            }
                                          }
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      child: InputDecorator(
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _appTheme.primaryColor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  208, 208, 208, 1),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  208, 208, 208, 1),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 6.0,
                                            horizontal: 10.0,
                                          ),
                                          fillColor: Colors.white70,
                                        ),
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          hint: Text("Purpose"),
                                          value: _editTripBloc.category!.text,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              val = newValue!;
                                              _editTripBloc.category?.text =
                                                  newValue.toLowerCase();
                                            });
                                          },
                                          items: <String>[
                                            'personal',
                                            'business',
                                          ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(_editTripBloc
                                                    .capitalize(value)),
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TypeAheadAddressField(
                                      controller: _editTripBloc.startLocation,
                                      onSelected: (suggestion) {
                                        setState(() {
                                          _editTripBloc.startLocation?.text =
                                              suggestion;
                                          if (_editTripBloc.startLocation!.text
                                                  .isNotEmpty &&
                                              _editTripBloc.endLocation!.text
                                                  .isNotEmpty) {}
                                        });
                                      },
                                      suggestionsCallback: (pattern) async {
                                        if (pattern.length >= 3) {
                                          try {
                                            await _editTripBloc.getAutocomplete(
                                                context: context);
                                            return _editTripBloc.origin;
                                          } catch (error) {
                                            print(error);
                                            throw Exception(StringConstants
                                                .autocomplete_error);
                                          }
                                        } else {
                                          return [];
                                        }
                                      },
                                      hintText: 'Enter Origin',
                                      labelText: 'Origin',
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TypeAheadAddressField(
                                      controller: _editTripBloc.endLocation,
                                      onSelected: (suggestion) {
                                        setState(() {
                                          _editTripBloc.endLocation?.text =
                                              suggestion;
                                          if (_editTripBloc.startLocation!.text
                                                  .isNotEmpty &&
                                              _editTripBloc.endLocation!.text
                                                  .isNotEmpty) {}
                                        });
                                      },
                                      suggestionsCallback: (pattern) async {
                                        if (pattern.length >= 3) {
                                          try {
                                            await _editTripBloc
                                                .getAutocomplete2(
                                                    context: context);
                                            return _editTripBloc.destination;
                                          } catch (error) {
                                            print(error);
                                            throw Exception(StringConstants
                                                .autocomplete_error);
                                          }
                                        } else {
                                          return [];
                                        }
                                      },
                                      hintText: 'Enter Destination',
                                      labelText: 'Destination',
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    VehicleTextField(
                                      textEditingController:
                                          _editTripBloc.totalDistance,
                                      textInputAction: TextInputAction.next,
                                      textInputType: TextInputType.number,
                                      onChanged: (String newValue) {
                                        if (_editTripBloc
                                                .price!.text.isNotEmpty &&
                                            newValue.isNotEmpty) {
                                          double distance =
                                              double.tryParse(newValue) ?? 0.0;
                                          double rate = double.tryParse(
                                                  _editTripBloc.price!.text) ??
                                              0.0;
                                          double totalAmount = rate * distance;
                                          String formattedAmount =
                                              totalAmount.toStringAsFixed(2);

                                          _editTripBloc.earnings?.text =
                                              formattedAmount;
                                        }
                                      },
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      hintText: StringConstants.distance,
                                      labelText: StringConstants.distance,
                                      labelStyle: GoogleFonts.roboto(
                                          color: Color(0xff121212)
                                              .withOpacity(0.7),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15),
                                      suffixText:
                                          _editTripBloc.mileageUnit?.text ==
                                                  "mile"
                                              ? 'mi'
                                              : "km",
                                      suffixStyle: TextStyle(
                                          color: _appTheme.primaryColor),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: VehicleTextField(
                                            textEditingController:
                                                _editTripBloc.daysController,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType:
                                                TextInputType.numberWithOptions(
                                                    decimal: false),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onFieldSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .nextFocus(),
                                            hintText: "Days",
                                            labelText: "Days",
                                            labelStyle: GoogleFonts.roboto(
                                                color: Color(0xff121212)
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: VehicleTextField(
                                            textEditingController:
                                                _editTripBloc.hoursController,
                                            textInputType:
                                                TextInputType.numberWithOptions(
                                                    decimal: false),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .nextFocus(),
                                            hintText: "Hours",
                                            labelText: "Hours",
                                            labelStyle: GoogleFonts.roboto(
                                                color: Color(0xff121212)
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: VehicleTextField(
                                            textEditingController:
                                                _editTripBloc.minutesController,
                                            textInputType:
                                                TextInputType.numberWithOptions(
                                                    decimal: false),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .nextFocus(),
                                            hintText: "Minutes",
                                            labelText: "Minutes",
                                            labelStyle: GoogleFonts.roboto(
                                                color: Color(0xff121212)
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    VehicleTextField(
                                      textEditingController:
                                          _editTripBloc.endDate,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      hintText: "End Time",
                                      suffixIcon: AssetImages.calendar_1,
                                      hasSuffixIcon: true,
                                      labelText: 'End Time',
                                      labelStyle: GoogleFonts.roboto(
                                        color:
                                            Color(0xff121212).withOpacity(0.7),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ),
                                      onTap: () async {
                                        var dateTime = await showDatePicker(
                                          context: context,
                                          initialDatePickerMode:
                                              DatePickerMode.day,
                                          initialEntryMode:
                                              DatePickerEntryMode.calendarOnly,
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                colorScheme:
                                                    ColorScheme.fromSeed(
                                                  seedColor:
                                                      _appTheme.primaryColor,
                                                  onPrimary: Colors.white,
                                                  surface: _appTheme.whiteColor,
                                                  onSurface: Colors.black,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                          initialDate: _editTripBloc
                                                  .endDate!.text.isEmpty
                                              ? DateTime.now()
                                              : DateFormat(AppComponentBase
                                                          .getInstance()
                                                      .getLoginData()
                                                      .user
                                                      ?.date_format)
                                                  .parse(_editTripBloc
                                                      .endDate!.text),
                                          firstDate: DateTime(1901),
                                          lastDate: DateTime(2025, 12, 31),
                                        );

                                        if (dateTime != null) {
                                          var time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );

                                          if (time != null) {
                                            dateTime = DateTime(
                                              dateTime.year,
                                              dateTime.month,
                                              dateTime.day,
                                              time.hour,
                                              time.minute,
                                            );

                                            _editTripBloc.endDate?.text =
                                                DateFormat((AppComponentBase
                                                                    .getInstance()
                                                                .getLoginData()
                                                                .user
                                                                ?.date_format ??
                                                            'yyyy-MM-dd') +
                                                        " HH:mm")
                                                    .format(dateTime);

                                            if (_editTripBloc.startDate!.text
                                                    .isNotEmpty &&
                                                _editTripBloc
                                                    .endDate!.text.isNotEmpty) {
                                              DateTime startDate = _editTripBloc
                                                      .startDate!
                                                      .text
                                                      .isNotEmpty
                                                  ? DateFormat((AppComponentBase
                                                                      .getInstance()
                                                                  .getLoginData()
                                                                  .user
                                                                  ?.date_format ??
                                                              'yyyy-MM-dd') +
                                                          " HH:mm")
                                                      .parse(_editTripBloc
                                                          .startDate!.text)
                                                  : DateTime.now();
                                              endDate = dateTime;
                                              if (endDate != null) {
                                                Duration duration = endDate!
                                                    .difference(startDate);

                                                int days = duration.inDays;
                                                int hours = duration.inHours
                                                    .remainder(24);
                                                int minutes = duration.inMinutes
                                                    .remainder(60);

                                                _editTripBloc.daysController
                                                    ?.text = days.toString();
                                                _editTripBloc.hoursController
                                                    ?.text = hours.toString();
                                                _editTripBloc.minutesController
                                                    ?.text = minutes.toString();
                                              }
                                            }
                                          }
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: VehicleTextField(
                                            textEditingController:
                                                _editTripBloc.price,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            isPrefix: true,
                                            prefixText: _editTripBloc
                                                    .vehicleProfile?.currency ??
                                                '',
                                            onFieldSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .nextFocus(),
                                            onChanged: (String newValue) {
                                              if (_editTripBloc.totalDistance!
                                                      .text.isNotEmpty &&
                                                  newValue.isNotEmpty) {
                                                double distance =
                                                    double.tryParse(
                                                            _editTripBloc
                                                                .totalDistance!
                                                                .text) ??
                                                        0.0;
                                                double rate =
                                                    double.tryParse(newValue) ??
                                                        0.0;
                                                double totalAmount =
                                                    rate * distance;
                                                String formattedAmount =
                                                    totalAmount
                                                        .toStringAsFixed(2);

                                                _editTripBloc.earnings?.text =
                                                    formattedAmount;
                                              }
                                            },
                                            hintText: StringConstants.rate,
                                            labelText: StringConstants.rate,
                                            labelStyle: GoogleFonts.roboto(
                                                color: Color(0xff121212)
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15),
                                            suffixText: _editTripBloc
                                                        .mileageUnit?.text ==
                                                    "mile"
                                                ? '/mi'
                                                : "/km",
                                            suffixStyle: TextStyle(
                                                color: _appTheme.primaryColor),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Expanded(
                                          child: VehicleTextField(
                                            textEditingController:
                                                _editTripBloc.earnings,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            isPrefix: true,
                                            prefixText: _editTripBloc
                                                    .vehicleProfile?.currency ??
                                                '',
                                            onFieldSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .nextFocus(),
                                            hintText: StringConstants.earnings,
                                            labelText: StringConstants.earnings,
                                            labelStyle: GoogleFonts.roboto(
                                                color: Color(0xff121212)
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Notes(
                                      txtNotes: _editTripBloc.notes,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    BlueButton(
                                      onPress: () {
                                        _editTripBloc.btnUpdateClicked(
                                            context: context);
                                      },
                                      text: StringConstants.save.toUpperCase(),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            color: _appTheme.primaryColor),
                      ),
              ),
            );
          }),
    );
  }
}

class Notes extends StatelessWidget {
  final TextEditingController? txtNotes;
  Notes({Key? key, this.txtNotes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      controller: txtNotes,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromRGBO(208, 208, 208, 1), width: 1.0),
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
          borderSide:
              BorderSide(color: Color(0xff121212).withOpacity(0.2), width: 0.0),
        ),
        hintText: null,
        alignLabelWithHint: true,
        labelText: 'Notes',
        labelStyle: GoogleFonts.roboto(
            color: Color(0xff121212).withOpacity(0.7),
            fontWeight: FontWeight.w400,
            fontSize: 15),
        hintStyle: GoogleFonts.roboto(
            color: Color(0xff121212).withOpacity(0.5),
            fontWeight: FontWeight.w400,
            fontSize: 12),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: AppTheme.of(context).primaryColor, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      ),
      autofocus: false,
    );
  }
}
