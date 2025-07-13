import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';

class ServiceDetails extends StatelessWidget {
  final List<Details>? serviceList;
  final VehicleProfile? vehicleProfile;
  const ServiceDetails({Key? key, this.serviceList, this.vehicleProfile})
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
                StringConstants.service_details,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.5,
                    color: AppTheme.of(context).primaryColor),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: (serviceList ?? []).length,
              itemBuilder: (_, index) {
                return Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              serviceList?[index].categoryName ?? '',
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppTheme.of(context).primaryColor),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            if ((vehicleProfile?.isMyVehicle ?? 0) == 1)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppTheme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2)),
                                child: Text(
                                  '${vehicleProfile!.currency ?? ''} ${serviceList?[index].price ?? ''}',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: AppTheme.of(context).primaryColor),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                serviceList?[index].description ?? '',
                                style: GoogleFonts.roboto(
                                    height: 1.5,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xff121212).withOpacity(0.7)),
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
      ),
    );
  }
}
