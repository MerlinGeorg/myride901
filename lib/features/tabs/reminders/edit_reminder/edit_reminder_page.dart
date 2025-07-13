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
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/my_ride_textform_field.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/auth/widget/white_button.dart';
import 'package:myride901/features/tabs/reminders/edit_reminder/edit_reminder_bloc.dart';

class EditReminderPage extends StatefulWidget {
  const EditReminderPage({super.key});

  @override
  State<EditReminderPage> createState() => _EditReminderPageState();
}

class _EditReminderPageState extends State<EditReminderPage> {
  final _editReminderBloc = EditReminderBloc();
  AppThemeState _appTheme = AppThemeState();
  var _arguments;

  @override
  void initState() {
    super.initState();

    _editReminderBloc.getVehicleList(
        context: context,
        isProgressBar:
            !AppComponentBase.getInstance().isArrVehicleProfileFetch);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _editReminderBloc.arguments =
          (ModalRoute.of(context)!.settings.arguments as ItemArgument).data;
      if (_editReminderBloc.arguments['reminder'] != null) {
        _editReminderBloc.reminder = _editReminderBloc.arguments['reminder'];
        if (_editReminderBloc.reminder!.serviceId != null) {
          _editReminderBloc.serviceId!.text =
              _editReminderBloc.reminder!.serviceId.toString();
          print("Chukcha " + _editReminderBloc.serviceId!.text);
          _editReminderBloc.getEventById(context: context);
        }
        _editReminderBloc.getReminderById(context: context);
      }
      if (_editReminderBloc.arguments['value'] != null) {
        _editReminderBloc.vehicleService = _editReminderBloc.arguments['value'];
        _editReminderBloc.serviceId!.text =
            _editReminderBloc.vehicleService!.id.toString();
        if (_editReminderBloc.reminder!.serviceId != null) {
          _editReminderBloc.getEventById(context: context);
        }
        _editReminderBloc.mainStreamController.sink.add(true);
        print('Irina' + _editReminderBloc.vehicleService!.title.toString());
      }
      if (_editReminderBloc.arguments['reminderData'] != null) {
        _editReminderBloc.name?.text =
            _editReminderBloc.arguments['reminderData'][0] ?? '';
        _editReminderBloc.date?.text =
            _editReminderBloc.arguments['reminderData'][1] ?? '';
        _editReminderBloc.notes?.text =
            _editReminderBloc.arguments['reminderData'][2] ?? '';
      }
      setState(() {});
    });
    _editReminderBloc.setLocalData();

    _initializeTimeZone();
  }

  void _initializeTimeZone() {
    String currentTimeZone = DateTime.now().timeZoneName;
    _editReminderBloc.timezone?.text = currentTimeZone;
    print("Current Timezone: $currentTimeZone");
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
          stream: _editReminderBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: _appTheme.primaryColor,
                elevation: 0,
                title: Text(
                  StringConstants.label_edit_reminder,
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
              body: BlocProvider<EditReminderBloc>(
                bloc: _editReminderBloc,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: _editReminderBloc.isLoaded
                      ? Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25, right: 25, top: 25),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            MyRideTextFormField(
                                              textEditingController:
                                                  _editReminderBloc.name,
                                              hintText: 'Reminder name',
                                              readOnly: false,
                                              maxText: 256,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onEditingComplete: () =>
                                                  focus.unfocus(),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            MyRideTextFormField(
                                              textEditingController:
                                                  _editReminderBloc.date,
                                              hintText: 'Select reminder date',
                                              textInputAction:
                                                  TextInputAction.next,
                                              readOnly: true,
                                              suffixIcon:
                                                  AssetImages.calendar_1,
                                              hasSuffixIcon: true,
                                              onClick: () async {
                                                var date = await showDatePicker(
                                                  context: context,
                                                  initialDatePickerMode:
                                                      DatePickerMode.day,
                                                  initialEntryMode:
                                                      DatePickerEntryMode
                                                          .calendarOnly,
                                                  builder:
                                                      (BuildContext context,
                                                          Widget? child) {
                                                    return Theme(
                                                      data: ThemeData.light()
                                                          .copyWith(
                                                        colorScheme: ColorScheme
                                                            .fromSeed(
                                                          seedColor: _appTheme
                                                              .primaryColor,
                                                          onPrimary:
                                                              Colors.white,
                                                          surface: _appTheme
                                                              .whiteColor,
                                                          onSurface:
                                                              Colors.black,
                                                        ),
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                  initialDate: _editReminderBloc
                                                              .date?.text ==
                                                          ''
                                                      ? DateTime.now().add(
                                                          Duration(days: 1))
                                                      : DateFormat(AppComponentBase
                                                                  .getInstance()
                                                              .getLoginData()
                                                              .user
                                                              ?.date_format)
                                                          .parse(
                                                          _editReminderBloc
                                                                  .date?.text ??
                                                              '',
                                                        ),
                                                  firstDate: DateTime.now()
                                                      .add(Duration(days: 1)),
                                                  lastDate:
                                                      DateTime(2040, 12, 31),
                                                );
                                                if (date != null) {
                                                  _editReminderBloc
                                                      .date?.text = DateFormat(
                                                          AppComponentBase
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
                                              txtNotes: _editReminderBloc.notes,
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
                                    (_editReminderBloc
                                                .serviceId?.text.isEmpty ??
                                            true)
                                        ? Column(
                                            children: [
                                              WhiteButton(
                                                onPress: () {
                                                  _editReminderBloc.nextService(
                                                      context: context);
                                                },
                                                text: StringConstants
                                                    .label_add_lookup,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              WhiteButton(
                                                onPress: () {
                                                  _editReminderBloc
                                                      .openSheetEvent(
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _editReminderBloc
                                                                    .vehicleService!
                                                                    .serviceProviderId ==
                                                                null
                                                            ? _editReminderBloc
                                                                .btnClicked2(
                                                                    context:
                                                                        context)
                                                            : _editReminderBloc
                                                                .btnClicked(
                                                                    context:
                                                                        context);
                                                      },
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Left side with image and details
                                                          Container(
                                                            width: 70,
                                                            height: 70,
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .transparent,
                                                                  blurRadius:
                                                                      10.0,
                                                                  spreadRadius:
                                                                      2.0,
                                                                  offset:
                                                                      Offset(
                                                                          1, 3),
                                                                ),
                                                              ],
                                                              border:
                                                                  Border.all(
                                                                width: 2,
                                                                color: Color(
                                                                    0xffEEEEEE),
                                                                style:
                                                                    BorderStyle
                                                                        .solid,
                                                              ),
                                                              color: Color(
                                                                      0xFFCCD4EB)
                                                                  .withOpacity(
                                                                      0.2),
                                                            ),
                                                            child: Center(
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/new/avatar_type/${_editReminderBloc.vehicleService?.avatar ?? ''}.svg',
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
                                                                    _editReminderBloc
                                                                            .vehicleService
                                                                            ?.title ??
                                                                        '',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(_editReminderBloc
                                                                          .vehicleService
                                                                          ?.mileage ??
                                                                      ''),
                                                                  Text(_editReminderBloc
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
                                                                color:
                                                                    Colors.red,
                                                                size: 24,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  _editReminderBloc
                                                                      .serviceId!
                                                                      .text = '';
                                                                  print("value " +
                                                                      _editReminderBloc
                                                                          .serviceId!
                                                                          .text);
                                                                  print("value " +
                                                                      _editReminderBloc
                                                                          .vehicleService!
                                                                          .id
                                                                          .toString());
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
                                    BlueButton(
                                      onPress: () {
                                        _editReminderBloc.updateReminder(
                                            context: context);
                                      },
                                      text:
                                          StringConstants.label_update_reminder,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    BlueButton(
                                      colors: false,
                                      color: _appTheme.redColor,
                                      onPress: () {
                                        Utils.showAlertDialogCallBack1(
                                            context: context,
                                            message:
                                                'You are about to delete a reminder - ${_editReminderBloc.name!.text}. Please click Cancel or Confirm, below.',
                                            isConfirmationDialog: false,
                                            isOnlyOK: false,
                                            navBtnName: 'Cancel',
                                            posBtnName: 'Confirm',
                                            onNavClick: () {},
                                            onPosClick: () {
                                              _editReminderBloc.deleteReminder(
                                                  context: context);
                                            });
                                      },
                                      text:
                                          StringConstants.label_delete_reminder,
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(child: CircularProgressIndicator()),
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
