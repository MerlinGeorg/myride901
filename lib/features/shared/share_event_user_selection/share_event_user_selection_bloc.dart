import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class ShareEventUserSelectionBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  int isGuest = -1;
  VehicleProfile? vehicleProfile;
  String serviceIds = '';
  TextEditingController txtSearch = TextEditingController();
  List<dynamic> arrUser = [];
  bool isLoading = true;
  bool isShareVehicle = false;

  @override
  void dispose() {
    mainStreamController.close();
  }

  void btnBackClicked({BuildContext? context}) {
    Navigator.pop(context!);
  }

  void btnSubmitClicked({BuildContext? context}) {
    Navigator.pushNamed(context!, RouteName.shareServicePermission,
        arguments: ItemArgument(data: {
          'vehicleProfile': vehicleProfile,
          'serviceIds': serviceIds,
          'isGuest': isGuest,
          'isShareVehicle': isShareVehicle,
          'arrUser':
              arrUser.where((element) => element['is_shared'] == 1).toList()
        }));
  }

  void getUser({BuildContext? context, String search = ''}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .contactList(is_guest: isGuest)
        .then((value) {
      isLoading = false;
      arrUser = [];
      (value ?? []).forEach((e) {
        var e2 = e;
        e2['is_shared'] = 0;
        arrUser.add(e2);
      });
      arrUser.sort((a, b) => a["email"]
          .toString()
          .toLowerCase()
          .compareTo(b["email"].toString().toLowerCase()));
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      isLoading = false;
      mainStreamController.sink.add(true);
      print(onError);
    });
  }

  void searchUser({BuildContext? context, String email = ''}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .searchUser(email: email)
        .then((value) {
      arrUser.add({
        "email": value["email"] ?? '',
        "user_name": value["user_name"] ?? '',
        "is_shared": 1,
        "display_image": value["display_image"] ?? '',
      });
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      isLoading = false;
      mainStreamController.sink.add(true);
      print(onError);
    });
  }
}
