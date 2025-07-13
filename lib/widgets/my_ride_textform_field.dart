import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/themes/app_theme.dart';

class MyRideTextFormField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final String hintText;
  final bool hasSuffixIcon;
  final bool isSVG;
  final FocusNode? focusNode;
  final Function? onFieldSubmitted;
  final dynamic suffixIcon;
  final Function? onSuffixIconClick;
  final Function? onClick;
  final Function? onChanged;
  final VoidCallback onEditingComplete;
  final TextInputType textInputType;
  final bool readOnly;
  final bool isLabel;
  final dynamic ifs;
  final int maxLine;
  final int maxText;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final int? minLine;
  final Color textColor;

  static _onEditingComplete() {}

  const MyRideTextFormField(
      {Key? key,
      this.textEditingController,
      this.hintText = "",
      this.hasSuffixIcon = false,
      this.isSVG = true,
      this.focusNode,
      this.onFieldSubmitted,
      this.suffixIcon,
      this.onChanged,
      this.onEditingComplete = _onEditingComplete,
      this.minLine,
      this.onSuffixIconClick,
      this.onClick,
      this.textInputType = TextInputType.text,
      this.readOnly = false,
      this.ifs,
      this.maxLine = 1,
      this.maxText = 30,
      this.isLabel = true,
      this.textCapitalization,
      this.textColor = Colors.black,
      this.textInputAction})
      : super(key: key);

  @override
  _MyRideTextFormFieldState createState() => _MyRideTextFormFieldState();
}

class _MyRideTextFormFieldState extends State<MyRideTextFormField> {
  bool obscureText = false;
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (widget.onClick != null) {
      return InkWell(onTap: () => widget.onClick!.call(), child: field(width));
    } else {
      return field(width);
    }
  }

  field(double width) {
    return TextFormField(
      maxLength: widget.maxText,
      textInputAction: widget.textInputAction,
      readOnly: widget.readOnly,
      cursorColor: Colors.black,
      textCapitalization: widget.textCapitalization == null
          ? TextCapitalization.sentences
          : widget.textCapitalization!,
      enabled: widget.onClick == null,
      minLines: widget.minLine ?? 1,
      maxLines: widget.maxLine,
      keyboardType: widget.textInputType,
      controller: widget.textEditingController,
      focusNode: widget.focusNode,
      style: TextStyle(color: widget.textColor),
      inputFormatters: widget.ifs == null ? [] : widget.ifs,
      onChanged: (str) {
        if (widget.onChanged != null) {
          widget.onChanged!.call(str);
        }
      },
      onFieldSubmitted: (str) {
        if (widget.onFieldSubmitted != null) {
          widget.onFieldSubmitted!(str);
        }
      },
      onEditingComplete: widget.onEditingComplete,
      decoration: InputDecoration(
        counterText: "",
        filled: true,
        fillColor: Colors.white,
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
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
          borderSide:
              BorderSide(color: Color(0xff121212).withOpacity(0.2), width: 0.0),
        ),
        hintText: widget.isLabel ? null : widget.hintText,
        labelText: widget.isLabel ? widget.hintText : null,
        labelStyle: GoogleFonts.roboto(
            color:
                /* widget.focusNode.hasFocus
                  ? _appTheme.primaryColor
                  :*/
                Color(0xff121212).withOpacity(0.7),
            fontWeight: FontWeight.w400,
            fontSize: width * .035),
        hintStyle: GoogleFonts.roboto(
            color:
                /* widget.focusNode.hasFocus
                  ? _appTheme.primaryColor
                  :*/
                Colors.grey.withOpacity(0.2),
            fontWeight: FontWeight.w400,
            fontSize: 12),
        // hintText: widget.hintText,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _appTheme.primaryColor, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      ),
      autofocus: false,
    );
  }
}
