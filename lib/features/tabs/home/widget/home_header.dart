import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/user_picture.dart';
import 'package:myride901/core/services/analytic_services.dart';
import 'myToolKit.dart';
import 'notification_icon.dart';
import 'new_invoice_popup.dart';
import 'select_popup.dart';

class HomeHeader extends StatelessWidget {
  final String? vehicleName;
  final String? vehicleImage;
  final String? totalEvent;
  final String? lastEvent;
  final Function()? onVehicleDropDownClick;
  final Function()? onDrawerClick;
  final int? isMyVehicle;

  const HomeHeader(
      {Key? key,
      this.vehicleName,
      this.onVehicleDropDownClick,
      this.vehicleImage = '',
      this.onDrawerClick,
      this.totalEvent,
      this.lastEvent,
      this.isMyVehicle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _appTheme = AppTheme.of(context);
    return Stack(
      children: [
        Positioned(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.clamp,
                  colors: [
                    _appTheme.primaryColor,
                    _appTheme.primaryColor,
                    Color(0xffD03737)
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
                          Container(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                                onTap: () {
                                  locator<AnalyticsService>()
                                      .sendAnalyticsEvent(
                                          eventName: "HamburgerMenu",
                                          clickevent:
                                              "User opens hamburger menu");
                                  onDrawerClick?.call();
                                },
                                child: RotatedBox(
                                    quarterTurns: 90,
                                    child:
                                        SvgPicture.asset(AssetImages.drawer))),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Image.asset(
                                AssetImages.logo_l,
                                height: 34,
                              ),
                            ),
                          ),
                          Container(
                              alignment: Alignment.centerRight,
                              // child: myToolKit())
                              child: GestureDetector(
          onTap: () {
            // Show the "new invoice" popup
            showInvoiceDialog(context);
          },
                              child: DocumentIconWithNotification()
                              ),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Stack(
                              children: [
                                AppComponentBase.getInstance()
                                            .getLoginData()
                                            .user
                                            ?.totalVehicles ==
                                        0
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.white,
                                        child: Image.asset(
                                          AssetImages.car_empty,
                                          color: Colors.grey,
                                          width: 90,
                                          height: 90,
                                        ),
                                      )
                                    : UserPicture(
                                        userPicture: vehicleImage ?? '',
                                        fontSize: 24,
                                        whiteBg: true,
                                        size: Size(100, 100),
                                        text: (vehicleName ?? '').length > 0
                                            ? (vehicleName ?? '')
                                                .substring(0, 1)
                                                .toUpperCase()
                                            : (vehicleName ?? '')
                                                .toUpperCase()),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          if (vehicleName != '')
                            Text(
                              (vehicleName ?? ''),
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          SizedBox(height: 20),
                          vehicleName != ''
                              ? InkWell(
                                  onTap: () {
                                    onVehicleDropDownClick?.call();
                                  },
                                  child: Text(
                                    'Switch Vehicle',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                )
                              : OutlinedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, RouteName.addVehicleOption);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(10),
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    'Add Your First Vehicle',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: _appTheme.primaryColor),
                                  ),
                                ),
                          SizedBox(width: 40),
                        ],
                      ),
                    ),
                    SizedBox(height: 49),
                  ],
                ),
              ),
              SizedBox(height: 39)
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 16,
          right: 16,
          child: Container(
            height: 78,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                      offset: Offset(-3, 5)),
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: OverlapItem(
                    icon: AssetImages.setting_home,
                    title: 'Events',
                    value: totalEvent ?? '',
                  ),
                ),
                Container(
                  height: 35,
                  width: 1,
                  color: Color(0xff121212).withOpacity(0.1),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: OverlapItem(
                      hasIconPadding: true,
                      icon: AssetImages.car_home,
                      title: 'Service Cost Summary',
                      //value: isMyVehicle == 0 ? '0' : (lastEvent ?? ''),
                      value: lastEvent ?? '0',
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class OverlapItem extends StatelessWidget {
  final String? icon;
  final String? title;
  final String? value;
  final bool? hasIconPadding;

  const OverlapItem(
      {Key? key,
      this.icon,
      this.title,
      this.value,
      this.hasIconPadding = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon ?? '',
          width: (hasIconPadding ?? false) ? 20 : 24,
          height: (hasIconPadding ?? false) ? 20 : 24,
          color: Color(0xff121212).withOpacity(0.4),
        ),
        SizedBox(width: (hasIconPadding ?? false) ? 15 : 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                child: Text(
                  value ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 0.5,
                      color: AppTheme.of(context).primaryColor),
                ),
              ),
              SizedBox(height: 6),
              Container(
                height: 32,
                child: Text(
                  title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      letterSpacing: 0.2,
                      color: Color(0xff121212).withOpacity(0.4)),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
