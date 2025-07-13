import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/vehicle_text_field.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';

class EnterVehicleSpec extends StatefulWidget {
  final TextEditingController? txtNickName;
  final TextEditingController? txtPMile;
  final TextEditingController? txtPDate;
  final TextEditingController? txtCMile;
  final TextEditingController? txtCDate;
  final TextEditingController? txtDrive;
  final TextEditingController? txtTrim;
  final TextEditingController? txtVin;
  final TextEditingController? txtEngine;
  final Function? onContinuePress2;
  final Function? onContinuePress;
  final Function? onEnginePress;
  final Function? onPDatePress;
  final Function? onCDatePress;
  final Function(String?)? onMileTypePress;
  final String? mileType;

  const EnterVehicleSpec(
      {Key? key,
      this.txtNickName,
      this.txtPMile,
      this.txtDrive,
      this.txtEngine,
      this.txtTrim,
      this.txtVin,
      this.onContinuePress,
      this.onContinuePress2,
      this.onEnginePress,
      this.onPDatePress,
      this.onCDatePress,
      this.txtCDate,
      this.txtCMile,
      this.txtPDate,
      this.mileType,
      this.onMileTypePress})
      : super(key: key);

  @override
  _EnterVehicleSpecState createState() => _EnterVehicleSpecState();
}

class _EnterVehicleSpecState extends State<EnterVehicleSpec>
    with AutomaticKeepAliveClientMixin {
  AppThemeState _appTheme = AppThemeState();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VehicleTextField(
            textEditingController: widget.txtNickName,
            hintText: StringConstants.hint_car_nick_name,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
          SizedBox(
            height: 20,
          ),
          VehicleTextField(
            textEditingController: widget.txtVin,
            hintText: 'Enter your VIN',
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
          SizedBox(
            height: 20,
          ),
          VehicleTextField(
            textEditingController: widget.txtTrim,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            hintText: StringConstants.hint_enter_trim,
          ),
          SizedBox(
            height: 20,
          ),
          VehicleTextField(
            textEditingController: widget.txtDrive,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            hintText: StringConstants.hint_enter_drive,
          ),
          SizedBox(
            height: 20,
          ),
          VehicleTextField(
            textEditingController: widget.txtEngine,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            hintText:
                '${widget.onEnginePress == null ? 'Enter' : 'Select'} Vehicle Engine',
            onTap: widget.onEnginePress,
            suffixIcon: widget.onEnginePress == null
                ? null
                : Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: _appTheme.primaryColor,
                  ),
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
                color: AppTheme.of(context).primaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          VehicleTextField(
            textEditingController: widget.txtPDate,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            hintText: 'Select Purchase Date*',
            onTap: widget.onPDatePress,
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
            textEditingController: widget.txtPMile,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            hintText: 'Mileage At Purchase*',
            textInputType: TextInputType.number,
            inputFormatters: [CustomTextInputFormatter()],
            suffixIcon: Container(
              alignment: Alignment.center,
              width: 20,
              child: SvgPicture.asset(
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
                color: AppTheme.of(context).primaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          VehicleTextField(
            textEditingController: widget.txtCDate,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            hintText: 'Select Current Mileage Date*',
            onTap: widget.onCDatePress,
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
            textEditingController: widget.txtCMile,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            hintText: 'Enter Current Mileage*',
            textInputType: TextInputType.number,
            inputFormatters: [CustomTextInputFormatter()],
            suffixIcon: Container(
              alignment: Alignment.center,
              width: 20,
              child: SvgPicture.asset(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Measure Mileage In:',
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    letterSpacing: 0.5,
                    color: AppTheme.of(context).primaryColor),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Radio(
                          value: 'mile',
                          groupValue: widget.mileType,
                          onChanged: widget.onMileTypePress,
                          activeColor: _appTheme.primaryColor,
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
                            color: AppTheme.of(context).primaryColor),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                        child: Radio(
                          value: 'kilometer',
                          groupValue: widget.mileType,
                          onChanged: widget.onMileTypePress,
                          activeColor: _appTheme.primaryColor,
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
                            color: AppTheme.of(context).primaryColor),
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
              widget.onContinuePress?.call();
            },
            text: StringConstants.add_service_event.toUpperCase(),
          ),
          SizedBox(
            height: 10,
          ),
          BlueButton(
            onPress: () {
              widget.onContinuePress2?.call();
            },
            text: StringConstants.all_good.toUpperCase(),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
