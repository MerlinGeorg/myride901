import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/features/auth/widget/autho_textformfield.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/widgets/flat_button.dart';

class AddNewWalletDialog extends StatefulWidget {
  final String label;
  final String btnText;
  final String labelText;
  final String valueText;
  final Function()? onCancel;
  final Function(String, String)? onAdd;
  final bool isEditLabel;
  const AddNewWalletDialog(
      {this.label = "Title",
      this.btnText = 'ADD',
      this.onCancel,
      this.onAdd,
      this.labelText = '',
      this.valueText = '',
      this.isEditLabel = true});

  @override
  _AddNewWalletDialogState createState() => _AddNewWalletDialogState();
}

class _AddNewWalletDialogState extends State<AddNewWalletDialog> {
  TextEditingController _addValueTextEditController = TextEditingController();
  TextEditingController _addLabelTextEditController = TextEditingController();

  @override
  void initState() {
    _addValueTextEditController = TextEditingController(text: widget.valueText);
    _addLabelTextEditController = TextEditingController(text: widget.labelText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      elevation: 0,
      backgroundColor: Colors.black.withOpacity(0.5),
      child: contentBox(context),
    );
  }

  bool checkValidation() {
    if (Validation.checkIsEmpty(
        textEditingController: _addLabelTextEditController,
        msg: StringConstants.pleaseEnterLabel)) {
      return false;
    } else {
      return true;
    }
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Text(
                widget.label,
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              if (widget.btnText == 'ADD')
                AuthoTextFormField(
                  hintText: StringConstants.hint_add_label,
                  textEditingController: _addLabelTextEditController,
                  textInputAction: TextInputAction.next,
                  isPrefixIcon: false,
                  enable: widget.isEditLabel,
                ),
              if (widget.btnText == 'ADD')
                SizedBox(
                  height: 12,
                ),
              AuthoTextFormField(
                hintText: StringConstants.hint_add_value,
                textEditingController: _addValueTextEditController,
                textInputAction: TextInputAction.done,
                isPrefixIcon: false,
              ),
              SizedBox(
                height: 42,
              ),
              Row(
                children: [
                  Expanded(
                    child: MyRideFlatButton(
                      onPress: () {
                        widget.onCancel?.call();
                      },
                      text: StringConstants.cancel,
                    ),
                  ),
                  Expanded(
                    child: BlueButton(
                        text: widget.btnText,
                        onPress: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (checkValidation()) {
                            widget.onAdd?.call(
                                _addValueTextEditController.text.toString(),
                                _addLabelTextEditController.text.toString());
                          }
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
