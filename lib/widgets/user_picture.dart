import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/customNetwork.dart';

import 'circle_outerline_gradient.dart';

class UserPicture extends StatelessWidget {
  final String text;
  final String userPicture;
  final Size? size;
  final double? fontSize;
  final bool whiteBg;

  const UserPicture(
      {Key? key,
      this.text = '',
      this.userPicture = '',
      this.size,
      this.fontSize,
      this.whiteBg = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppThemeState _appTheme = AppThemeState();
    if (userPicture.isEmpty && whiteBg)
      return CircleAvatar(
        radius: size!.height / 2,
        backgroundColor: Colors.white,
        child: Text(
          (text.length > 1 ? text.substring(0, 1) : text).toUpperCase(),
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              fontSize: fontSize,
              color: _appTheme.primaryColor),
        ),
      );
    else if (userPicture.isEmpty)
      return CircleOuterLineGradient(
        strokeWidth: 2,
        text: (text.length > 1 ? text.substring(0, 1) : text).toUpperCase(),
        size: size,
        fontSize: fontSize == null ? 15 : fontSize,
      );
    else
      return CustomNetwork(
        height: size!.height,
        width: size!.width,
        fit: BoxFit.cover,
        image: userPicture,
        radius: size!.height / 2,
        errorWidget: CircleOuterLineGradient(
          strokeWidth: 2,
          text: (text.length > 1 ? text.substring(0, 1) : text).toUpperCase(),
          size: size,
          fontSize: fontSize == null ? 15 : fontSize,
        ),
      );
  }
}

class UserPictureAsset extends StatelessWidget {
  final String? text;
  final dynamic userPicture;
  final Size? size;
  final double? fontSize;
  final bool whiteBg;

  const UserPictureAsset(
      {Key? key,
      this.text,
      this.userPicture,
      this.size,
      this.fontSize,
      this.whiteBg = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userPicture is File)
      return ClipRRect(
        borderRadius: BorderRadius.circular(size!.height / 2),
        child: Image.file(userPicture,
            height: size!.height, width: size!.width, fit: BoxFit.cover),
      );
    if (userPicture.isEmpty)
      return CircleOuterLineGradientAsset(
        strokeWidth: 2,
        size: size!,
      );
    else
      return CustomNetwork(
        height: size!.height,
        width: size!.width,
        fit: BoxFit.cover,
        image: userPicture,
        radius: size!.height / 2,
      );
  }
}
