import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myride901/core/themes/app_theme.dart';

class BlueButton extends StatelessWidget {
  final Function()? onPress;
  final String text;
  final bool enable;
  final bool hasIcon;
  final Widget icon;
  final Color? color;
  final bool colors;

  const BlueButton(
      {Key? key,
      this.onPress,
      this.text = "Button",
      this.enable = true,
      this.colors = true,
      this.color,
      this.hasIcon = false,
      this.icon = const Offstage()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppThemeState _appTheme = AppThemeState();
    return InkWell(
      onTap: () {
        if (enable) onPress?.call();
      },
      child: Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            color: enable
                ? (colors ? _appTheme.primaryColor : color)
                : Color(0xffD0D0D0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: GoogleFonts.roboto(
                      color: enable
                          ? Colors.white
                          : _appTheme.primaryColor.withOpacity(0.3),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 1),
                ),
                if (hasIcon) icon
              ],
            ),
          )),
    );
  }
}