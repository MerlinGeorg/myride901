import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/tabs/home/home_bloc.dart';

class EventTabView extends StatefulWidget {
  final List<VehicleService>? list;
  final Function? onFullTimelinePress;
  final VehicleProfile? vehicleProfile;
  final Function? onTap;
  final HomeBloc? homeBloc;
  final TextEditingController? searchController;

  const EventTabView(
      {Key? key,
      this.list,
      this.onFullTimelinePress,
      this.vehicleProfile,
      this.homeBloc,
      this.searchController,
      this.onTap})
      : super(key: key);

  @override
  _EventTabViewState createState() => _EventTabViewState();
}

class _EventTabViewState extends State<EventTabView> {
  @override
  void dispose() {
    widget.searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: widget.searchController,
                  onChanged: (value) {
                    widget.homeBloc?.filterData(false, value);
                    widget.homeBloc?.isFilter = true;
                  },
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(CupertinoIcons.search),
                    hintText: "Search...",
                    suffixIcon: IconButton(
                      onPressed: () {
                        widget.homeBloc?.openSheetFilter(context: context);
                      },
                      icon: Icon(Icons.filter_list),
                      color: AppTheme.of(context).primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(15.0),
                        right: Radius.circular(15.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.of(context).primaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(15.0),
                        right: Radius.circular(15.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(15.0),
                        right: Radius.circular(15.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.list?.length,
            itemBuilder: (_, index) {
              return EventListItem(
                title: (widget.list ?? [])[index].title ?? '',
                onTap: () {
                  widget.onTap?.call(index);
                },
                mileage: ((widget.list ?? [])[index].mileage ?? '') +
                    ' ' +
                    (((widget.list ?? [])[index].mileage ?? '') == ''
                        ? ''
                        : ((widget.vehicleProfile?.mileageUnit ?? '') == 'mile'
                            ? 'mi'
                            : 'km')),
                date: (widget.list ?? [])[index].serviceDate ?? '',
                pic: ((widget.list ?? [])[index].avatar == null ||
                        (widget.list ?? [])[index].avatar == '')
                    ? '1'
                    : ((widget.list ?? [])[index].avatar ?? ''),
                price: ((widget.vehicleProfile?.isMyVehicle ?? 0) == 0)
                    ? ''
                    : (widget.list ?? [])[index].totalPrice ?? '',
                currency: widget.vehicleProfile?.currency,
              );
            }),
        if ((widget.list ?? []).length != 0)
          SizedBox(
            height: 30,
          ),
      ],
    );
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
            Container(
              height: 70,
              child: Center(
                child: SvgPicture.asset(
                  AssetImages.right_arrow,
                  height: 30,
                  width: 30,
                  color: AppTheme.of(context).primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmptyListItem extends StatelessWidget {
  final String? title;
  final SvgPicture? icon;

  const EmptyListItem({
    Key? key,
    this.title,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _appTheme = AppTheme.of(context);

    return Center(
      child: InkWell(
        onTap: () {
          AppComponentBase.getInstance()
              .getSharedPreference()
              .getSelectedVehicle()
              .then((value) {
            // Get all of the users current vehicles
            List<VehicleProfile> arrVehicle = Utils.arrangeVehicle(
                AppComponentBase.getInstance()
                    .getArrVehicleProfile(onlyMy: true),
                int.parse(value));

            // Find their current vehicle being used
            VehicleProfile? selectedVehicleProfile;
            int selectedVehicle = 0;
            for (int i = 0; i < arrVehicle.length; i++) {
              if (arrVehicle[i].id.toString() == value) {
                selectedVehicleProfile = arrVehicle[i];
                selectedVehicle = i;
              }
            }
            if (arrVehicle.length < selectedVehicle) selectedVehicle = 0;
            // Send the user to the Add Service Event page
            Navigator.pushNamed(context, RouteName.addEvent,
                arguments: ItemArgument(data: {'vehicles': selectedVehicle}));
          });
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 65,
                width: 300,
                child: Stack(children: [
                  SizedBox(
                    height: 65,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: DottedLine(
                        direction: Axis.vertical,
                        lineLength: double.infinity,
                        lineThickness: 2.0,
                        dashLength: 4.0,
                        dashColor: Colors.grey,
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                        dashGapRadius: 0.0,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 40,
                    top: 23,
                    child: SizedBox(
                        width: 40,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              child: SizedBox(
                                child: icon ??
                                    SvgPicture.asset(
                                      AssetImages.plus,
                                      color: Colors.white,
                                    ),
                              ),
                              backgroundColor: _appTheme.primaryColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              title ?? "",
                              style: TextStyle(
                                  color: _appTheme.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
