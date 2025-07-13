import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/features/subscription/subscription_bloc.dart';
import 'package:myride901/features/subscription/widgets/subscription_info_popup.dart';
import 'package:myride901/features/toolkit/next_service/get_maintenance/get_maintenance_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/constants/routes.dart';

class myToolKit extends StatefulWidget {
  const myToolKit({Key? key}) : super(key: key);

  @override
  State<myToolKit> createState() => _myToolKitState();
}

class _myToolKitState extends State<myToolKit> {
  @override
  Widget build(BuildContext context) {
    var _appTheme = AppTheme.of(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
          width: 122,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: FittedBox(
            child: Text(
              'MyToolKit',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                color: _appTheme.primaryColor,
                fontSize: 16,
              ),
            ),
          ),
        ),
        items: [
          ...MenuItems.firstItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              alignment: AlignmentDirectional.center,
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value as MenuItem);
        },
        dropdownStyleData: DropdownStyleData(
          width: 122,
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          elevation: 8,
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.filled(MenuItems.firstItems.length, 48),
          ],
          padding: const EdgeInsets.only(left: 6, right: 6),
        ),
      ),
    );
  }
}

class MenuItem {
  final String text;

  const MenuItem({
    required this.text,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [shops, service, recall, arf, trips];
  static const shops = MenuItem(text: 'Find a Shop');
  static const service = MenuItem(text: 'Next Service');
  static const recall = MenuItem(text: 'Safety Recalls');
  static const arf = MenuItem(text: 'Accident Form');
  static const trips = MenuItem(text: StringConstants.add_mileage_tracker);

  static Widget buildItem(MenuItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.text,
          style: const TextStyle(
              color: Color(0xff0C1248),
              fontSize: 15,
              fontWeight: FontWeight.bold),
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) async {
    if (item == MenuItems.shops) {
      AppComponentBase.getInstance().getLoginData().user?.totalVehicles == 0
          ? CommonToast.getInstance()
              .displayToast(message: StringConstants.add_vehicle_first)
          : Navigator.pushNamed(context, RouteName.shops);
    } else if (item == MenuItems.trips) {
      final totalVehicles =
          AppComponentBase.getInstance().getLoginData().user?.totalVehicles;

      if (totalVehicles == 0) {
        CommonToast.getInstance()
            .displayToast(message: StringConstants.add_vehicle_first);
      } else {
        Navigator.pushNamed(context, RouteName.trip);
      }
    } else {
      final _subscriptionBloc = SubscriptionBloc();
      EasyLoading.show();
      await _subscriptionBloc.getUserStatus();
      EasyLoading.dismiss();

      if (_subscriptionBloc.subscriptionState['hasProAccess'] == true) {
        switch (item) {
          case MenuItems.service:
            AppComponentBase.getInstance().getLoginData().user?.totalVehicles ==
                    0
                ? CommonToast.getInstance()
                    .displayToast(message: StringConstants.add_vehicle_first)
                : Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 200),
                        reverseDuration: Duration(milliseconds: 150),
                        child: GetMaintenancePage()));
            break;
          case MenuItems.recall:
            Navigator.pushNamed(context, RouteName.vehicleRecall);
            break;
          case MenuItems.arf:
            AppComponentBase.getInstance().getLoginData().user?.totalVehicles ==
                    0
                ? CommonToast.getInstance()
                    .displayToast(message: StringConstants.add_vehicle_first)
                : Navigator.pushNamed(context, RouteName.accidentReport);
            break;
        }
      } else {
        SubscriptionFeature? subscriptionFeature;

        switch (item) {
          case MenuItems.service:
            subscriptionFeature = SubscriptionFeature.nextServiceLookup;
            break;
          case MenuItems.recall:
            subscriptionFeature = SubscriptionFeature.safetyServiceLookup;
            break;
          case MenuItems.arf:
            subscriptionFeature = SubscriptionFeature.accidentReport;
            break;
        }
        subscriptionFeature != null
            ? Utils.displaySubscriptionPopup(
                context,
                subscriptionFeature,
                _subscriptionBloc.subscriptionState,
                RouteName.dashboard,
              )
            : CommonToast.getInstance()
                .displayToast(message: "subscription feature not available");
      }
    }
  }
}
