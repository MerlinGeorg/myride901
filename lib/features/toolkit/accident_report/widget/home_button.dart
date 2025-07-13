import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';

class HomeButton extends StatelessWidget {
  final Function() onTap;

  const HomeButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AssetImages.left_arrow_bold,
            color: AppTheme.of(context).primaryColor,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            StringConstants.HOME,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppTheme.of(context).primaryColor),
          )
        ],
      ),
    );
  }
}
