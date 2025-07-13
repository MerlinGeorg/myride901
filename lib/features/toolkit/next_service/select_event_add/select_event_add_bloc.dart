import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class SelectEventAddBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  dynamic arrSpec = [];

  @override
  void dispose() {
    mainStreamController.close();
  }

  void btnSubmitClicked({BuildContext? context, int? index}) {
    Navigator.pushNamed(context!, RouteName.addEvent,
        arguments: ItemArgument(data: {'data': arrSpec[index]}));
  }
}