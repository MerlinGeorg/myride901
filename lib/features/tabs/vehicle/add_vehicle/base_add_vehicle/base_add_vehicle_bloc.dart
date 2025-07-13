import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/select_vehicle_make.dart';

class BaseAddVehicleBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  List<String> arrYear = [];
  List<String> arrModel = [];
  List<VehicleName> arrMake = [];
  String selectedType = 'car';
  String selectedYear = '';
  String selectedModel = '';
  String selectedMake = '';
  String mileType = 'mile';
  TextEditingController txtNickName = TextEditingController();
  TextEditingController txtSearchYear = TextEditingController();
  TextEditingController txtSearchModel = TextEditingController();
  TextEditingController txtSearchMake = TextEditingController();

  @override
  void dispose() {
    mainStreamController.close();
  }

  void getData({BuildContext? context, String? screen, String? year, String? make, String? model }) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicleInformation(type: selectedType, year: selectedYear, make: selectedMake, model: selectedModel, screen: screen)
        .then((value) {
      if (screen == 'year') {
        arrYear = [];
        (value['year'] ?? []).forEach((e) {
          arrYear.add(e);
        });
      }
      if (screen == 'makes') {
        arrMake = [];
        (value['makes'] ?? []).forEach((e) {
          arrMake.add(VehicleName(e, e[0].toUpperCase()));
        });
      }
      if (screen == 'models') {
        arrModel = [];
        (value['models'] ?? []).forEach((e) {
          arrModel.add(e);
        });
      }
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }
}
