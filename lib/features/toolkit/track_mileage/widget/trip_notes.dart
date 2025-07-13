import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/themes/app_theme.dart';

class Notes extends StatelessWidget {
  final TextEditingController? txtNotes;
  Notes({Key? key, this.txtNotes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      controller: txtNotes,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
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
        hintText: null,
        alignLabelWithHint: true,
        labelText: 'Notes',
        labelStyle: GoogleFonts.roboto(
            color: Color(0xff121212).withOpacity(0.7),
            fontWeight: FontWeight.w400,
            fontSize: 15),
        hintStyle: GoogleFonts.roboto(
            color: Color(0xff121212).withOpacity(0.5),
            fontWeight: FontWeight.w400,
            fontSize: 12),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: AppTheme.of(context).primaryColor, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      ),
      autofocus: false,
    );
  }
}
