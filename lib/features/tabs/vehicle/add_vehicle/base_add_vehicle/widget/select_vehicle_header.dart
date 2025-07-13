import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';

class SelectVehicleHeader extends StatelessWidget {
  const SelectVehicleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringConstants.label_add_your_vehicle,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: 0.5,
              color: AppTheme.of(context).primaryColor),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          StringConstants.label_select_one_vehicle,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              letterSpacing: 0.5,
              color: Color(0xff121212).withOpacity(0.7)),
        ),
      ],
    );
  }
}
