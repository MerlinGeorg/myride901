import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';

class VerticalStrip extends StatelessWidget {
  final String title;
  final String prefillIcon;
  final String value;
  final TextEditingController? textEditingController;
  final bool isEditable;
  final bool isPrefix;
  final String prefixText;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;

  const VerticalStrip({
    Key? key,
    this.title = '',
    this.prefillIcon = '',
    this.value = '',
    this.textEditingController,
    this.isEditable = false,
    this.isPrefix = false,
    this.prefixText = '',
    this.keyboardType,
    this.textCapitalization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Row(
        children: [
          SvgPicture.asset(
            prefillIcon,
            width: 20,
            height: 20,
            color: Color(0xffD03737),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: GoogleFonts.roboto(
                color: AppTheme.of(context).primaryColor,
                fontWeight: FontWeight.w400,
                fontSize: 13),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              controller: textEditingController,
              keyboardType:
                  keyboardType == null ? TextInputType.number : keyboardType,
              inputFormatters:
                  keyboardType == null ? [CustomTextInputFormatter()] : [],
              readOnly: !isEditable,
              textCapitalization: TextCapitalization.sentences,
              cursorColor: AppThemeState().primaryColor,
              decoration: InputDecoration(
                  prefix: isPrefix
                      ? Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Text(
                            prefixText,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: AppTheme.of(context).primaryColor),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  //  filled: true,
                  hintStyle: GoogleFonts.roboto(
                      color: Color(0xff121212).withOpacity(0.2)),
                  fillColor: Colors.white70),
              maxLines: 1,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: AppTheme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
