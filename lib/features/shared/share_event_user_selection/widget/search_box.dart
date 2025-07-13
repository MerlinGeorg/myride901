import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController? textEditingController;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final TextInputType? textInputType;

  const SearchBox(
      {Key? key,
       this.textEditingController,
       this.onSubmitted,this.onChanged,this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: () {
        onSubmitted?.call(textEditingController!.text);
      },
      onChanged: (str){
        onChanged?.call(str);
      },
      keyboardType: textInputType,

      cursorColor: Colors.black,
      controller: textEditingController,
      maxLines: 1,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              AssetImages.search,
              color: Color(0xff121212).withOpacity(0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.of(context).primaryColor, width: 1.0),
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
          hintStyle:
              GoogleFonts.roboto(color: Color(0xff121212).withOpacity(0.2)),
          hintText: StringConstants.search,
          contentPadding:
              new EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          fillColor: Colors.white70),
    );
  }
}
