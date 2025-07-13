import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myride901/core/themes/app_theme.dart';

class VehicleTextField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final String? hintText;
  final FocusNode? focusNode;
  final bool hasSuffixIcon;
  final Function? onFieldSubmitted;
  final Function? onSuffixIconClick;
  final Function? onTap;
  final TextInputType? textInputType;
  final Function? onChanged;
  final dynamic inputFormatters;
  final dynamic suffixIcon;
  final String? suffixText;
  final String? labelText;
  final TextStyle? suffixStyle;
  final TextStyle? labelStyle;
  final bool readOnly;
  final bool isPrefix;
  final String prefixText;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  const VehicleTextField(
      {Key? key,
      this.textEditingController,
      this.hintText = "",
      this.textCapitalization,
      this.onChanged,
      this.suffixStyle,
      this.hasSuffixIcon = false,
      this.onSuffixIconClick,
      this.readOnly = false,
      this.isPrefix = false,
      this.prefixText = '',
      this.labelStyle,
      this.focusNode,
      this.labelText,
      this.onFieldSubmitted,
      this.textInputType = TextInputType.name,
      this.inputFormatters,
      this.textInputAction,
      this.onTap,
      this.suffixText,
      this.suffixIcon})
      : super(key: key);

  @override
  _VehicleTextFieldState createState() => _VehicleTextFieldState();
}

class _VehicleTextFieldState extends State<VehicleTextField> {
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) widget.onTap?.call();
      },
      child: TextFormField(
        inputFormatters:
            widget.inputFormatters == null ? [] : widget.inputFormatters,
        enabled: widget.onTap == null,
        keyboardType: widget.textInputType,
        onChanged: (str) {
          if (widget.onChanged != null) {
            widget.onChanged!.call(str);
          }
        },
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization == null
            ? TextCapitalization.sentences
            : widget.textCapitalization!,
        cursorColor: Colors.black,
        controller: widget.textEditingController,
        focusNode: widget.focusNode,
        onFieldSubmitted: (str) {
          if (widget.onFieldSubmitted != null) {
            widget.onFieldSubmitted?.call(str);
          }
        },
        decoration: InputDecoration(
            prefix: widget.isPrefix
                ? Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      widget.prefixText,
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: AppTheme.of(context).primaryColor),
                    ),
                  )
                : null,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _appTheme.primaryColor, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            suffixText: widget.suffixText,
            suffixStyle: widget.suffixStyle,
            suffixIcon: widget.hasSuffixIcon
                ? InkWell(
                    onTap: () {
                      widget.onSuffixIconClick!.call();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: (widget.suffixIcon is String)
                          ? SvgPicture.asset(
                              widget.suffixIcon,
                              color: Color(0xff121212).withOpacity(0.2),
                            )
                          : widget.suffixIcon,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromRGBO(208, 208, 208, 1), width: 1.0),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromRGBO(208, 208, 208, 1), width: 1.0),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            //  filled: true,
            hintStyle:
                GoogleFonts.roboto(color: Color(0xff121212).withOpacity(0.2)),
            hintText: widget.hintText,
            labelText: widget.labelText,
            labelStyle: widget.labelStyle,
            contentPadding:
                new EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
            fillColor: Colors.white70),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: (newValue.text).toUpperCase(),
      selection: newValue.selection,
    );
  }
}
