import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class ReportShareOptionBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();
  Stream<bool> get mainStream => mainStreamController.stream;
  int isGuest = -1;
  VehicleProfile? vehicleProfile;
  String serviceIds = '';
  bool isShareVehicle = false;
  @override
  void dispose() {
    mainStreamController.close();
  }

  void btnBackClicked({BuildContext? context}) {
    Navigator.pop(context!);
  }

  void btnSubmitClicked({BuildContext? context}) {
    Navigator.pushNamed(context!, RouteName.shareReportUserSelection,
        arguments: ItemArgument(data: {
          'isGuest': isGuest,
        }));
  }
}
