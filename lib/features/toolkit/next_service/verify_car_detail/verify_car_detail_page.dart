import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/toolkit/next_service/verify_car_detail/verify_car_detail_bloc.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';

class VerifyCarDetailPage extends StatefulWidget {
  const VerifyCarDetailPage({Key? key}) : super(key: key);

  @override
  _VerifyCarDetailPageState createState() => _VerifyCarDetailPageState();
}

class _VerifyCarDetailPageState extends State<VerifyCarDetailPage> {
  final _verifyCarDetailBloc = VerifyCarDetailBloc();
  AppThemeState _appTheme = AppThemeState();

  List<VehicleDetailData> list = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _verifyCarDetailBloc.arrSpec =
          ((ModalRoute.of(context)!.settings.arguments as ItemArgument).data
              as dynamic)['service'];
      _verifyCarDetailBloc.arguments =
          (ModalRoute.of(context)!.settings.arguments as ItemArgument).data;
      if (_verifyCarDetailBloc.arguments['reminder'] != null) {
        _verifyCarDetailBloc.reminder =
            _verifyCarDetailBloc.arguments['reminder'];
      }

      if (_verifyCarDetailBloc.arguments['reminderData'] != null) {
        _verifyCarDetailBloc.reminderData =
            _verifyCarDetailBloc.arguments['reminderData'];
        print("Irina " + _verifyCarDetailBloc.reminderData!.first);
      }
      String? receivedValue =
          ((ModalRoute.of(context)!.settings.arguments as ItemArgument).data
              as dynamic)['value'];
      _verifyCarDetailBloc.val = receivedValue ?? '';
      print(_verifyCarDetailBloc.val);
      _verifyCarDetailBloc.vehicle = VehicleProfile.fromJson(
          ((ModalRoute.of(context)!.settings.arguments as ItemArgument).data
              as dynamic)['vehicle']);
      list.add(VehicleDetailData('Make', '', AssetImages.user,
          _verifyCarDetailBloc.vehicle!.Make ?? ''));
      list.add(VehicleDetailData('Drive', '', AssetImages.power,
          _verifyCarDetailBloc.vehicle!.Drive ?? ''));
      list.add(VehicleDetailData('Model', '', AssetImages.car,
          _verifyCarDetailBloc.vehicle!.Model ?? ''));
      list.add(VehicleDetailData('Body/Trim', '', AssetImages.car_body,
          _verifyCarDetailBloc.vehicle!.Body ?? ''));
      list.add(VehicleDetailData('Year', '', AssetImages.calendar_1,
          _verifyCarDetailBloc.vehicle!.Year ?? ''));
      list.add(VehicleDetailData('Engine', '', AssetImages.engine,
          _verifyCarDetailBloc.vehicle!.Engine ?? ''));
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _verifyCarDetailBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: _appTheme.primaryColor,
                leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AssetImages.left_arrow),
                    )),
                title: Text(
                  StringConstants.verify_car_detail,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              body: BlocProvider<VerifyCarDetailBloc>(
                  bloc: _verifyCarDetailBloc,
                  child: Container(
                    color: Color(0xffC3D7FF).withOpacity(0.1),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confirm Vehicle',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: AppTheme.of(context).primaryColor),
                        ),
                        if (_verifyCarDetailBloc.vehicle != null)
                          Expanded(
                            child: ListView(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                VerticalStrip(
                                  title: 'VIN',
                                  isPrefix: false,
                                  prefillIcon: AssetImages.user_bold,
                                  value:
                                      _verifyCarDetailBloc.vehicle?.VIN ?? '',
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 15,
                                          bottom: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                list[index].title,
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13,
                                                    color: AppTheme.of(context)
                                                        .primaryColor),
                                              ),
                                              Spacer(),
                                              SvgPicture.asset(
                                                list[index].icon,
                                                color: Color(0xffD03737),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: TextEditingController(
                                                  text: list[index].value),
                                              readOnly: true,
                                              inputFormatters:
                                                  list[index].title != 'Year'
                                                      ? []
                                                      : [
                                                          LengthLimitingTextInputFormatter(
                                                              4),
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                              cursorColor:
                                                  AppThemeState().primaryColor,
                                              decoration: InputDecoration(
                                                  suffix: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3),
                                                    child: Text(
                                                      list[index].suffix,
                                                      style: GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 17,
                                                          color: AppTheme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                  ),
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  //  filled: true,
                                                  hintStyle: GoogleFonts.roboto(
                                                      color: Color(0xff121212)
                                                          .withOpacity(0.2)),
                                                  fillColor: Colors.white70),
                                              maxLines: 1,
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 17,
                                                  color: AppTheme.of(context)
                                                      .primaryColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: list.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 1.7,
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 25,
                                          crossAxisSpacing: 25),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        BlueButton(
                          text: 'Confirm'.toUpperCase(),
                          onPress: () {
                            Utils.showAlertDialogCallBack1(
                                context: context,
                                message:
                                    'The service tasks presented on the following screen are intended to be considerations as a basis for discussion. We recommend you review all service tasks with a qualified technician before proceeding with any work related to them.',
                                isConfirmationDialog: false,
                                isOnlyOK: false,
                                navBtnName: 'Cancel',
                                posBtnName: 'Confirm',
                                onNavClick: () {},
                                onPosClick: () {
                                  _verifyCarDetailBloc.btnSubmitClicked(
                                      context: context);
                                });
                          },
                        ),
                      ],
                    ),
                  )),
            );
          }),
    );
  }
}

class VerticalStrip extends StatelessWidget {
  final String? title;
  final String? prefillIcon;
  final String? value;
  final bool? isPrefix;
  final String? prefixText;
  final TextInputType? keyboardType;

  const VerticalStrip(
      {Key? key,
      this.title,
      this.prefillIcon,
      this.value,
      this.isPrefix,
      this.prefixText,
      this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Row(
        children: [
          SvgPicture.asset(
            prefillIcon ?? '',
            width: 20,
            height: 20,
            color: Color(0xffD03737),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title ?? '',
            style: GoogleFonts.roboto(
                color: AppTheme.of(context).primaryColor,
                fontWeight: FontWeight.w400,
                fontSize: 13),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextFormField(
              controller: TextEditingController(text: value),
              keyboardType:
                  keyboardType == null ? TextInputType.number : keyboardType,
              inputFormatters:
                  keyboardType == null ? [CustomTextInputFormatter()] : [],
              readOnly: true,
              textAlign: TextAlign.right,
              cursorColor: AppThemeState().primaryColor,
              decoration: InputDecoration(
                  prefix: (isPrefix ?? false)
                      ? Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Text(
                            prefixText ?? '',
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: AppTheme.of(context).primaryColor),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  //  filled: true,
                  hintStyle: GoogleFonts.roboto(
                      color: Color(0xff121212).withOpacity(0.2)),
                  fillColor: Colors.white70),
              maxLines: 1,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: AppTheme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class VehicleDetailData {
  final String title;
  final String suffix;
  final String icon;
  final String value;

  VehicleDetailData(this.title, this.suffix, this.icon, this.value);
}