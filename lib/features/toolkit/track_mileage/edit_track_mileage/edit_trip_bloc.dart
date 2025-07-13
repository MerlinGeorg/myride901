import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/trip/trip.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditTripBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;

  var arguments;
  List<Trip> arrTrip = [];
  int selectedVehicle = 0;

  Trip? trip;
  TextEditingController? startLocation = TextEditingController();
  TextEditingController? endLocation = TextEditingController();
  TextEditingController? totalDistance = TextEditingController();
  TextEditingController? notes = TextEditingController();
  TextEditingController? startDate = TextEditingController();
  TextEditingController? endDate = TextEditingController();
  TextEditingController? category = TextEditingController();
  TextEditingController? mileageUnit = TextEditingController();
  TextEditingController? price = TextEditingController();
  TextEditingController? earnings = TextEditingController();
  TextEditingController? vehicleId = TextEditingController();
  TextEditingController? daysController = TextEditingController();
  TextEditingController? hoursController = TextEditingController();
  TextEditingController? minutesController = TextEditingController();
  String? name;

  List<String> origin = [];
  List<String> destination = [];
  bool isLoaded = false;
  VehicleProfile? vehicleProfile;

  @override
  void dispose() {
    mainStreamController.close();
  }

  String capitalize(String input) {
    if (input.isEmpty) {
      return '';
    }

    return input[0].toUpperCase() + input.substring(1);
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

  void btnUpdateClicked({BuildContext? context}) {
    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .updateTrip(
            vehicleId: vehicleId?.text ?? '',
            category: category!.text,
            mileageUnit: mileageUnit!.text,
            price: price!.text,
            earnings: earnings!.text,
            startDate: startDate!.text,
            endDate: endDate!.text,
            days: daysController!.text,
            hours: hoursController!.text,
            minutes: minutesController!.text,
            startLocation: startLocation!.text,
            endLocation: endLocation!.text,
            totalDistance: totalDistance!.text,
            notes: notes?.text ?? '',
            trip_id: trip?.id,
          )
          .then((value) async {
        Navigator.pushNamed(context!, RouteName.trip,
            arguments: ItemArgument(data: {
              'selectedVehicle': selectedVehicle,
              'isTrip': true
            }));
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  void getTripById(
      {BuildContext? context, bool isScroll = false, String message = ''}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getTripById(
          tripId: trip?.id.toString(),
          id: trip?.id.toString(),
        )
        .then((value) {
      if (message != '') {
        CommonToast.getInstance().displayToast(message: message);
      }
      if (value.length > 0) {
        trip = value[0];
        startLocation?.text = trip?.startLocation ?? '';
        endLocation?.text = trip?.endLocation ?? '';
        startDate?.text = trip?.startDate ?? '';
        endDate?.text = trip?.endDate ?? '';
        price?.text = trip?.price ?? '';
        earnings?.text = trip?.earnings ?? '';
        mileageUnit?.text = trip?.mileageUnit ?? '';
        vehicleId?.text = trip?.vehicleId ?? '';
        category?.text = trip?.category ?? '';
        daysController?.text = trip?.days ?? '';
        minutesController?.text = trip?.minutes ?? '';
        hoursController?.text = trip?.hours ?? '';
        notes?.text = trip?.notes ?? '';
        totalDistance?.text = trip?.totalDistance ?? '';
      }

      getVehicleProfile(context: context);
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

  void getVehicleProfile(
      {BuildContext? context, bool isScroll = false, String message = ''}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicleProfileById(
            vehicleId: trip?.vehicleId ?? '', id: trip?.vehicleId ?? '')
        .then((value) {
      if (value.length > 0) {
        vehicleProfile = value[0];
        name = value[0].Nickname;
      }
      isLoaded = true;

      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }
}
