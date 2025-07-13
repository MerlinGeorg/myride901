import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/trip/trip.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class TripBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();
  Stream<bool> get mainStream => mainStreamController.stream;
  List<VehicleProfile> arrVehicle = [];
  Map<String, dynamic> vehicleNicknames = {};
  String? vehicle_id;

  int selectedVehicle = 0;
  VehicleProfile? vehicleProfile;

  List<Trip> arrTrip = [];
  List<Trip> arrTripAll = [];
  Trip? trip;
  bool isLoaded = false;
  bool isTrip = false;

  @override
  void dispose() {
    mainStreamController.close();
  }

  void getArrVehicle({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicle()
        .then((value) async {
      arrVehicle = value;

      if (isTrip == false) {
        await getSelectedVehicle();
      }

      getTripList(context: context, isProgressBar: isProgressBar);
      mainStreamController.sink.add(true);
    });
  }

  Future<void> getSelectedVehicle() async {
    await AppComponentBase.getInstance()
        .getSharedPreference()
        .getSelectedVehicle()
        .then((value) {
      for (int i = 0; i < arrVehicle.length; i++) {
        if (arrVehicle[i].id.toString() == value) {
          selectedVehicle = i;
        }
      }
    });
  }

  void getTripList({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getTrip()
        .then((value) {
      arrTrip = [];
      arrTripAll = value;
      arrTrip = value
          .where((trip) =>
              trip.vehicleId == arrVehicle[selectedVehicle].id.toString())
          .toList();
      AppComponentBase.getInstance().setArrTrip(value);
      isLoaded = true;
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void getTripPersonal({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getTrip()
        .then((value) {
      arrTrip = [];
      AppComponentBase.getInstance().setArrTrip(value);

      arrTrip = value
          .where((trip) => ((trip.category == "personal" &&
              trip.vehicleId == arrVehicle[selectedVehicle].id.toString())))
          .toList();
      isLoaded = true;
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void getTripBusiness({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getTrip()
        .then((value) {
      arrTrip = [];
      AppComponentBase.getInstance().setArrTrip(value);

      arrTrip = value
          .where((trip) => ((trip.category == "business" &&
              trip.vehicleId == arrVehicle[selectedVehicle].id.toString())))
          .toList();
      isLoaded = true;
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void deleteTrip({BuildContext? context, int? index}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .deleteTrip(arrTrip[index!])
        .then((value) {
      CommonToast.getInstance().displayToast(message: value);
      arrTrip.removeAt(index);
      AppComponentBase.getInstance().setArrTrip(arrTrip);

      if (arrTrip.length > 0) {
        getTripList(context: context, isProgressBar: false);
      }
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void btnClicked({BuildContext? context, int? index}) {
    Navigator.of(context!, rootNavigator: false)
        .pushNamed(RouteName.editTrip,
            arguments: ItemArgument(data: {
              'trip': arrTrip[index!],
              'selectedVehicle': selectedVehicle,
            }))
        .then((value) {});
  }

  void exportToCsv(List<Trip> trips) async {
    EasyLoading.show(status: StringConstants.loading);

    bool permission;
    if (defaultTargetPlatform == TargetPlatform.android) {
      DeviceInfoPlugin plugin = DeviceInfoPlugin();
      AndroidDeviceInfo android = await plugin.androidInfo;
      if (android.version.sdkInt < 33) {
        permission = await Permission.storage.request().isGranted;
      } else {
        permission = true;
      }
    } else {
      permission = true;
    }

    if (permission) {
      final rows = <List<dynamic>>[];
      final path;
      var directory;
      bool dirDownloadExists = true;
      rows.add([
        'Vehicle Nickname',
        'Start Date',
        'End Date',
        'Start Location',
        'End Location',
        'Category',
        'Distance',
        'Mileage Unit',
        'Duration',
        'Rate',
        'Total Amount'
      ]);

      arrTrip.forEach((trip) {
        final row = [
          arrVehicle[selectedVehicle].Nickname,
          trip.startDate,
          trip.endDate,
          trip.startLocation,
          trip.endLocation,
          trip.category,
          trip.totalDistance,
          trip.mileageUnit,
          '${trip.days} days ${trip.hours} hours ${trip.minutes} minutes',
          trip.price,
          trip.earnings
        ];
        rows.add(row);
      });

      if (Platform.isAndroid) {
        directory = "/storage/emulated/0/Download";

        dirDownloadExists = await Directory(directory).exists();
        if (dirDownloadExists) {
          directory = "/storage/emulated/0/Download";
        } else {
          directory = "/storage/emulated/0/Downloads";
        }
      }
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      if (Platform.isIOS) {
        Directory directory = await getApplicationDocumentsDirectory();
        path = '${directory.path}/my_ride_901_trips_$timestamp.csv';
      } else {
        path = '$directory/my_ride_901_trips_$timestamp.csv';
      }

      final file = File(path);
      String csv = const ListToCsvConverter().convert(rows);
      await file.writeAsString(csv);

      await Share.shareXFiles([XFile(path)]);
      EasyLoading.dismiss();
      CommonToast.getInstance()
          .displayToast(message: StringConstants.csv_downloaded);
    } else {
      EasyLoading.dismiss();
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      CommonToast.getInstance()
          .displayToast(message: StringConstants.csv_denied);
    }
  }
}
