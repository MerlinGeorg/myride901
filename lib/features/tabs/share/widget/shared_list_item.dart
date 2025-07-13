import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/widgets/user_picture.dart';

class SharedItemList extends StatelessWidget {
  final String? text;
  final String? userPicture;
  final String? sharedUserNames;
  final bool? isSelected;
  final Function? btnDeleteClicked;

  const SharedItemList(
      {Key? key,
      this.text,
      this.btnDeleteClicked,
      this.userPicture,
      this.isSelected,
      this.sharedUserNames})
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
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (text ?? ''),
                maxLines: 1,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xff121212)),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                sharedUserNames ?? '',
                maxLines: 1,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 9,
                    color: Color(0xff121212).withOpacity(0.5)),
              ),
            ],
          )),
          InkWell(
            onTap: () {
              btnDeleteClicked?.call();
            },
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(6),
              child: SvgPicture.asset(
                AssetImages.delete,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}
