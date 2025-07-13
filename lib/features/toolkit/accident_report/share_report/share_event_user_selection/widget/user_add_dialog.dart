import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/features/auth/widget/autho_textformfield.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/widgets/flat_button.dart';

class UserAddDialog extends StatefulWidget {
  final String label;
  final String btnText;
  final Function()? onCancel;
  final Function(String)? onAdd;

  const UserAddDialog(
      {this.label = "Title", this.btnText = 'ADD', this.onCancel, this.onAdd});

  @override
  _UserAddDialogState createState() => _UserAddDialogState();
}

class _UserAddDialogState extends State<UserAddDialog> {
  TextEditingController _userEmailEditingController = TextEditingController();

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
        textEditingController: _userEmailEditingController,
        msg: StringConstants.pleaseEnterEmail)) {
      return false;
    } else if (Validation.isNotValidEmail(
        textEditingController: _userEmailEditingController)) {
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
              AuthoTextFormField(
                hintText: StringConstants.hint_enter_email,
                textEditingController: _userEmailEditingController,
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
                                _userEmailEditingController.text.toString());
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
