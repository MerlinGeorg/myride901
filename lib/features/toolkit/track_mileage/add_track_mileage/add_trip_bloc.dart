import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/trip/trip.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class AddTripBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  String mileType = 'mile';
  TextEditingController? startLocation = TextEditingController();
  TextEditingController? endLocation = TextEditingController();
  TextEditingController? totalDistance = TextEditingController();
  TextEditingController? notes = TextEditingController();
  TextEditingController startDate = TextEditingController(
    text: DateFormat(
            (AppComponentBase.getInstance().getLoginData().user?.date_format ??
                    'yyyy-MM-dd') +
                ' HH:mm')
        .format(DateTime.now()),
  );
  TextEditingController? endDate = TextEditingController();
  TextEditingController? category = TextEditingController();
  TextEditingController? mileageUnit = TextEditingController();
  TextEditingController? price = TextEditingController();
  TextEditingController? earnings = TextEditingController();
  TextEditingController? vehicleId = TextEditingController();
  TextEditingController? daysController = TextEditingController();
  TextEditingController? hoursController = TextEditingController();
  TextEditingController? minutesController = TextEditingController();
  List<VehicleProfile> arrVehicle = [];
  List<VehicleService> arrService = [];
  bool isLoaded = false;
  int selectedVehicle = 0;
  VehicleProfile? vehicleProfile;

  bool clicked = false;

  List<String> origin = [];
  List<String> destination = [];
  List<String> routes = [];
  List<String> durations = [];
  List<String> images = [];
  List<String> links = [];
  List<Trip> arrTrip = [];

  @override
  void dispose() {
    mainStreamController.close();
  }

  void getVehicleList({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicle()
        .then((value) {
      if (value.length > 0) {
        AppComponentBase.getInstance().setArrVehicleProfile(value);
        arrVehicle = value;
        isLoaded = true;
      } else {
        AppComponentBase.getInstance().setArrVehicleProfile([]);
      }
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  bool checkValidation() {
    if (Validation.checkIsEmpty(
        textEditingController: category,
        msg: StringConstants.pleaseEnterCategory)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: startDate,
        msg: StringConstants.pleaseEnterDate)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: startLocation,
        msg: StringConstants.pleaseEnterOrigin)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: endLocation,
        msg: StringConstants.pleaseEnterDestination)) {
      return false;
    } else {
      return true;
    }
  }

  void onMileTypePress(str) {
    mileType = str;
    mainStreamController.sink.add(true);
  }

  String capitalize(String input) {
    if (input.isEmpty) {
      return '';
    }

    return input[0].toUpperCase() + input.substring(1);
  }

  void addTrip({BuildContext? context}) {
    if (checkValidation()) {
      FocusScope.of(context!).requestFocus(FocusNode());
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .addTrip(
            vehicleId: arrVehicle[selectedVehicle].id.toString(),
            category: category!.text,
            mileageUnit: mileType,
            price: price!.text,
            earnings: earnings!.text,
            startDate: startDate.text,
            endDate: endDate!.text,
            days: daysController!.text,
            hours: hoursController!.text,
            minutes: minutesController!.text,
            startLocation: startLocation!.text,
            endLocation: endLocation!.text,
            totalDistance: totalDistance!.text,
            notes: notes?.text ?? '',
          )
          .then((value) {
        Navigator.pushNamed(context, RouteName.trip,
            arguments: ItemArgument(
                data: {'selectedVehicle': selectedVehicle, 'isTrip': true}));
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  void getLastTripList({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getTrip()
        .then((value) {
      arrTrip = [];
      AppComponentBase.getInstance().setArrTrip(value);
      if (value.isNotEmpty) {
        final firstTrip = value.first;
        arrTrip = [firstTrip];
        price?.text = firstTrip.price ?? '';
      }
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<void> getAutocomplete({BuildContext? context}) async {
    try {
      var value = await AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .getAutocomplete(params: startLocation!.text);

      origin = value;
      mainStreamController.sink.add(true);
    } catch (error) {
      print(error);
      throw Exception('Error occurred while getting autocomplete');
    }
  }

  Future<void> getAutocomplete2({BuildContext? context}) async {
    try {
      var value = await AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .getAutocomplete(params: endLocation!.text);

      destination = value;
      mainStreamController.sink.add(true);
    } catch (error) {
      print(error);
      throw Exception('Error occurred while getting autocomplete');
    }
  }

  void getDirections({BuildContext? context}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getDirections(
            start_location: startLocation!.text,
            end_location: endLocation!.text,
            unit: mileType == 'mile' ? 'imperial' : 'metric')
        .then((value) {
      routes = value['distances'];
      images = value['screenshotUrls'];
      durations = value['durations'];
      links = value['linkUrl'];
      mainStreamController.sink.add(true);
    }).catchError((error) {
      print(error);
      throw Exception('Error occurred while getting autocomplete');
    });
  }
}
