import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';

class CarNameListItem extends StatelessWidget {
  final String? name;
  final bool? hasRightIcon;

  const CarNameListItem({Key? key, this.name, this.hasRightIcon = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          name ?? '',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xff121212)),
        ),
        Spacer(),
        if (hasRightIcon ?? false)
          RotatedBox(
            quarterTurns: 90,
            child: SvgPicture.asset(
              AssetImages.left_arrow,
              color: Color(0xff121212).withOpacity(0.2),
            ),
          )
      ],
    );
  }
}
