import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';

class SelectCarModelAndColorHeader extends StatelessWidget {
  const SelectCarModelAndColorHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringConstants.label_car_information,
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
          StringConstants.label_enter_model_number_and_color,
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
