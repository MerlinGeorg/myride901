import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AccidentReportHeader extends StatelessWidget {
  final int currentStep;
  final String title;
  final String subTitle;

  const AccidentReportHeader({
    Key? key,
    required this.currentStep,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 5.0,
            percent: currentStep / 8,
            circularStrokeCap: CircularStrokeCap.round,
            animation: false,
            animateFromLastPercent: false,
            center: Text(
              '$currentStep/8',
              style: GoogleFonts.roboto(
                  color: AppTheme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
            progressColor: AppTheme.of(context).primaryColor,
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.of(context).primaryColor),
                ),
                SizedBox(height: 5,),
                Text(
                  subTitle,
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff121212).withOpacity(0.7)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
