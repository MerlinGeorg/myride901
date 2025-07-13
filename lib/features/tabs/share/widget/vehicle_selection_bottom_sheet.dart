import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/tabs/share/widget/own_vehical_list.dart';
import 'package:myride901/features/tabs/share/widget/shared_vehical_list.dart';

class VehicleSelectionBottomSheet extends StatefulWidget {
  final List<VehicleProfile>? arrVehicleProfile;
  final int? index;
  final Function(int)? onTap;
  final Function? btnDeleteClicked;
  final Function? btnAddVehicleProfileClicked;
  final bool? onlyMy;
  const VehicleSelectionBottomSheet(
      {Key? key,
      this.arrVehicleProfile,
      this.index = -1,
      this.onTap,
      this.onlyMy = false,
      this.btnAddVehicleProfileClicked,
      this.btnDeleteClicked})
      : super(key: key);
  @override
  _VehicleSelectionBottomSheetState createState() =>
      _VehicleSelectionBottomSheetState();
}

class _VehicleSelectionBottomSheetState
    extends State<VehicleSelectionBottomSheet>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  List<VehicleProfile> ownList = [];

  List<VehicleProfile> sharedVehicle = [];

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    (widget.arrVehicleProfile ?? []).forEach((element) {
      if (element.isMyVehicle == 0) {
        sharedVehicle.add(element);
      } else {
        ownList.add(element);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: (widget.onlyMy ?? false)
          ? Column(
              children: [
                SizedBox(height: 20),
                SvgPicture.asset(AssetImages.rounderLine),
                SizedBox(height: 40),
                ownList.length == 0
                    ? Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Container(
                            width: 240,
                            child: BlueButton(
                              text: 'Add Vehicle Profile',
                              onPress: () {
                                widget.btnAddVehicleProfileClicked?.call();
                              },
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: OwnVehicleList(
                          ownList: ownList,
                          selectedIndex: widget.index,
                          onPress: (value) {
                            widget.onTap?.call(value);
                          },
                        ),
                      ),
              ],
            )
          : Column(
              children: [
                SizedBox(height: 20),
                SvgPicture.asset(AssetImages.rounderLine),
                SizedBox(height: 40),
                TabBar(
                  unselectedLabelColor: Colors.black.withOpacity(0.5),
                  labelColor: AppTheme.of(context).primaryColor,
                  indicatorColor: AppTheme.of(context).primaryColor,
                  labelStyle: GoogleFonts.roboto(
                      fontSize: 12, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                      text: StringConstants.own,
                    ),
                    Tab(
                      text: StringConstants.shared,
                    )
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ownList.length == 0
                          ? Container(
                              alignment: Alignment.center,
                              child: Container(
                                width: 240,
                                child: BlueButton(
                                  text: 'Add Vehicle Profile',
                                  onPress: () {
                                    Navigator.pop(context);
                                    widget.btnAddVehicleProfileClicked?.call();
                                  },
                                ),
                              ),
                            )
                          : OwnVehicleList(
                              ownList: ownList,
                              selectedIndex: widget.index,
                              onPress: (value) {
                                widget.onTap?.call(value);
                              },
                            ),
                      SharedVehicleList(
                        sharedList: sharedVehicle,
                        onPress: (value) {
                          widget.onTap?.call(value + ownList.length);
                        },
                        selectedIndex: ownList.length - (widget.index ?? 0),
                        btnDeleteClicked: (value) {
                          widget.btnDeleteClicked?.call(value + ownList.length);
                        },
                      )
                    ],
                    controller: _tabController,
                  ),
                ),
              ],
            ),
    );
  }
}
