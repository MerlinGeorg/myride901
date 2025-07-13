import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/reminder/reminder.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/core/utils/utils.dart';

class GetMaintenanceBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  TextEditingController txtVin = TextEditingController();
  TextEditingController txtMileage = TextEditingController();
  List<VehicleProfile> arrVehicle = [];
  int selectedVehicle = 0;
  bool isLoaded = false;
  String? val;
  Reminder? reminder;
  List<String>? reminderData;
  var arguments;

  @override
  void dispose() {
    mainStreamController.close();
  }

  bool checkValidation() {
    if (Validation.checkIsEmpty(
        textEditingController: txtVin, msg: StringConstants.Please_enter_vin)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtMileage,
        msg: StringConstants.Please_hint_enter_mileage)) {
      return false;
    } else if (Validation.isNotValidNumber(
        textEditingController: txtMileage,
        msg: StringConstants.Please_hint_valid_enter_mileage)) {
      return false;
    } else {
      return true;
    }
  }

  void btnSubmitClicked({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    if (checkValidation()) {
      _showLoading(context);
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .serviceEventsByVin(
              vin_number: txtVin.text,
              current_mileage: txtMileage.text.replaceAll(',', ''))
          .then((value) {
        if (value.isEmpty && val == null) {
          Utils.showAlertDialogCallBack1(
              context: context,
              message: StringConstants.wrong_vin,
              isConfirmationDialog: false,
              isOnlyOK: false,
              navBtnName: 'Go Back',
              posBtnName: 'Add event manually',
              onNavClick: () {
                Navigator.pop(context);
              },
              onPosClick: () {
                Navigator.pushNamed(context, RouteName.addEvent,
                    arguments: ItemArgument(data: {}));
              });
        } else if (value.isEmpty && val == 'add') {
          Utils.showAlertDialogCallBack1(
              context: context,
              message: StringConstants.wrong_vin,
              isConfirmationDialog: false,
              isOnlyOK: false,
              navBtnName: 'Go Back',
              posBtnName: 'Add event manually',
              onNavClick: () {
                Navigator.pop(context);
              },
              onPosClick: () {
                Navigator.of(context, rootNavigator: false).pushNamed(
                    RouteName.addEvent,
                    arguments: ItemArgument(
                        data: {'value': val, 'reminderData': reminderData}));
              });
        } else if (value.isEmpty && val == 'edit') {
          Utils.showAlertDialogCallBack1(
              context: context,
              message: StringConstants.wrong_vin,
              isConfirmationDialog: false,
              isOnlyOK: false,
              navBtnName: 'Go Back',
              posBtnName: 'Add event manually',
              onNavClick: () {
                Navigator.pop(context);
              },
              onPosClick: () {
                print(reminder);
                Navigator.of(context, rootNavigator: false).pushNamed(
                    RouteName.addEvent,
                    arguments: ItemArgument(
                        data: {'value': val, 'reminder': reminder}));
              });
        } else {
          getVehicle(context: context, service: value);
        }
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  void getVehicle({BuildContext? context, dynamic service}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .searchbyVinNumber(vin_number: txtVin.text)
          .then((value) {
        Map<String, dynamic> d = value;
        d['year'] = d['year'].toString();
        Navigator.of(context, rootNavigator: false)
            .pushNamed(RouteName.verifyCarDetail,
                arguments: ItemArgument(data: {
                  'service': service,
                  'vehicle': d,
                  'value': val,
                  'reminder': reminder,
                  'reminderData': reminderData
                }));
      }).catchError((onError) {
        print(onError);
      });
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

  Future<void> setLocalData() async {
    if (AppComponentBase.getInstance().isArrVehicleProfileFetch) {
      await AppComponentBase.getInstance()
          .getSharedPreference()
          .getSelectedVehicle()
          .then((value) {
        arrVehicle = Utils.arrangeVehicle(
            AppComponentBase.getInstance().getArrVehicleProfile(onlyMy: true),
            int.parse(value));
        selectedVehicle = 0;
        for (int i = 0; i < arrVehicle.length; i++) {
          if (arrVehicle[i].id.toString() == value) {
            selectedVehicle = i;
          }
        }
        if (arrVehicle.length < selectedVehicle) selectedVehicle = 0;
        if (arrVehicle.length > selectedVehicle) {
          AppComponentBase.getInstance()
              .getSharedPreference()
              .setSelectedVehicle(arrVehicle[selectedVehicle].id.toString());
          txtVin = TextEditingController(text: arrVehicle[selectedVehicle].VIN);
        }
        isLoaded = true;
        mainStreamController.sink.add(true);
      });
    }
  }
}