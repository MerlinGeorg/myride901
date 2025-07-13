import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class AddVehicleOptionBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  int selected = -1;

  @override
  void dispose() {
    mainStreamController.close();
  }

  void btnContinueClicked({BuildContext? context}) {
    Navigator.pushNamed(
        context!,
        selected == 1
            ? RouteName.addVehicle
            : selected == 2
                ? RouteName.addVINNumber
                : RouteName.addVehicleManually);
  }
}
