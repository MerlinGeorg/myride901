import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/user_picture.dart';

class VehicleHeader extends StatelessWidget {
  final String vehicleName;
  final String vehicleImage;
  final Function()? onVehicleDropDownClick;
  final Function()? onDrawerClick;
  final Function()? onImageClick;

  const VehicleHeader(
      {Key? key,
      this.vehicleName = '',
      this.onVehicleDropDownClick,
      this.vehicleImage = '',
      this.onDrawerClick,
      this.onImageClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _appTheme = AppTheme.of(context);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            tileMode: TileMode.clamp,
            colors: [
              _appTheme.primaryColor,
              _appTheme.primaryColor,
              vehicleName == '' ? _appTheme.primaryColor : Color(0xffD03737)
            ],
          )),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        onDrawerClick?.call();
                      },
                      child: RotatedBox(
                          quarterTurns: 90,
                          child: SvgPicture.asset(AssetImages.drawer))),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Text(
                    'Vehicle',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white),
                  )),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              if (vehicleName != '')
                SizedBox(
                  height: 30,
                ),
              if (vehicleName != '')
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                onImageClick?.call();
                              },
                              child: UserPicture(
                                  userPicture: vehicleImage,
                                  fontSize: 24,
                                  whiteBg: true,
                                  size: Size(100, 100),
                                  text: vehicleName.length > 0
                                      ? vehicleName
                                          .substring(0, 1)
                                          .toUpperCase()
                                      : vehicleName.toUpperCase()),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    onImageClick?.call();
                                  },
                                  child: SvgPicture.asset(
                                    AssetImages.camera_icon,
                                    width: 25,
                                    height: 25,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        vehicleName,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          onVehicleDropDownClick?.call();
                        },
                        child: Text(
                          'Switch Vehicle',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              if (vehicleName != '')
                SizedBox(
                  height: 10,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class OverlapItem extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final bool hasIconPadding;

  const OverlapItem(
      {Key? key,
      this.icon = '',
      this.title = '',
      this.value = '',
      this.hasIconPadding = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          width: hasIconPadding ? 20 : 24,
          height: hasIconPadding ? 20 : 24,
          color: Color(0xff121212).withOpacity(0.4),
        ),
        SizedBox(
          width: hasIconPadding ? 19 : 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 0.5,
                  color: AppTheme.of(context).primaryColor),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: 0.5,
                  color: Color(0xff121212).withOpacity(0.4)),
            )
          ],
        )
      ],
    );
  }
}
