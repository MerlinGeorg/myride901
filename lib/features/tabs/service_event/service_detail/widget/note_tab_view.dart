import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';

class NoteTabView extends StatelessWidget {
  final TextEditingController? textEditingController;
  final Function? onSave;
  final bool isEdit;
  final bool value;
  final FocusNode? focus;

  const NoteTabView(
      {Key? key,
      this.textEditingController,
      this.onSave,
      this.isEdit = false,
      this.value = false,
      this.focus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: focus,
                  maxLines: 1000,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: Colors.black,
                  controller: textEditingController,
                  readOnly: value,
                  onFieldSubmitted: (str) {},
                  enabled: isEdit,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppTheme.of(context).primaryColor,
                            width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(208, 208, 208, 1),
                            width: 1.0),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(208, 208, 208, 1),
                            width: 1.0),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      //  filled: true,
                      hintStyle: GoogleFonts.roboto(
                          color: Color(0xff121212).withOpacity(0.2)),
                      hintText: StringConstants.add_notes_about,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 10.0),
                      fillColor: Colors.white70),
                ),
              ),
              if (isEdit)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: BlueButton(
                      text: StringConstants.save,
                      onPress: () {
                        onSave?.call();
                      }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
