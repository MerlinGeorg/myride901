import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/themes/app_theme.dart';

class VerticalStripPricing extends StatelessWidget {
  final String title;
  final String prefillIcon;
  final String value;

  const VerticalStripPricing({
    Key? key,
    this.title = '',
    this.prefillIcon = '',
    this.value = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.transparent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Text(
              prefillIcon,
              style: TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(
                  color: AppTheme.of(context).primaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 13),
            ),
          ]),
          SizedBox(
            width: 10,
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: AppTheme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
