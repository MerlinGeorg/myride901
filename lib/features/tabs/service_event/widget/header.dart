import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/my_ride_dropdown.dart';
import 'package:myride901/widgets/user_picture.dart';

class Header extends StatefulWidget {
  final TextEditingController? textEditingController;
  final List<VehicleProfile>? vehicleList;
  final int? selectedVehicle;
  final Function(int)? onVehicleSelect;
  final bool? isEdit;
  const Header(
      {Key? key,
      this.textEditingController,
      this.vehicleList,
      this.selectedVehicle,
      this.onVehicleSelect,
      this.isEdit = false})
      : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  AppThemeState _appTheme = AppThemeState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25,
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: UserPicture(
              fontSize: 28,
              size: Size(74, 74),
              text: widget.vehicleList!.isNotEmpty? widget.vehicleList![widget.selectedVehicle ?? 0].Nickname! :"",
              userPicture: widget.vehicleList!.isNotEmpty? Utils.getProfileImage(
                  widget.vehicleList?[widget.selectedVehicle ?? 0]) : "",
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  StringConstants.vehicle,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: _appTheme.primaryColor.withOpacity(0.8),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                (widget.isEdit ?? false)
                    ? Text(
                        (widget.vehicleList ?? [])[widget.selectedVehicle ?? 0]
                                .Nickname ??
                            '',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: _appTheme.primaryColor,
                        ),
                      )
                    : MyRideDropdown(
                        dropdownMenuItemList: (widget.vehicleList ?? [])
                            .map<DropdownMenuItem<VehicleProfile>>(
                                (VehicleProfile value) {
                          return DropdownMenuItem<VehicleProfile>(
                            value: value,
                            child: Text(value.Nickname ?? ''),
                          );
                        }).toList(),
                        onChanged: (dynamic newValue) {
                          for (int i = 0;
                              i < (widget.vehicleList ?? []).length;
                              i++) {
                            if ((widget.vehicleList ?? [])[i] == newValue &&
                                i != widget.selectedVehicle) {
                              widget.onVehicleSelect?.call(i);
                            }
                          }
                        },
                        value: widget.vehicleList!.isNotEmpty? widget.vehicleList![widget.selectedVehicle ?? 0]:null,
                        isEnabled: true,
                      ),
              ],
            ),
          ),
          SizedBox(
            width: 25,
          ),
        ],
      ),
    );
  }
}
