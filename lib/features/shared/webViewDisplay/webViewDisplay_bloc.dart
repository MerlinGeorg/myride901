import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class WebViewDisplayBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  String? url;
  String title = '';
  int id = -1;
  String html = '';
  @override
  void dispose() {
    mainStreamController.close();
  }

  void getList({BuildContext? context}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getBlogDetail(id: id)
        .then((value) {
      html = value;
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }
}
