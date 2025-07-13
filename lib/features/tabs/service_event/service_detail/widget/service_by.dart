import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';

class ServiceBy extends StatelessWidget {
  final String? name;
  final String? email;
  final String? phone;

  const ServiceBy({Key? key, this.name, this.email, this.phone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SvgPicture.asset(AssetImages.ellipse_red),
              SizedBox(
                width: 15,
              ),
              Text(
                StringConstants.service_by,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.5,
                    color: AppTheme.of(context).primaryColor),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xff0C1248),
              child: Text(
                name![0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              name?.toUpperCase() ?? '',
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xff121212)),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email ?? '',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xff121212)),
                ),
                Text(
                  phone ?? '',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xff121212)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
