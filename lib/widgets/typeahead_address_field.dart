import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';

class TypeAheadAddressField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onSelected;
  final FutureOr<List<String>?> Function(String) suggestionsCallback;
  final String hintText;
  final String labelText;
  final BorderRadius? borderRadius;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Color hintTextColor;
  final Color labelTextColor;
  final Color fillColor;
  final EdgeInsetsGeometry contentPadding;

  const TypeAheadAddressField({
    this.controller,
    this.onSelected,
    required this.suggestionsCallback,
    this.hintText = 'Address',
    this.labelText = 'Address',
    this.borderRadius,
    this.focusedBorderColor = Colors.blue,
    this.enabledBorderColor = const Color.fromRGBO(208, 208, 208, 1),
    this.hintTextColor = const Color(0xff121212),
    this.labelTextColor = const Color(0xff121212),
    this.fillColor = Colors.white70,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      controller: controller,
      builder: (context, controller, focusNode) {
        return TextField(
          focusNode: focusNode,
          controller: controller,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: focusedBorderColor,
                width: 1.0,
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: enabledBorderColor,
                width: 1.0,
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: enabledBorderColor,
                width: 1.0,
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(10.0),
            ),
            hintStyle: GoogleFonts.roboto(
              color: hintTextColor.withOpacity(0.2),
            ),
            hintText: hintText,
            labelText: labelText,
            labelStyle: GoogleFonts.roboto(
              color: labelTextColor.withOpacity(0.7),
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            contentPadding: contentPadding,
            fillColor: fillColor,
          ),
        );
      },
      suggestionsCallback: suggestionsCallback,
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSelected: onSelected,
    );
  }
}
