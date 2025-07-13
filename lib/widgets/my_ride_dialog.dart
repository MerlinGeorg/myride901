import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions;
  final String img;
  final String btnText;
  final Function()? onPress;

  const CustomDialogBox(
      {this.title = "Title",
      this.descriptions = "Descr",
      this.img = AssetImages.pass_lock,
      this.btnText = 'Button',
      this.onPress});

  CustomDialogBox.verified({this.onPress})
      : img = AssetImages.verified,
        title = StringConstants.verified,
        btnText = StringConstants.BROWSE_HOME,
        descriptions = StringConstants.verified_sub_text;

  CustomDialogBox.created({this.onPress})
      : img = AssetImages.verified,
        title = StringConstants.created,
        btnText = StringConstants.BROWSE_HOME,
        descriptions = StringConstants.created_dialog_sub_text;

  CustomDialogBox.eventShare({this.onPress})
      : img = AssetImages.verified,
        title = '',
        btnText = StringConstants.eventShareSuccess,
        descriptions = '';
  CustomDialogBox.accidentShare({this.onPress})
      : img = AssetImages.verified,
        title = '',
        btnText = StringConstants.accidentReportShareSuccess,
        descriptions = '';

  CustomDialogBox.vehicleAdd({this.onPress})
      : img = AssetImages.verified,
        title = '',
        btnText = StringConstants.vehicle_added_successfully,
        descriptions = StringConstants.add_service_event_fut;

  CustomDialogBox.vehicleAdd2({this.onPress})
      : img = AssetImages.verified,
        title = '',
        btnText = StringConstants.vehicle_added_successfully,
        descriptions = '';

  CustomDialogBox.anotherService({this.onPress})
      : img = AssetImages.verified,
        title = '',
        btnText = StringConstants.service_added_successfully,
        descriptions = StringConstants.add_another_service_event;

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  AppThemeState _appTheme = AppThemeState();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      elevation: 0,
      backgroundColor: Colors.black.withOpacity(0.5),
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              SvgPicture.asset(widget.img),
              if (widget.title != '')
                SizedBox(
                  height: 25,
                ),
              if (widget.title != '')
                Text(
                  widget.title,
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: _appTheme.primaryColor),
                ),
              if (widget.descriptions != '')
                SizedBox(
                  height: 15,
                ),
              if (widget.descriptions != '')
                Opacity(
                  opacity: 1,
                  child: Text(
                    widget.descriptions,
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _appTheme.primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(
                height: 42,
              ),
              BlueButton(
                  text: widget.btnText,
                  onPress: () {
                    Navigator.pop(context);
                    widget.onPress!.call();
                  }),
            ],
          ),
        ),
      ],
    );
  }
}

class TrialDialogBox extends StatefulWidget {
  final Function()? onPress;

  const TrialDialogBox({this.onPress});

  @override
  _TrialDialogBoxState createState() => _TrialDialogBoxState();
}

class _TrialDialogBoxState extends State<TrialDialogBox> {
  AppThemeState _appTheme = AppThemeState();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      elevation: 0,
      backgroundColor: Colors.black.withOpacity(0.5),
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              SvgPicture.asset(AssetImages.trial),
              SizedBox(
                height: 25,
              ),
              Text(
                'Free Trial',
                style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: _appTheme.primaryColor),
              ),
              SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(
                  text: 'Thank you for using ',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xff121212).withOpacity(0.4)),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'MyRide901.',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppTheme.of(context).primaryColor)),
                  ],
                ),
              ),
              Text(
                'Your free trial ends in 14 days.',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xff121212).withOpacity(0.4)),
              ),
              SizedBox(
                height: 42,
              ),
              BlueButton(
                  text: 'CONTINUE',
                  onPress: () {
                    Navigator.pop(context);
                    widget.onPress!.call();
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
