import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/vehicle_text_field.dart';

class Earnings extends StatelessWidget {
  final TextEditingController? controller;
  final String? currency;
  const Earnings({
    super.key,
    this.controller,
    this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return VehicleTextField(
      textEditingController: controller,
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.numberWithOptions(decimal: true),
      isPrefix: true,
      prefixText: currency!,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      hintText: StringConstants.earnings,
      labelText: StringConstants.earnings,
      labelStyle: GoogleFonts.roboto(
          color: Color(0xff121212).withOpacity(0.7),
          fontWeight: FontWeight.w400,
          fontSize: 15),
    );
  }
}
