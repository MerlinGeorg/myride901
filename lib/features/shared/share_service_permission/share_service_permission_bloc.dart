import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/my_ride_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareServicePermissionBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();
  Stream<bool> get mainStream => mainStreamController.stream;
  int isGuest = -1;
  VehicleProfile? vehicleProfile;
  String serviceIds = '';
  bool isShareVehicle = false;
  List<dynamic> arrUser = [];

  @override
  void dispose() {
    mainStreamController.close();
  }

  Future<void> btnSubmitClicked({BuildContext? context}) async {
    List<String> email = [];
    List<String> is_edit = [];
    for (var i = 0; i < arrUser.length; i++) {
      email.add(arrUser[i]['email']);
      is_edit.add((arrUser[i]['is_edit'] ?? 0).toString());
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .addNewServicePermission(
            vehicle_id: vehicleProfile?.id.toString(),
            service_id: serviceIds,
            is_guest: isGuest.toString(),
            email: email,
            is_edit: is_edit,
            isShareVehicle: isShareVehicle)
        .then(
      (value) {
        showDialog(
          context: context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox.eventShare(
              onPress: () async {
                Navigator.popUntil(
                    context, ModalRoute.withName(RouteName.dashboard));
              },
            );
          },
        );
      },
    ).catchError(
      (onError) => print(onError),
    );
  }
}
