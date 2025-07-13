import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myride901/core/themes/app_theme.dart';

class LabeledTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final bool isEnabled;
  final TextStyle? textStyle;
  final StreamController<String>? errorStream;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmit;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final bool? isGrayed;
  final Function? onTextChange;

  LabeledTextField(this.textEditingController, this.label,
      {this.isEnabled = true,
      this.textStyle,
      this.errorStream,
      this.focusNode,
      this.onSubmit,
      this.textInputAction,
      this.isGrayed,
      this.textInputType,
      this.onTextChange});

  @override
  Widget build(BuildContext context) {
    return errorStream == null
        ? _getTextFieldWidget(context)
        : StreamBuilder<String>(
            initialData: "",
            stream: errorStream!.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return _getTextFieldWidget(context, error: snapshot.data);
            },
          );
  }

  Widget _getTextFieldWidget(BuildContext _context, {String error = ""}) {
    final _appTheme = AppTheme.of(_context);
    bool isGrayColored = isGrayed != null ? isGrayed! : !isEnabled;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          label,
          style: _appTheme.informationDescriptionTextStyle,
        ),
        Container(
          height: _appTheme.getResponsiveHeight(100),
          child: TextField(
            focusNode: this.focusNode,
            onSubmitted: this.onSubmit,
            enabled: isEnabled,
            style: textStyle == null
                ? isGrayColored
                    ? _appTheme.customerReferenceTextFieldTextStyle
                    : _appTheme.featureTextStyle
                : textStyle,
            controller: textEditingController,
            textInputAction: textInputAction,
            keyboardType: textInputType,
            textAlignVertical: TextAlignVertical.top,
            onChanged: (value) {
              if (errorStream != null) {
                errorStream!.sink.add("");
              }
              if (onTextChange != null) {
                onTextChange!(value);
              }
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: _appTheme.sliderColor,
                      width: _appTheme.getResponsiveHeight(3))),
              enabledBorder: isEnabled
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: _appTheme.sliderColor,
                          width: _appTheme.getResponsiveHeight(3)))
                  : InputBorder.none,
              focusedBorder: isEnabled
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: _appTheme.blackColor,
                          width: _appTheme.getResponsiveHeight(3)))
                  : InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: _appTheme.getResponsiveHeight(5)),
        error.isNotEmpty
            ? Text(
                error,
                style: _appTheme.errorFieldTextStyle,
              )
            : Offstage(),
      ],
    );
  }
}
