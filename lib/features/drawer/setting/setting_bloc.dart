import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class SettingBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;

  List<VehicleProfile> arrVehicle = [];
  bool isLoaded = false;
  int selectedVehicle = 0;
  List<VehicleService> arrService = [];

  @override
  void dispose() {
    mainStreamController.close();
  }

  Future<void> getVehicleList(
      {BuildContext? context, bool? isProgressBar}) async {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicle()
        .then((value) {
      arrVehicle = value;
      setLocalData().then((value) {
        getServiceList(context: context!, isProgressBar: isProgressBar);
      });
      mainStreamController.sink.add(true);
      isLoaded = true;
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<void> setLocalData() async {
    if (AppComponentBase.getInstance().isArrVehicleProfileFetch) {
      await AppComponentBase.getInstance()
          .getSharedPreference()
          .getSelectedVehicle()
          .then((value) {
        arrVehicle = Utils.arrangeVehicle(
            AppComponentBase.getInstance().getArrVehicleProfile(),
            int.parse(value));
        arrService = AppComponentBase.getInstance().getArrVehicleService();
        selectedVehicle = 0;
        for (int i = 0; i < arrVehicle.length; i++) {
          if (arrVehicle[i].id.toString() == value) {
            selectedVehicle = i;
          }
        }
        if (arrVehicle.length < selectedVehicle) selectedVehicle = 0;
        if (arrVehicle.length > 0) {
          AppComponentBase.getInstance()
              .getSharedPreference()
              .setSelectedVehicle(arrVehicle[selectedVehicle].id.toString());
        }
        isLoaded = true;
        mainStreamController.sink.add(true);
      });
    }
  }

  Future<void> getServiceList(
      {BuildContext? context, bool? isProgressBar}) async {
    AppComponentBase.getInstance()
        .getSharedPreference()
        .getSelectedVehicle()
        .then((value) {
      arrVehicle = Utils.arrangeVehicle(
          AppComponentBase.getInstance().getArrVehicleProfile(),
          int.parse(value));
      arrService = AppComponentBase.getInstance().getArrVehicleService();
      selectedVehicle = 0;
      for (int i = 0; i < arrVehicle.length; i++) {
        if (arrVehicle[i].id.toString() == value) {
          selectedVehicle = i;
        }
      }
      if (arrVehicle.length < selectedVehicle) selectedVehicle = 0;
      if (arrVehicle.length > 0) {
        AppComponentBase.getInstance()
            .getSharedPreference()
            .setSelectedVehicle(arrVehicle[selectedVehicle].id.toString());
      }
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .getVehicleService(
              vehicleId: arrVehicle[selectedVehicle].id.toString(),
              id: arrVehicle[selectedVehicle].id.toString(),
              isProgressBar: isProgressBar!)
          .then((value) {
        arrService = [];
        AppComponentBase.getInstance().setArrVehicleService(value);
        arrService = value;
        setLocalData();
      }).catchError((onError) {
        print(onError);
      });
    });
  }

  Future<void> updateVehicleCurrency(
      {BuildContext? context, String? currency}) async {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .updateCurrency(
          currency: currency ?? '',
        )
        .then((value) {
      getVehicleList(
          context: context,
          isProgressBar:
              !AppComponentBase.getInstance().isArrVehicleProfileFetch);
      setLocalData();
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<void> changeDateFormat({
    required BuildContext context,
    String? date_format,
  }) async {
    _showLoading(context);
    try {
      await AppComponentBase.getInstance()
          .getApiInterface()
          .getUserRepository()
          .changeDateFormat(
            date_format: date_format ?? '',
          );

      getVehicleList(
        context: context,
        isProgressBar: !AppComponentBase.getInstance().isArrVehicleProfileFetch,
      );
      setLocalData();
      mainStreamController.sink.add(true);
    } catch (onError) {
      print(onError);
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
