import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/core/themes/app_theme.dart';

class AuthoTextFormField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final String hintText;
  final String prefixIcon;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool isVisibleToggle;
  final bool isSVG;
  final FocusNode? focusNode;
  final Function? onFieldSubmitted;
  final bool isPrefixIcon;
  final bool enable;

  const AuthoTextFormField(
      {Key? key,
      this.textEditingController,
      this.hintText = "",
      this.prefixIcon = AssetImages.mail_2,
      this.obscureText = false,
      this.isVisibleToggle = false,
      this.isSVG = true,
      this.focusNode,
      this.textInputAction,
      this.enable = true,
      this.onFieldSubmitted,
      this.isPrefixIcon = true})
      : super(key: key);

  @override
  _AuthoTextFormFieldState createState() => _AuthoTextFormFieldState();
}

class _AuthoTextFormFieldState extends State<AuthoTextFormField> {
  bool obscureText = false;
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    obscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          const Radius.circular(10.0),
        ),
        color: widget.enable
            ? Colors.transparent
            : Color(0xff121212).withOpacity(0.1),
      ),
      child: TextFormField(
        cursorColor: Colors.black,
        obscureText: obscureText,
        controller: widget.textEditingController,
        focusNode: widget.focusNode,
        textCapitalization: TextCapitalization.sentences,
        enabled: widget.enable,
        onFieldSubmitted: (str) {
          if (widget.onFieldSubmitted != null) {
            widget.onFieldSubmitted?.call(str);
          }
        },
        decoration: InputDecoration(
          suffixIcon: widget.isVisibleToggle
              ? InkWell(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      obscureText ? AssetImages.eye_off : AssetImages.eye_on,
                      color: Color(0xff121212).withOpacity(0.2),
                    ),
                  ),
                )
              : null,
          prefixIcon: widget.isPrefixIcon
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: widget.isSVG
                      ? SvgPicture.asset(
                          widget.prefixIcon,
                          color: Color(0xff121212).withOpacity(0.2),
                          width: 20,
                          height: 20,
                        )
                      : Image.asset(
                          widget.prefixIcon,
                          color: Color(0xff121212).withOpacity(0.2),
                          width: 20,
                          height: 20,
                        ),
                )
              : null,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _appTheme.primaryColor, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
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
          label: Row(
            children: [
              RichText(
                  text: TextSpan(
                style: GoogleFonts.roboto(
                    color: Color(0xff121212).withOpacity(0.2)),
                text: widget.hintText,
              ))
            ],
          ),

          contentPadding:
              new EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          fillColor: Colors.white70,
        ),
      ),
    );
  }
}
