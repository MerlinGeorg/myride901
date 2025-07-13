import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/vehicle_text_field.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/vin_final_page/vin_final_bloc.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';

class VINFinalPage extends StatefulWidget {
  const VINFinalPage({Key? key}) : super(key: key);

  @override
  _VINFinalPageState createState() => _VINFinalPageState();
}

class _VINFinalPageState extends State<VINFinalPage> {
  final _vINFinalBloc = VINFinalBloc();
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _vINFinalBloc.arguments =
          (ModalRoute.of(context)!.settings.arguments as ItemArgument).data;
      Map<String, dynamic> vehicleProfile =
          _vINFinalBloc.arguments['data'] ?? {};
      _vINFinalBloc.txtNickName.text =
          (vehicleProfile['vin_number'].substring(9, 17) +
                      ' ' +
                      vehicleProfile['make_company'] +
                      ' ' +
                      vehicleProfile['model'].replaceAll(' ', ''))
                  .toUpperCase() ??
              '';
      _vINFinalBloc.txtManufacturerController.text =
          vehicleProfile['make_company'] ?? '';
      _vINFinalBloc.txtModelController.text = vehicleProfile['model'] ?? '';
      _vINFinalBloc.txtYearController.text =
          (vehicleProfile['year'] ?? 0).toString();
      setState(() {});
    });
    // TODO: implement initState
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
          stream: _vINFinalBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              body: BlocProvider<VINFinalBloc>(
                  bloc: _vINFinalBloc,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.22,
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
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      StringConstants.label_vehicle_spec,
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          letterSpacing: 0.5,
                                          color: _appTheme.primaryColor),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      StringConstants.label_select_your_vehicle,
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          letterSpacing: 0.5,
                                          color: Color(0xff121212)
                                              .withOpacity(0.7)),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    VehicleTextField(
                                      textEditingController:
                                          _vINFinalBloc.txtNickName,
                                      hintText:
                                          StringConstants.hint_car_nick_name,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    VehicleTextField(
                                      textEditingController: _vINFinalBloc
                                          .txtManufacturerController,
                                      hintText:
                                          StringConstants.hint_car_manufacture,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    VehicleTextField(
                                      textEditingController:
                                          _vINFinalBloc.txtModelController,
                                      hintText: StringConstants.hint_car_model,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    VehicleTextField(
                                      textEditingController:
                                          _vINFinalBloc.txtYearController,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      textInputType: TextInputType.number,
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
                                          _vINFinalBloc.txtPDate,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).unfocus(),
                                      hintText: 'Select Purchase Date*',
                                      onTap: () {
                                        _vINFinalBloc.btnPDateClicked(
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
                                          _vINFinalBloc.txtPMile,
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
                                          _vINFinalBloc.txtCDate,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).unfocus(),
                                      hintText: 'Select Current Mileage Date*',
                                      onTap: () {
                                        _vINFinalBloc.btnCDateClicked(
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
                                          _vINFinalBloc.txtCMile,
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).unfocus(),
                                      hintText: 'Enter Current Mileage*',
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
                                                        _vINFinalBloc.mileType,
                                                    onChanged: _vINFinalBloc
                                                        .onMileTypePress,
                                                    activeColor:
                                                        _appTheme.primaryColor,
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
                                                        _vINFinalBloc.mileType,
                                                    onChanged: _vINFinalBloc
                                                        .onMileTypePress,
                                                    activeColor:
                                                        _appTheme.primaryColor,
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
                                        _vINFinalBloc.btnAddClicked2(
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
                                        _vINFinalBloc.btnAddClicked(
                                            context: context);
                                      },
                                      text: StringConstants.all_good
                                          .toUpperCase(),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
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
