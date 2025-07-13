import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/reminder/reminder.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class VerifyCarDetailBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  dynamic arrSpec;
  VehicleProfile? vehicle;
  String? val;
  Reminder? reminder;
  var arguments;
  List<String>? reminderData;

  @override
  void dispose() {
    mainStreamController.close();
  }

  void btnSubmitClicked({BuildContext? context}) {
    Navigator.pushNamed(context!, RouteName.addEvent,
        arguments: ItemArgument(data: {
          'data': arrSpec,
          'vehicle': vehicle,
          'value': val,
          'reminder': reminder,
          'reminderData': reminderData
        }));
  }
}