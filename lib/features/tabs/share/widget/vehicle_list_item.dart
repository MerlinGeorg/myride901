import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/widgets/user_picture.dart';

class VehicleItemList extends StatelessWidget {
  final String? text;
  final String? userPicture;
  final bool? isSelected;

  const VehicleItemList({Key? key, this.text, this.userPicture, this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          UserPicture(
              userPicture: userPicture ?? '',
              fontSize: 15,
              size: Size(35, 35),
              text: (text ?? '').length > 0
                  ? (text ?? '').substring(0, 1).toUpperCase()
                  : (text ?? '').toUpperCase()),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              text ?? '',
              maxLines: 1,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xff121212)),
            ),
          ),
          if (isSelected ?? false)
            Text(
              'Selected',
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey),
            )
        ],
      ),
    );
  }
}
