import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/my_ride_textform_field.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/auth/widget/white_button.dart';
import 'package:myride901/features/tabs/reminders/add_reminder/add_reminder_bloc.dart';
import 'package:timezone/timezone.dart' as tz;

class AddReminderPage extends StatefulWidget {
  const AddReminderPage({super.key});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> with RouteAware {
  AppThemeState _appTheme = AppThemeState();
  final _addReminderBloc = AddReminderBloc();

  @override
  void initState() {
    super.initState();
    _initializeTimeZone();

    _addReminderBloc.getVehicleList(
      context: context,
      isProgressBar: !AppComponentBase.getInstance().isArrVehicleProfileFetch,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _addReminderBloc.arguments =
          (ModalRoute.of(context)!.settings.arguments as ItemArgument).data;

      if (_addReminderBloc.arguments['value'] != null) {
        _addReminderBloc.vehicleService = _addReminderBloc.arguments['value'];
        _addReminderBloc.serviceId!.text =
            _addReminderBloc.vehicleService!.id.toString();
        _addReminderBloc.mainStreamController.sink.add(true);
        print('Irina' + _addReminderBloc.vehicleService!.title.toString());
      }

      if (_addReminderBloc.arguments['reminderData'] != null) {
        _addReminderBloc.name?.text =
            _addReminderBloc.arguments['reminderData'][0] ?? '';
        _addReminderBloc.date?.text =
            _addReminderBloc.arguments['reminderData'][1] ?? '';
        _addReminderBloc.notes?.text =
            _addReminderBloc.arguments['reminderData'][2] ?? '';
      }

      setState(() {});
    });

    _addReminderBloc.setLocalData();
  }

  void _initializeTimeZone() {
    String currentTimeZone = DateTime.now().timeZoneName;
    _addReminderBloc.timezone?.text = currentTimeZone;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final focus = FocusScope.of(context);

    _appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _addReminderBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: _appTheme.primaryColor,
                elevation: 0,
                title: Text(
                  StringConstants.label_add_reminder,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Colors.white),
                ),
                leading: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.reminders);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(AssetImages.left_arrow),
                  ),
                ),
              ),
              body: BlocProvider<AddReminderBloc>(
                bloc: _addReminderBloc,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, top: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      MyRideTextFormField(
                                        textEditingController:
                                            _addReminderBloc.name,
                                        hintText: 'Reminder name',
                                        readOnly: false,
                                        maxText: 256,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () =>
                                            focus.unfocus(),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      MyRideTextFormField(
                                        textEditingController:
                                            _addReminderBloc.date,
                                        hintText: 'Select reminder date',
                                        textInputAction: TextInputAction.next,
                                        readOnly: true,
                                        suffixIcon: AssetImages.calendar_1,
                                        hasSuffixIcon: true,
                                        onClick: () async {
                                          var date = await showDatePicker(
                                            context: context,
                                            initialDatePickerMode:
                                                DatePickerMode.day,
                                            initialEntryMode:
                                                DatePickerEntryMode
                                                    .calendarOnly,
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return Theme(
                                                data:
                                                    ThemeData.light().copyWith(
                                                  colorScheme:
                                                      ColorScheme.fromSeed(
                                                    seedColor:
                                                        _appTheme.primaryColor,
                                                    onPrimary: Colors.white,
                                                    surface:
                                                        _appTheme.whiteColor,
                                                    onSurface: Colors.black,
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                            initialDate: _addReminderBloc
                                                        .date?.text ==
                                                    ''
                                                ? DateTime.now()
                                                    .add(Duration(days: 1))
                                                : DateFormat(AppComponentBase
                                                            .getInstance()
                                                        .getLoginData()
                                                        .user
                                                        ?.date_format)
                                                    .parse(
                                                    _addReminderBloc
                                                            .date?.text ??
                                                        '',
                                                  ),
                                            firstDate: DateTime.now()
                                                .add(Duration(days: 1)),
                                            lastDate: DateTime(2040, 12, 31),
                                          );
                                          if (date != null) {
                                            _addReminderBloc.date?.text =
                                                DateFormat(AppComponentBase
                                                            .getInstance()
                                                        .getLoginData()
                                                        .user
                                                        ?.date_format)
                                                    .format(date);
                                            focus.nextFocus();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      NotesTextFields(
                                        txtNotes: _addReminderBloc.notes,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 25),
                          child: Column(
                            children: [
                              _addReminderBloc.serviceId!.text.isEmpty
                                  ? Column(
                                      children: [
                                        BlueButton(
                                          onPress: () {
                                            _addReminderBloc.nextService(
                                                context: context);
                                          },
                                          text:
                                              StringConstants.label_add_lookup,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        BlueButton(
                                          onPress: () {
                                            _addReminderBloc.openSheetEvent(
                                                context: context);
                                          },
                                          text: StringConstants
                                              .label_add_existing,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Card(
                                          elevation: 3,
                                          margin: EdgeInsets.all(8),
                                          child: Container(
                                            alignment: Alignment
                                                .center, // Center the entire row vertically
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (_addReminderBloc
                                                            .vehicleService
                                                            ?.serviceProviderId ==
                                                        null) {
                                                      _addReminderBloc
                                                          .btnClicked2(
                                                              context: context);
                                                    } else {
                                                      _addReminderBloc
                                                          .btnClicked(
                                                              context: context);
                                                    }
                                                  });
                                                },
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 70,
                                                      height: 70,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .transparent,
                                                            blurRadius: 10.0,
                                                            spreadRadius: 2.0,
                                                            offset:
                                                                Offset(1, 3),
                                                          ),
                                                        ],
                                                        border: Border.all(
                                                          width: 2,
                                                          color:
                                                              Color(0xffEEEEEE),
                                                          style:
                                                              BorderStyle.solid,
                                                        ),
                                                        color: Color(0xFFCCD4EB)
                                                            .withOpacity(0.2),
                                                      ),
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                          'assets/new/avatar_type/${_addReminderBloc.vehicleService?.avatar ?? ''}.svg',
                                                          width: 25,
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        height: 70,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _addReminderBloc
                                                                      .vehicleService
                                                                      ?.title ??
                                                                  '',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            SizedBox(height: 4),
                                                            Text(_addReminderBloc
                                                                    .vehicleService
                                                                    ?.mileage ??
                                                                ''),
                                                            Text(_addReminderBloc
                                                                    .vehicleService
                                                                    ?.serviceDate ??
                                                                ''),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    // Right side with icon buttons

                                                    Container(
                                                      height: 70,
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                          size: 24,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _addReminderBloc
                                                                .serviceId!
                                                                .text = '';
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                              WhiteButton(
                                onPress: () {
                                  _addReminderBloc.addReminder(
                                      context: context);
                                },
                                text: StringConstants.label_add_reminder,
                              ),
                              SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class NotesTextFields extends StatelessWidget {
  final TextEditingController? txtNotes;
  NotesTextFields({Key? key, this.txtNotes}) : super(key: key);

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
        filled: true,
        fillColor: Colors.white,
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
