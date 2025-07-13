import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/add_vehicle_manually/add_vehicle_manually_bloc.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/vehicle_text_field.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';

class AddVehicleManuallyPage extends StatefulWidget {
  const AddVehicleManuallyPage({Key? key}) : super(key: key);

  @override
  _AddVehicleManuallyPageState createState() => _AddVehicleManuallyPageState();
}

class _AddVehicleManuallyPageState extends State<AddVehicleManuallyPage> {
  final _addVehicleNumberBloc = AddVehicleManuallyBloc();
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    super.initState();
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
          stream: _addVehicleNumberBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              body: BlocProvider<AddVehicleManuallyBloc>(
                  bloc: _addVehicleNumberBloc,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                    AppTheme.of(context).primaryColor,
                                    AppTheme.of(context)
                                        .primaryColor
                                        .withOpacity(0.4),
                                  ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.22,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SvgPicture.asset(
                                    AssetImages.add_vehicle_car),
                              ),
                            ),
                            ColoredBox(
                              color: AppTheme.of(context)
                                  .primaryColor
                                  .withOpacity(0.4),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25, top: 25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        StringConstants
                                            .label_vehicle_information,
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                            letterSpacing: 0.5,
                                            color: _appTheme.primaryColor),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      VehicleTextField(
                                        textEditingController:
                                            _addVehicleNumberBloc.txtNickName,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                        hintText:
                                            StringConstants.hint_car_nick_name,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      VehicleTextField(
                                        textEditingController:
                                            _addVehicleNumberBloc.txtVin,
                                        hintText: 'Enter your VIN',
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      VehicleTextField(
                                        textEditingController:
                                            _addVehicleNumberBloc
                                                .carManufacturerController,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                        textInputAction: TextInputAction.next,
                                        hintText: StringConstants
                                            .hint_car_manufacture,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      VehicleTextField(
                                        textEditingController:
                                            _addVehicleNumberBloc
                                                .carModelController,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                        textInputAction: TextInputAction.next,
                                        hintText:
                                            StringConstants.hint_car_model,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      VehicleTextField(
                                        textEditingController:
                                            _addVehicleNumberBloc
                                                .carYearController,
                                        textInputType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                        hintText: StringConstants.hint_car_year,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(4),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Purchase Details',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17,
                                            letterSpacing: 0.5,
                                            color: AppTheme.of(context)
                                                .primaryColor),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      VehicleTextField(
                                        textEditingController:
                                            _addVehicleNumberBloc.txtPDate,
                                        hintText: 'Select Purchase Date*',
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).unfocus(),
                                        onTap: () {
                                          _addVehicleNumberBloc.btnPDateClicked(
                                              context: context);
                                        },
                                        suffixIcon: Container(
                                          alignment: Alignment.center,
                                          width: 20,
                                          child: SvgPicture.asset(
                                            AssetImages.calendar_1,
                                            color: _appTheme.primaryColor,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      VehicleTextField(
                                        textEditingController:
                                            _addVehicleNumberBloc.txtPMile,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).unfocus(),
                                        hintText: 'Mileage At Purchase*',
                                        textInputType: TextInputType.number,
                                        inputFormatters: [
                                          CustomTextInputFormatter()
                                        ],
                                        suffixIcon: Container(
                                          alignment: Alignment.center,
                                          width: 20,
                                          child: Image.asset(
                                            AssetImages.meter,
                                            color: _appTheme.primaryColor,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Current Mileage',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17,
                                            letterSpacing: 0.5,
                                            color: AppTheme.of(context)
                                                .primaryColor),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      VehicleTextField(
                                        textEditingController:
                                            _addVehicleNumberBloc.txtCDate,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).unfocus(),
                                        hintText:
                                            'Select Current Mileage Date*',
                                        onTap: () {
                                          _addVehicleNumberBloc.btnCDateClicked(
                                              context: context);
                                        },
                                        suffixIcon: Container(
                                          alignment: Alignment.center,
                                          width: 20,
                                          child: SvgPicture.asset(
                                            AssetImages.calendar_1,
                                            color: _appTheme.primaryColor,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      VehicleTextField(
                                        textEditingController:
                                            _addVehicleNumberBloc.txtCMile,
                                        hintText: 'Enter Current Mileage*',
                                        textInputAction: TextInputAction.done,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).unfocus(),
                                        textInputType: TextInputType.number,
                                        inputFormatters: [
                                          CustomTextInputFormatter()
                                        ],
                                        suffixIcon: Container(
                                          alignment: Alignment.center,
                                          width: 20,
                                          child: Image.asset(
                                            AssetImages.meter,
                                            color: _appTheme.primaryColor,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Measure Mileage In:',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 17,
                                                letterSpacing: 0.5,
                                                color: AppTheme.of(context)
                                                    .primaryColor),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: Radio(
                                                      value: 'mile',
                                                      groupValue:
                                                          _addVehicleNumberBloc
                                                              .mileType,
                                                      onChanged:
                                                          _addVehicleNumberBloc
                                                              .onMileTypePress,
                                                      activeColor: _appTheme
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Miles',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 15,
                                                        letterSpacing: 0.5,
                                                        color:
                                                            AppTheme.of(context)
                                                                .primaryColor),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 20,
                                                    child: Radio(
                                                      value: 'kilometer',
                                                      groupValue:
                                                          _addVehicleNumberBloc
                                                              .mileType,
                                                      onChanged:
                                                          _addVehicleNumberBloc
                                                              .onMileTypePress,
                                                      activeColor: _appTheme
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Kilometers',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 15,
                                                        letterSpacing: 0.5,
                                                        color:
                                                            AppTheme.of(context)
                                                                .primaryColor),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      BlueButton(
                                        onPress: () {
                                          _addVehicleNumberBloc.btnAddClicked2(
                                              context: context);
                                        },
                                        text: StringConstants.add_service_event
                                            .toUpperCase(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      BlueButton(
                                        onPress: () {
                                          _addVehicleNumberBloc.btnAddClicked(
                                              context: context);
                                        },
                                        text: StringConstants.all_good
                                            .toUpperCase(),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Positioned(
                              top: 40,
                              left: 20,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child:
                                    SvgPicture.asset(AssetImages.back_icon_1),
                              )),
                          Positioned(
                              top: 40,
                              right: 20,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      RouteName.dashboard, (route) => false);
                                },
                                child: SvgPicture.asset(
                                  AssetImages.vehicle_home,
                                  width: 34,
                                  height: 34,
                                ),
                              )),
                        ],
                      ),
                    ],
                  )),
            );
          }),
    );
  }
}
