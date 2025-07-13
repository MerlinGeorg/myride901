import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/vehicle_text_field.dart';

class Price extends StatelessWidget {
  final TextEditingController? controller;
  final Function? onChange;
  final String? type;
  final String? currency;
  const Price({
    super.key,
    this.controller,
    this.onChange,
    this.type,
    this.currency,
  });

  @override
  Widget build(BuildContext context) {
    AppThemeState _appTheme = AppThemeState();

    return VehicleTextField(
      textEditingController: controller,
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.numberWithOptions(decimal: true),
      isPrefix: true,
      prefixText: currency ?? '',
      onChanged: onChange,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      hintText: StringConstants.rate,
      labelText: StringConstants.rate,
      labelStyle: GoogleFonts.roboto(
          color: Color(0xff121212).withOpacity(0.7),
          fontWeight: FontWeight.w400,
          fontSize: 15),
      suffixText: type == "mile" ? '/mi' : "/km",
      suffixStyle: TextStyle(color: _appTheme.primaryColor),
    );
  }
}
