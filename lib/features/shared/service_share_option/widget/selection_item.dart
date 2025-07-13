import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myride901/core/themes/app_theme.dart';

class SelectionItem extends StatelessWidget {
  final bool isSelected;
  final String icon;
  final String text;

  const SelectionItem(
      {Key? key,
       this.isSelected = false,
       this.icon = '',
       this.text = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boxSize = MediaQuery.of(context).size.width * 0.5 - 40;
    return Container(
      width: boxSize,
      child: Column(

        children: [
          Container(
              height: boxSize,
              width: boxSize,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: isSelected
                          ? AppTheme.of(context).primaryColor
                          : Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: isSelected
                            ? AppTheme.of(context).primaryColor.withOpacity(0.5)
                            : Colors.transparent,
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                        offset: Offset(9, 10)),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child: SvgPicture.asset(icon),
              )),
          SizedBox(
            height: 20,
          ),
          Text(
            text,textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                color: Colors.black, fontWeight: FontWeight.w400,fontSize: 16),
          )
        ],
      ),
    );
  }
}
