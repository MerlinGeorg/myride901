import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';

class EventDetail extends StatelessWidget {
  final String event;
  final String date;
  final String miles;

  const EventDetail(
      {Key? key,  this.event = '',  this.date = '',  this.miles = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SvgPicture.asset(AssetImages.ellipse_red),
              SizedBox(
                width: 15,
              ),
              Text(
                StringConstants.event_details,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.5,
                    color:AppTheme.of(context).primaryColor),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          keyValue(context,StringConstants.event, event),
          SizedBox(
            height: 15,
          ),
          keyValue(context,StringConstants.date, date),
          SizedBox(
            height: 15,
          ),
          keyValue(context,StringConstants.miles, miles),
        ],
      ),
    );
  }

  Widget keyValue(BuildContext context,String key, String value) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            key,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                letterSpacing: 1,
                color: AppTheme.of(context).primaryColor.withOpacity(0.8)),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color:AppTheme.of(context).primaryColor),
          ),
        )
      ],
    );
  }
}
