import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyRideFlatButton extends StatelessWidget {
  final Function()? onPress;
  final String? text;
  final double height;
  final double width;

  const MyRideFlatButton(
      {Key? key, this.onPress, this.text, this.height = 50, this.width = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress!.call();
      },
      child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              text ?? '',
              style: GoogleFonts.roboto(
                  color: Color(0xff121212).withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 1),
            ),
          )),
    );
  }
}
