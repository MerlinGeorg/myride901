import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/trip/trip.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';

class TripListView extends StatelessWidget {
  final List<Trip>? list;
  final Trip? trip;
  final Function? btnEditClicked;
  final Function? btnDeleteClicked;
  final String? currency;

  const TripListView({
    Key? key,
    this.list,
    this.trip,
    this.currency,
    this.btnDeleteClicked,
    this.btnEditClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list?.length ?? 0,
      itemBuilder: (_, index) {
        return TripListItem(
          startLocation: list?[index].startLocation,
          endLocation: list?[index].endLocation,
          startDate: list?[index].startDate,
          distance: list?[index].totalDistance,
          earnings: list?[index].earnings,
          mileageUnit: list?[index].mileageUnit,
          currency: currency,
          endDate: list?[index].endDate,
          btnDeleteClicked: () {
            btnDeleteClicked?.call(index);
          },
          btnEditClicked: () {
            btnEditClicked?.call(index);
          },
        );
      },
    );
  }
}

class TripListItem extends StatelessWidget {
  final String? startLocation;
  final String? endLocation;
  final String? startDate;
  final String? distance;
  final String? mileageUnit;
  final String? earnings;
  final String? currency;
  final String? endDate;
  final Function()? btnEditClicked;
  final Function()? btnDeleteClicked;

  const TripListItem({
    Key? key,
    this.startLocation,
    this.endLocation,
    this.earnings,
    this.distance,
    this.mileageUnit,
    this.startDate,
    this.endDate,
    this.currency,
    this.btnEditClicked,
    this.btnDeleteClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          endDate != null
                              ? '$startDate - $endDate'
                              : '$startDate',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xff121212),
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          startLocation != null && endLocation != null
                              ? '$startLocation - $endLocation'
                              : '',
                          maxLines: 3, // Allow up to 2 lines
                          overflow: TextOverflow.visible,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff121212),
                          ),
                        ),
                        SizedBox(height: 7),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 7,
                          children: [
                            Text(
                              distance != null
                                  ? 'Distance: $distance ' +
                                      (mileageUnit == "mile" ? 'mi' : 'km')
                                  : '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff121212),
                              ),
                            ),
                            Text(
                              earnings != null
                                  ? 'Total Amount: $currency$earnings'
                                  : '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff121212),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      Container(
                        height: 35,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              btnEditClicked!();
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: AppTheme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                AssetImages.edit_b,
                                width: 13,
                                height: 1,
                                color: AppTheme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 35,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              Utils.showAlertDialogCallBack1(
                                context: context,
                                title: StringConstants.delete_trip_popup_title,
                                message:
                                    StringConstants.delete_trip_popup_message,
                                isConfirmationDialog: false,
                                isOnlyOK: false,
                                navBtnName: StringConstants.cancel,
                                posBtnName:
                                    StringConstants.delete.toUpperCase(),
                                onNavClick: () => {},
                                onPosClick: () {
                                  btnDeleteClicked!();
                                },
                              );
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              padding: const EdgeInsets.all(6),
                              child: SvgPicture.asset(
                                AssetImages.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
