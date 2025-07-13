import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class SharedReportBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  List<VehicleService> arrData = [];
  bool isLoaded = false;
  @override
  void dispose() {
    mainStreamController.close();
  }

  void getData({BuildContext? context, String v = ''}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getSharedService()
        .then((value) {
      isLoaded = true;
      arrData = [];
      (value ?? []).forEach((e) {
        arrData.add(VehicleService.fromJson(e));
      });
      if (v != '') CommonToast.getInstance().displayToast(message: v);
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void revokeServicePermission({BuildContext? context, int? index}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .revokeServicePermission(service_id: arrData[index!].id)
        .then((value) {
      CommonToast.getInstance().displayToast(message: value);
      arrData.removeAt(index);
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void btnSubmitClicked(
      {BuildContext? context, int? index, String? delete_email}) {
    List<String> email = [];
    List<String> is_edit = [];
    for (var i = 0; i < arrData[index!].servicePermissions!.length; i++) {
      email.add(arrData[index].servicePermissions![i].userEmail ?? '');
      is_edit.add(arrData[index].servicePermissions![i].isEdit ?? '');
    }
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .editNewServicePermission(
            vehicle_id: arrData[index].vehicleId.toString(),
            service_id: arrData[index].id.toString(),
            delete_email: delete_email,
            email: email,
            is_edit: is_edit)
        .then((value) {
      getData(context: context, v: value);
    }).catchError((onError) {
      print(onError);
    });
  }
}
