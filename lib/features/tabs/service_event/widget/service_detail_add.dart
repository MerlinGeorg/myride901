import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';

class ServiceDetailAdd extends StatelessWidget {
  final List<Details>? serviceDetail;
  final bool? isMore;
  final Function? onServiceActionPress;
  final bool isScanner;
  final VehicleProfile? vehicleProfile;

  const ServiceDetailAdd(
      {Key? key,
      this.serviceDetail,
      this.isMore,
      this.isScanner = false,
      this.onServiceActionPress,
      this.vehicleProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isScanner == false)
            Row(
              children: [
                SvgPicture.asset(AssetImages.ellipse_red),
                SizedBox(
                  width: 15,
                ),
                Text(
                  StringConstants.service_details,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      letterSpacing: 0.5,
                      color: AppTheme.of(context).primaryColor),
                )
              ],
            ),
          if (isScanner == true)
            Text(
              'Verify extracted data',
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.5,
                  color: AppTheme.of(context).primaryColor),
            ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              if ((serviceDetail ?? []).isEmpty) ...[
                SizedBox(
                  height: 20,
                ),
                SvgPicture.asset(AssetImages.add_note),
                SizedBox(
                  height: 15,
                ),
                Text(
                  StringConstants.list_describe_about_the_service,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xff121212)),
                ),
              ],
              if ((serviceDetail ?? []).isNotEmpty)
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: (serviceDetail ?? []).length,
                    itemBuilder: (_, index) {
                      return Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          (serviceDetail ?? [])[index]
                                                  .categoryName ??
                                              '',
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: AppTheme.of(context)
                                                  .primaryColor),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        if ((vehicleProfile?.isMyVehicle ??
                                                0) ==
                                            1)
                                          Flexible(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: AppTheme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.2)),
                                              child: Text(
                                                '${vehicleProfile!.currency} ${(serviceDetail ?? [])[index].price ?? ''}',
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    color: AppTheme.of(context)
                                                        .primaryColor),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      onServiceActionPress?.call('edit', index);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SvgPicture.asset(
                                        AssetImages.edit,
                                        color:
                                            AppTheme.of(context).primaryColor,
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      onServiceActionPress?.call(
                                          'delete', index);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SvgPicture.asset(
                                        AssetImages.delete_bg,
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      ((serviceDetail ?? [])[index]
                                              .description ??
                                          ''),
                                      style: GoogleFonts.roboto(
                                          height: 1.5,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Color(0xff121212)
                                              .withOpacity(0.7)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                height: 1,
                              )
                            ],
                          ));
                    })
            ],
          )
        ],
      ),
    );
  }
}
