import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/event_gallery.dart';
import 'package:myride901/features/tabs/service_event/service_detail/widget/service_by.dart';
import 'package:myride901/features/tabs/service_event/service_detail/widget/service_detail.dart';
import 'event_details.dart';

class EventTabView extends StatelessWidget {
  final VehicleService? vehicleService;
  final VehicleProfile? vehicleProfile;
  final String? name;
  final String? email;
  final String? phone;

  final Function? onActionPress;

  const EventTabView(
      {Key? key,
      this.vehicleService,
      this.vehicleProfile,
      this.onActionPress,
      this.name,
      this.email,
      this.phone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        EventDetail(
          date: vehicleService?.serviceDate ?? '',
          event: vehicleService?.title ?? '',
          miles: (vehicleService?.mileage ?? '') +
              ' ' +
              ((vehicleService?.mileage ?? '') == ''
                  ? ''
                  : ((vehicleProfile?.mileageUnit ?? '') == 'mile'
                      ? 'mi'
                      : 'km')),
        ),
        Divider(height: 2, color: Colors.grey),
        vehicleService!.serviceProviderId == null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                ]))
            : ServiceBy(name: name, email: email, phone: phone),
        Divider(height: 2, color: Colors.grey),
        ServiceDetails(
          serviceList: vehicleService?.details ?? [],
          vehicleProfile: vehicleProfile!,
        ),
        Divider(height: 2, color: Colors.grey),
        EventGallery(
          isMore: ((vehicleProfile?.isMyVehicle == 1) ||
              (vehicleProfile?.isMyVehicle == 0 &&
                  (((vehicleService?.vehicleEdit ?? "0") == "1") ||
                      ((vehicleService?.serviceEdit ?? "0") == "1")))),
          onActionPress: onActionPress,
          action: false,
          attachmentList: vehicleService?.attachments ?? [],
        ),
      ],
    );
  }
}
