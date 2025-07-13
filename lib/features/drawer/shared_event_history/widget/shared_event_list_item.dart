import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';

class SharedItemListItem extends StatelessWidget {
  final VehicleService? vehicleService;
  final Function()? onRevokeClick;
  final Function()? onEditPress;

  const SharedItemListItem(
      {Key? key, this.vehicleService, this.onRevokeClick, this.onEditPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                  offset: Offset(-3, 5)),
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: Color(0xffCCD4EB).withOpacity(0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicleService?.serviceDate ?? '',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color:
                            AppTheme.of(context).primaryColor.withOpacity(0.6)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    (vehicleService?.vehicleName ?? '') +
                        ' - ' +
                        (vehicleService?.title ?? ''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppTheme.of(context).primaryColor),
                  )
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          StringConstants.edit_permission,
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: AppTheme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringConstants.shared_with,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color(0xff121212).withOpacity(0.7)),
                          ),
                          if ((vehicleService?.servicePermissions ?? [])
                                  .length >
                              0)
                            Text(
                              '${(vehicleService?.servicePermissions ?? [])[0].userEmail} ${(vehicleService?.servicePermissions ?? []).length > 1 ? 'and ' : ''} ${(vehicleService?.servicePermissions ?? []).length > 1 ? (vehicleService?.servicePermissions ?? []).length - 1 : ''} ${(vehicleService?.servicePermissions ?? []).length > 1 ? 'others ' : ''}',
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Color(0xff121212).withOpacity(0.7)),
                            ),
                        ],
                        mainAxisSize: MainAxisSize.min,
                      )),
                      InkWell(
                        onTap: () {
                          onEditPress?.call();
                        },
                        child: SvgPicture.asset(
                          AssetImages.edit,
                          width: 25,
                          height: 25,
                          color: AppTheme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: BorderSide(
                          width: 1, color: AppTheme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      onRevokeClick?.call();
                    },
                    child: Text(
                      StringConstants.revoke.toUpperCase(),
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                          color: AppTheme.of(context).primaryColor),
                    ),
                  ),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            )
          ],
        ));
  }
}

class EnableDisableButton extends StatelessWidget {
  final bool? isEnable;
  final Function()? onPress;

  const EnableDisableButton({Key? key, this.isEnable, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress?.call();
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          decoration: BoxDecoration(
            color: isEnable!
                ? Color(0xff00B871).withOpacity(0.2)
                : Color(0xffD03737).withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            isEnable! ? StringConstants.enabled : StringConstants.disabled,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 10,
                color: isEnable! ? Color(0xff00B871) : Color(0xffD03737)),
          )),
    );
  }
}
