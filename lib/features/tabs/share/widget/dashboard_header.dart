import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/user_picture.dart';
import 'package:myride901/features/tabs/share/share_bloc.dart';
import 'package:myride901/features/drawer/shared_event_history/widget/vehicle_permission_bottom_sheet.dart';

class DashboardHeader extends StatefulWidget {
  final int vehicleId;
  final String? vehicleName;
  final String vehicleImage;
  final String years;
  final String events;
  final String data;
  final ShareBloc sharedEventBloc;
  final Function()? onVehicleDropDownClick;
  final Function()? onDrawerClick;

  const DashboardHeader(
      {Key? key,
      required this.vehicleId,
      required this.sharedEventBloc,
      this.vehicleName,
      this.years = '',
      this.events = '',
      this.onVehicleDropDownClick,
      this.vehicleImage = '',
      this.onDrawerClick,
      this.data = ''})
      : super(key: key);

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  @override
  Widget build(BuildContext context) {
    var _appTheme = AppTheme.of(context);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomRight,
        tileMode: TileMode.clamp,
        colors: [
          _appTheme.primaryColor,
          _appTheme.primaryColor,
          //Color(0xffD03737)
        ],
      )),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Container(
            height: 60,
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      widget.onDrawerClick?.call();
                    },
                    child: RotatedBox(
                        quarterTurns: 90,
                        child: SvgPicture.asset(AssetImages.drawer))),
                SizedBox(width: 20),
                Expanded(
                    child: Align(
                        alignment: Alignment(-0.3, 0),
                        child: Image.asset(
                          AssetImages.logo_l,
                          height: 34,
                        ))),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
          if (widget.vehicleName != null) SizedBox(height: 10),
          if (widget.vehicleName != null)
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      widget.onVehicleDropDownClick?.call();
                    },
                    child: Container(
                      //   height: 55,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          UserPicture(
                              userPicture: widget.vehicleImage,
                              fontSize: 18,
                              whiteBg: true,
                              size: Size(30, 30),
                              text: widget.vehicleName!.length > 0
                                  ? widget.vehicleName!
                                      .substring(0, 1)
                                      .toUpperCase()
                                  : widget.vehicleName!.toUpperCase()),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              widget.vehicleName!,
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Colors.white,
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white
                              .withOpacity(0.5), // red as border color
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    side: BorderSide(width: 1, color: Colors.white),
                  ),
                  onPressed: () async {
                    await widget.sharedEventBloc.getSharedVehiclePermission(
                        vehicleId: widget.vehicleId.toString());

                    openSheet(widget.vehicleId.toString());
                  },
                  child: Text(
                    StringConstants.edit_access.toUpperCase(),
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.0,
                        color: AppTheme.of(context).whiteColor),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    side: BorderSide(
                        width: 1, color: AppTheme.of(context).redColor),
                  ),
                  onPressed: () {
                    print("revoke all access");

                    Utils.showAlertDialogCallBack1(
                        context: context,
                        message:
                            'You are about to revoke access to this timeline from everyone',
                        isConfirmationDialog: false,
                        isOnlyOK: false,
                        navBtnName: 'Cancel',
                        posBtnName: 'Continue',
                        onNavClick: () {},
                        onPosClick: () {
                          print("widget vehicle id ${widget.vehicleId}");
                          widget.sharedEventBloc.revokeTimelinePermission(
                              context: context, vehicleId: widget.vehicleId);
                        });
                  },
                  child: Text(
                    StringConstants.revoke_access.toUpperCase(),
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.0,
                        color: AppTheme.of(context).redColor),
                  ),
                ),
              )
            ],
          ),
          if (widget.vehicleName != null) SizedBox(height: 20),
        ],
      ),
    );
  }

  void openSheet(String vehicleId) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return VehiclePermissionBottomSheet(
          userList: widget.sharedEventBloc.emailsVehiclePermission,
          editList: widget.sharedEventBloc.editVehiclePermission,
          onDone: (emails, permissions, deletedEmail) {
            widget.sharedEventBloc.updateVehiclePermission(
                vehicleId: vehicleId,
                emails: emails,
                permissions: permissions,
                emailToDelete: deletedEmail);
          },
        );
      },
    );
  }
}
