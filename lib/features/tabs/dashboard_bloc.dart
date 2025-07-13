import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/plus/plus_bottom_sheet.dart';

class DashboardBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();
  int selectedTab = 1;
  List<VehicleProfile> arrVehicle = [];
  int? cars;
  int? tabview;
  int? events;
  int? tab;
  Stream<bool> get mainStream => mainStreamController.stream;
  bool needRefresh = false;
  @override
  void dispose() {
    mainStreamController.close();
  }

  void getVehicleList({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicle()
        .then((value) {
      arrVehicle = value;
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void openSheetService({BuildContext? context}) {
    showModalBottomSheet(
        context: context!,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return PlusBottomSheet(
            onClick: (value) {
              Navigator.pop(context);
              if (value == 'service') {
                Navigator.pushNamed(context, RouteName.addEvent,
                    arguments: ItemArgument(data: {})).then((value) {
                  needRefresh = true;
                  mainStreamController.sink.add(true);
                  Future.delayed(Duration(milliseconds: 200), () {
                    needRefresh = false;
                    mainStreamController.sink.add(true);
                  });
                });
              } else {
                if (AppComponentBase.getInstance()
                        .getArrVehicleProfile(onlyMy: true)
                        .length >=
                    50) {
                  CommonToast.getInstance().displayToast(
                      message: StringConstants.You_can_add_only_50_vehicle);
                } else {
                  Navigator.of(context)
                      .pushNamed(RouteName.addVehicleOption)
                      .then((value) {
                    if (AppComponentBase.getInstance().isRedirect) {
                      AppComponentBase.getInstance().changeRedirect(false);
                      selectedTab = 4;
                      mainStreamController.sink.add(true);
                    }
                  });
                }
              }
            },
          );
        });
  }

  changeIndex(int index) {
    selectedTab = index;
    mainStreamController.sink.add(true);
  }
}
