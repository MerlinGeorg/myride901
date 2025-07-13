import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/core/services/analytic_services.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/typeahead_address_field.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/vehicle_text_field.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/toolkit/track_mileage/add_track_mileage/add_trip_bloc.dart';
import 'package:myride901/features/toolkit/track_mileage/widget/dropdown_item.dart';
import 'package:myride901/features/toolkit/track_mileage/widget/trip_earnings.dart';
import 'package:myride901/features/toolkit/track_mileage/widget/trip_notes.dart';
import 'package:myride901/features/toolkit/track_mileage/widget/trip_price.dart';

class AddTripPage extends StatefulWidget {
  const AddTripPage({Key? key}) : super(key: key);

  @override
  _AddTripPageState createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage>
    with SingleTickerProviderStateMixin {
  final _addTripBloc = AddTripBloc();
  var _arguments;
  AppThemeState _appTheme = AppThemeState();
  String? val = null;
  String? _selectedId;
  DateTime? startDate;
  DateTime? endDate;

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _arguments =
          (ModalRoute.of(context)?.settings.arguments as ItemArgument).data;
      if (_arguments['selectedVehicle'] != null) {
        _addTripBloc.selectedVehicle = _arguments['selectedVehicle'];
      }
      if (_arguments['mileageUnit'] != null) {
        print(_arguments['mileageUnit']);
        _addTripBloc.mileType = _arguments['mileageUnit'];
      }
      setState(() {});
    });
    _addTripBloc.getLastTripList(context: context);
    _addTripBloc.getVehicleList(context: context, isProgressBar: true);
  }

  @override
  void dispose() {
    super.dispose();
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
          stream: _addTripBloc.mainStream,
          builder: (context, snapshot) {
            _dropdownList =
                _buildFavouriteFoodModelDropdown(_addTripBloc.arrVehicle);
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: _appTheme.primaryColor,
                elevation: 0,
                title: Text(
                  StringConstants.add_mileage_tracker,
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
              body: BlocProvider<AddTripBloc>(
                bloc: _addTripBloc,
                child: _addTripBloc.isLoaded == true
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
                                    DropdownItem(
                                      textEditingController:
                                          TextEditingController(),
                                      onVehicleSelect: (value) async {
                                        setState(() {
                                          _addTripBloc.selectedVehicle = value;
                                          _addTripBloc.vehicleProfile =
                                              _addTripBloc.arrVehicle[value];
                                          _selectedItem =
                                              _addTripBloc.arrVehicle[value];
                                          _addTripBloc.mileType = _addTripBloc
                                                  .arrVehicle[value]
                                                  .mileageUnit ??
                                              '';
                                          _addTripBloc.startLocation?.clear();
                                          _addTripBloc.endLocation?.clear();
                                          _addTripBloc.totalDistance?.clear();
                                          _addTripBloc.daysController?.clear();
                                          _addTripBloc.hoursController?.clear();
                                          _addTripBloc.minutesController
                                              ?.clear();
                                          _addTripBloc.endDate?.clear();
                                          _addTripBloc.routes.clear();
                                        });
                                      },
                                      vehicleList: _addTripBloc.arrVehicle,
                                      selectedVehicle:
                                          _addTripBloc.selectedVehicle,
                                    ),
                                    SizedBox(height: 25),
                                    VehicleTextField(
                                      textEditingController:
                                          _addTripBloc.startDate,
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
                                        selectDate();
                                      },
                                    ),
                                    SizedBox(height: 20),
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
                                          value: val,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              val = newValue!;
                                              _addTripBloc.category?.text =
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
                                                child: Text(_addTripBloc
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
                                      controller: _addTripBloc.startLocation,
                                      onSelected: (suggestion) {
                                        setState(() {
                                          _addTripBloc.startLocation?.text =
                                              suggestion;
                                          if (_addTripBloc.startLocation!.text
                                                  .isNotEmpty &&
                                              _addTripBloc.endLocation!.text
                                                  .isNotEmpty) {
                                            _addTripBloc.getDirections(
                                                context: context);
                                          }
                                        });
                                      },
                                      suggestionsCallback: (pattern) async {
                                        if (pattern.length >= 3) {
                                          try {
                                            await _addTripBloc.getAutocomplete(
                                                context: context);
                                            return _addTripBloc.origin;
                                          } catch (error) {
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
                                      controller: _addTripBloc.endLocation,
                                      onSelected: (suggestion) {
                                        setState(() {
                                          _addTripBloc.endLocation?.text =
                                              suggestion;
                                          if (_addTripBloc.startLocation!.text
                                                  .isNotEmpty &&
                                              _addTripBloc.endLocation!.text
                                                  .isNotEmpty) {
                                            _addTripBloc.getDirections(
                                                context: context);
                                          }
                                        });
                                      },
                                      suggestionsCallback: (pattern) async {
                                        if (pattern.length >= 3) {
                                          try {
                                            await _addTripBloc.getAutocomplete2(
                                                context: context);
                                            return _addTripBloc.destination;
                                          } catch (error) {
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
                                    SizedBox(height: 20),
                                    Row(children: [
                                      Expanded(
                                        child: Text(
                                          _addTripBloc.routes.length > 0 &&
                                                  _addTripBloc.clicked == false
                                              ? 'Select Route'
                                              : 'Enter Route',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17,
                                              letterSpacing: 0.5,
                                              color: AppTheme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                      (_addTripBloc.routes.length > 0)
                                          ? TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (_addTripBloc.clicked) {
                                                    _addTripBloc.clicked =
                                                        false;
                                                    _selectedId = null;
                                                  } else {
                                                    _addTripBloc.clicked = true;
                                                    _addTripBloc.totalDistance
                                                        ?.clear();
                                                    _addTripBloc.daysController
                                                        ?.clear();
                                                    _addTripBloc.hoursController
                                                        ?.clear();
                                                    _addTripBloc
                                                        .minutesController
                                                        ?.clear();
                                                    _addTripBloc.endDate
                                                        ?.clear();
                                                  }
                                                });
                                              },
                                              child: Text(
                                                _addTripBloc.clicked == false
                                                    ? StringConstants.own_route
                                                    : StringConstants.gen_route,
                                                style: TextStyle(
                                                  color: _appTheme.primaryColor,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ]),
                                    SizedBox(height: 10),
                                    (_addTripBloc.routes.length > 0 &&
                                            _addTripBloc.clicked == false)
                                        ? routeSelected()
                                        : routeNotSelected(),
                                    SizedBox(height: 20),
                                    VehicleTextField(
                                        textEditingController:
                                            _addTripBloc.endDate,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                        hintText: "End Time",
                                        suffixIcon: AssetImages.calendar_1,
                                        hasSuffixIcon: true,
                                        labelText: 'End Time',
                                        labelStyle: GoogleFonts.roboto(
                                          color: Color(0xff121212)
                                              .withOpacity(0.7),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                        onTap: () async {
                                          selectEndDate();
                                        }),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Price(
                                            controller: _addTripBloc.price,
                                            onChange: (String newValue) {
                                              double distance = double.tryParse(
                                                      _addTripBloc
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

                                              _addTripBloc.earnings?.text =
                                                  formattedAmount;
                                            },
                                            type: _addTripBloc.mileType,
                                            currency: _addTripBloc
                                                .arrVehicle[_addTripBloc
                                                    .selectedVehicle]
                                                .currency,
                                          ),
                                        ),
                                        SizedBox(width: 40),
                                        Expanded(
                                          child: Earnings(
                                            controller: _addTripBloc.earnings,
                                            currency: _addTripBloc
                                                .arrVehicle[_addTripBloc
                                                    .selectedVehicle]
                                                .currency,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Notes(
                                      txtNotes: _addTripBloc.notes,
                                    ),
                                    SizedBox(height: 20),
                                    BlueButton(
                                      onPress: () {
                                        _addTripBloc.addTrip(context: context);

                                        locator<AnalyticsService>()
                                            .sendAnalyticsEvent(
                                                eventName: "AddMileageTracker",
                                                clickevent:
                                                    "User adding mileage tracker");
                                      },
                                      text: StringConstants.save.toUpperCase(),
                                    ),
                                    SizedBox(height: 25)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            );
          }),
    );
  }

  Widget routeSelected() {
    return SizedBox(
      height: 222,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _addTripBloc.routes.length,
        itemBuilder: (context, index) {
          return Card(
            color: _appTheme.primaryColor,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_addTripBloc.routes[index]} ' +
                            (_addTripBloc.mileType == 'mile' ? 'mi' : 'km'),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Radio<String>(
                        value: _addTripBloc.routes[index],
                        activeColor: _appTheme.redColor,
                        fillColor: MaterialStateColor.resolveWith(
                          (states) => _appTheme.redColor,
                        ),
                        groupValue: _selectedId,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedId = value!;

                            _addTripBloc.totalDistance?.text =
                                _addTripBloc.routes[index];
                            String durationString =
                                _addTripBloc.durations[index];

                            RegExp regex = RegExp(
                                r'((\d+)\s*day[s]?\s*)?((\d+)\s*hour[s]?\s*)?((\d+)\s*min[s]?)?');

                            Match? match = regex.firstMatch(durationString);
                            if (match != null) {
                              String? dayMatch = match.group(2);
                              String? hourMatch = match.group(4);
                              String? minuteMatch = match.group(6);

                              int days =
                                  dayMatch != null ? int.parse(dayMatch) : 0;
                              int hours =
                                  hourMatch != null ? int.parse(hourMatch) : 0;
                              int minutes = minuteMatch != null
                                  ? int.parse(minuteMatch)
                                  : 0;

                              int totalMinutes =
                                  days * 24 * 60 + hours * 60 + minutes;
                              int resultingDays = totalMinutes ~/ (24 * 60);
                              int resultingHours =
                                  (totalMinutes % (24 * 60)) ~/ 60;
                              int resultingMinutes = totalMinutes % 60;
                              _addTripBloc.daysController?.text =
                                  resultingDays.toString();
                              _addTripBloc.hoursController?.text =
                                  resultingHours.toString();
                              _addTripBloc.minutesController?.text =
                                  resultingMinutes.toString();
                              DateFormat inputFormat = DateFormat(
                                  (AppComponentBase.getInstance()
                                              .getLoginData()
                                              .user
                                              ?.date_format ??
                                          'yyyy-MM-dd') +
                                      ' HH:mm' // Default if null
                                  );
                              DateTime dateTime = inputFormat
                                  .parse(_addTripBloc.startDate.text);
                              DateTime newDateTime = dateTime.add(Duration(
                                  days: days, hours: hours, minutes: minutes));
                              DateFormat formatter = DateFormat(
                                  (AppComponentBase.getInstance()
                                              .getLoginData()
                                              .user
                                              ?.date_format ??
                                          'yyyy-MM-dd') +
                                      " HH:mm");
                              _addTripBloc.endDate?.text =
                                  formatter.format(newDateTime);
                            } else {
                              print('Invalid input format');
                            }

                            if (_addTripBloc.price!.text.isNotEmpty &&
                                value.isNotEmpty) {
                              double distance = double.tryParse(value) ?? 0.0;
                              double rate =
                                  double.tryParse(_addTripBloc.price!.text) ??
                                      0.0;
                              double totalAmount = rate * distance;

                              String formattedAmount =
                                  totalAmount.toStringAsFixed(2);

                              _addTripBloc.earnings?.text = formattedAmount;
                            }
                          });
                        },
                      ),
                      Text(
                        '${_addTripBloc.durations[index]} ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Utils.launchURL(_addTripBloc.links[index]),
                  child: Stack(children: [
                    ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 160,
                          child: Image.network(_addTripBloc.images[index]),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Opacity(
                        opacity: 1.0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'View in Google Maps',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget routeNotSelected() {
    return Container(
        child: Column(children: [
      VehicleTextField(
        textEditingController: _addTripBloc.totalDistance,
        textInputAction: TextInputAction.next,
        textInputType: TextInputType.number,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        hintText: StringConstants.distance,
        labelText: StringConstants.distance,
        onChanged: (String newValue) {
          if (_addTripBloc.price!.text.isNotEmpty && newValue.isNotEmpty) {
            double distance = double.tryParse(newValue) ?? 0.0;
            double rate = double.tryParse(_addTripBloc.price!.text) ?? 0.0;
            double totalAmount = rate * distance;
            String formattedAmount = totalAmount.toStringAsFixed(2);

            _addTripBloc.earnings?.text = formattedAmount;
          }
        },
        labelStyle: GoogleFonts.roboto(
            color: Color(0xff121212).withOpacity(0.7),
            fontWeight: FontWeight.w400,
            fontSize: 15),
        suffixText: _addTripBloc.mileType == "mile" ? 'mi' : "km",
        suffixStyle: TextStyle(color: _appTheme.primaryColor),
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Expanded(
            child: VehicleTextField(
              textEditingController: _addTripBloc.daysController,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              hintText: "Days",
              labelText: "Days",
              labelStyle: GoogleFonts.roboto(
                  color: Color(0xff121212).withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                  fontSize: 15),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: VehicleTextField(
              textEditingController: _addTripBloc.hoursController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.numberWithOptions(decimal: false),
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              hintText: "Hours",
              labelText: "Hours",
              labelStyle: GoogleFonts.roboto(
                  color: Color(0xff121212).withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                  fontSize: 15),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: VehicleTextField(
              textEditingController: _addTripBloc.minutesController,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              hintText: "Minutes",
              labelText: "Minutes",
              labelStyle: GoogleFonts.roboto(
                  color: Color(0xff121212).withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                  fontSize: 15),
            ),
          ),
        ],
      ),
    ]));
  }

  void selectDate() async {
    var dateTime = await showDatePicker(
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
      initialDate: _addTripBloc.startDate.text.isEmpty
          ? DateTime.now()
          : DateFormat(AppComponentBase.getInstance()
                  .getLoginData()
                  .user
                  ?.date_format)
              .parse(_addTripBloc.startDate.text),
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

        _addTripBloc.startDate.text = DateFormat((AppComponentBase.getInstance()
                        .getLoginData()
                        .user
                        ?.date_format ??
                    'yyyy-MM-dd') +
                " HH:mm")
            .format(dateTime);
        if (_addTripBloc.startDate.text.isNotEmpty &&
            _addTripBloc.endDate!.text.isNotEmpty) {
          DateTime startDate = dateTime;
          DateTime endDate = _addTripBloc.endDate!.text.isNotEmpty
              ? DateFormat((AppComponentBase.getInstance()
                              .getLoginData()
                              .user
                              ?.date_format ??
                          'yyyy-MM-dd') +
                      " HH:mm")
                  .parse(_addTripBloc.endDate!.text)
              : DateTime.now();

          Duration duration = endDate.difference(startDate);

          int days = duration.inDays;
          int hours = duration.inHours.remainder(24);
          int minutes = duration.inMinutes.remainder(60);

          _addTripBloc.daysController?.text = days.toString();
          _addTripBloc.hoursController?.text = hours.toString();
          _addTripBloc.minutesController?.text = minutes.toString();
        }
      }
    }
  }

  void selectEndDate() async {
    var dateTime = await showDatePicker(
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
      initialDate: _addTripBloc.endDate!.text.isEmpty
          ? DateTime.now()
          : DateFormat(AppComponentBase.getInstance()
                  .getLoginData()
                  .user
                  ?.date_format)
              .parse(_addTripBloc.endDate!.text),
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

        _addTripBloc.endDate?.text = DateFormat((AppComponentBase.getInstance()
                        .getLoginData()
                        .user
                        ?.date_format ??
                    'yyyy-MM-dd') +
                " HH:mm")
            .format(dateTime);
        if (_addTripBloc.startDate.text.isNotEmpty &&
            _addTripBloc.endDate!.text.isNotEmpty) {
          DateTime startDate = _addTripBloc.startDate.text.isNotEmpty
              ? DateFormat((AppComponentBase.getInstance()
                              .getLoginData()
                              .user
                              ?.date_format ??
                          'yyyy-MM-dd') +
                      " HH:mm")
                  .parse(_addTripBloc.startDate.text)
              : DateTime.now();
          endDate = dateTime;
          if (endDate != null) {
            Duration duration = endDate!.difference(startDate);

            int days = duration.inDays;
            int hours = duration.inHours.remainder(24);
            int minutes = duration.inMinutes.remainder(60);

            _addTripBloc.daysController?.text = days.toString();
            _addTripBloc.hoursController?.text = hours.toString();
            _addTripBloc.minutesController?.text = minutes.toString();
          }
        }
      }
    }
  }
}
