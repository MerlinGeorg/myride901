import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/core/themes/app_theme.dart';

class EventList extends StatelessWidget {
  final List<VehicleService>? list;
  final Function? onFullTimelinePress;
  final VehicleProfile? vehicleProfile;
  final Function? onTap;

  const EventList(
      {Key? key,
      this.list,
      this.onFullTimelinePress,
      this.vehicleProfile,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: (list ?? []).length,
        itemBuilder: (_, index) {
          return EventListItem(
            title: list![index].title ?? '',
            onTap: () {
              onTap?.call(index);
            },
            mileage: (list![index].mileage ?? '') +
                ' ' +
                ((list![index].mileage ?? '') == ''
                    ? ''
                    : ((vehicleProfile?.mileageUnit ?? '') == 'mile'
                        ? 'mi'
                        : 'km')),
            date: list![index].serviceDate ?? '',
            pic: (list![index].avatar == null || list![index].avatar == '')
                ? '1'
                : (list![index].avatar ?? ''),
            price: ((vehicleProfile?.isMyVehicle ?? 0) == 0)
                ? ''
                : list![index].totalPrice ?? '',
            currency: vehicleProfile?.currency,
          );
        });
  }
}

class EventListItem extends StatelessWidget {
  final String? pic;
  final String? title;
  final String? mileage;
  final String? date;
  final String? currency;
  final String? price;
  final Function? onTap;

  const EventListItem(
      {Key? key,
      this.pic,
      this.currency,
      this.onTap,
      this.title,
      this.mileage,
      this.date,
      this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: InkWell(
        onTap: () {
          onTap!();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 70,
                height: 70,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                        offset: Offset(1, 3)),
                  ],
                  border: Border.all(
                    width: 2,
                    color: Color(0xffEEEEEE),
                    style: BorderStyle.solid,
                  ),
                  color: Color(0xFFCCD4EB).withOpacity(0.2),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/new/avatar_type/$pic.svg',
                    width: 25,
                    height: 25,
                  ),
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff121212)),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    mileage ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xff121212).withOpacity(0.6)),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    date ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xffAAAAAA)),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            if (price != '')
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppTheme.of(context).primaryColor.withOpacity(0.2)),
                child: Text(
                  '$currency $price',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: AppTheme.of(context).primaryColor),
                ),
              ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}