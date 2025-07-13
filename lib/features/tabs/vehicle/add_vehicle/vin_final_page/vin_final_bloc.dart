import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/my_ride_dialog.dart';

class VINFinalBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  var arguments;

  String mileType = 'mile';
  TextEditingController txtNickName = TextEditingController();
  TextEditingController txtPDate = TextEditingController();
  TextEditingController txtPMile = TextEditingController();
  TextEditingController txtCDate = TextEditingController();
  TextEditingController txtCMile = TextEditingController();
  TextEditingController txtManufacturerController = TextEditingController();
  TextEditingController txtModelController = TextEditingController();
  TextEditingController txtYearController = TextEditingController();
  VehicleProfile? vehicle;
  @override
  void dispose() {
    mainStreamController.close();
  }

  bool checkValidation() {
    if (Validation.checkIsEmpty(
        textEditingController: txtNickName,
        msg: StringConstants.Please_hint_car_nick_name)) {
      return false;
    } else if (txtYearController.text.trim() != '' &&
        (txtYearController.text.length < 4 ||
            txtYearController.text == '0000' ||
            int.parse(txtYearController.text) < 1901)) {
      CommonToast.getInstance()
          .displayToast(message: StringConstants.Please_hint_valid_car_year);
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtPDate,
        msg: StringConstants.Please_hint_purchase_date)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtPMile,
        msg: StringConstants.Please_hint_purchase_mileage)) {
      return false;
    } else if (Validation.isNotValidNumber(
        textEditingController: txtPMile,
        msg: StringConstants.Please_hint_valid_purchase_mileage)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtCDate,
        msg: StringConstants.Please_hint_current_date)) {
      return false;
    } else if (Validation.checkIsEmpty(
        textEditingController: txtCMile,
        msg: StringConstants.Please_hint_current_mileage)) {
      return false;
    } else if (Validation.isNotValidNumber(
        textEditingController: txtCMile,
        msg: StringConstants.Please_hint_valid_current_mileage)) {
      return false;
    } else if (Validation.areDatesAcceptable(
        pDate: txtPDate.text,
        cDate: txtCDate.text,
        msg: StringConstants.Please_choose_another_date)) {
      return false;
    } else if (Validation.areMilagesAcceptable(
        pMile: txtPMile,
        cMile: txtCMile,
        msg: StringConstants.Please_enter_correct_milage)) {
      return false;
    } else {
      return true;
    }
  }

  void btnAddClicked({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    Map<String, dynamic> vehicleProfile = arguments['data'] ?? {};
    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .addVehicle(
              nick_name: txtNickName.text,
              make_company: txtManufacturerController.text,
              model: txtModelController.text,
              engine: vehicleProfile['engine'] ?? '',
              body_trim: vehicleProfile['body_trim'] ?? '',
              drive: vehicleProfile['drive'] ?? '',
              vin_number: vehicleProfile['vin_number'] ?? '',
              year: txtYearController.text,
              mileage_unit: mileType,
              previous_mileage: txtPMile.text,
              previous_date: txtPDate.text,
              current_mileage: txtCMile.text,
              current_date: txtCDate.text)
          .then((value) {
        Utils.getDetail();
        getVehicleList(context: context, id: (value['id'] ?? 0).toString());
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  void btnAddClicked2({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    Map<String, dynamic> vehicleProfile = arguments['data'] ?? {};
    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .addVehicle(
              nick_name: txtNickName.text,
              make_company: txtManufacturerController.text,
              model: txtModelController.text,
              engine: vehicleProfile['engine'] ?? '',
              body_trim: vehicleProfile['body_trim'] ?? '',
              drive: vehicleProfile['drive'] ?? '',
              vin_number: vehicleProfile['vin_number'] ?? '',
              year: txtYearController.text,
              mileage_unit: mileType,
              previous_mileage: txtPMile.text,
              previous_date: txtPDate.text,
              current_mileage: txtCMile.text,
              current_date: txtCDate.text)
          .then((value) {
        Utils.getDetail();
        getVehicleList2(context: context, id: (value['id'] ?? 0).toString());
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  void getVehicleList({BuildContext? context, String? id}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getShareVehicle(isProgressBar: true)
        .then((value) {
      if (value.length > 0) {
        AppComponentBase.getInstance().setArrVehicleProfile(value);
      } else {
        AppComponentBase.getInstance().setArrVehicleProfile([]);
      }
      String ids = '0';
      value.forEach((element) {
        if (element.id.toString() == id.toString()) {
          ids = element.id.toString();
        }
      });
      AppComponentBase.getInstance()
          .getSharedPreference()
          .setSelectedVehicle(ids)
          .then((value) {
        showDialog(
            context: context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomDialogBox.vehicleAdd(
                onPress: () {
                  AppComponentBase.getInstance().load(true);
                  Navigator.pushNamed(
                    context,
                    RouteName.dashboard,
                  );
                },
              );
            });
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  void getVehicleList2({BuildContext? context, String? id}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getShareVehicle(isProgressBar: true)
        .then((value) {
      if (value.length > 0) {
        AppComponentBase.getInstance().setArrVehicleProfile(value);
      } else {
        AppComponentBase.getInstance().setArrVehicleProfile([]);
      }
      String ids = '0';
      value.forEach((element) {
        if (element.id.toString() == id.toString()) {
          ids = element.id.toString();
        }
      });
      AppComponentBase.getInstance()
          .getSharedPreference()
          .setSelectedVehicle(ids)
          .then((value) {
        AppComponentBase.getInstance().load(true);
        Navigator.pushNamed(context!, RouteName.addEvent,
            arguments: ItemArgument(data: {'vehicle': vehicle}));
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  void onMileTypePress(str) {
    mileType = str;
    mainStreamController.sink.add(true);
  }

  void btnCDateClicked({BuildContext? context}) {
    openCalender(context: context!, tec: txtCDate).then((value) {
      if (value != null) {
        txtCDate.text = DateFormat(
                AppComponentBase.getInstance().getLoginData().user?.date_format)
            .format(value);
        mainStreamController.sink.add(true);
      }
    });
  }

  void btnPDateClicked({BuildContext? context}) {
    openCalender(context: context!, tec: txtPDate).then((value) {
      if (value != null) {
        txtPDate.text = DateFormat(
                AppComponentBase.getInstance().getLoginData().user?.date_format)
            .format(value);
        mainStreamController.sink.add(true);
      }
    });
  }

  Future<DateTime?> openCalender(
      {BuildContext? context, TextEditingController? tec}) async {
    FocusScope.of(context!).requestFocus(FocusNode());
    AppThemeState _appTheme = AppThemeState();
    return await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.day,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: _appTheme.primaryColor,
                onPrimary: Colors.white,
                surface: _appTheme.whiteColor,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
        initialDate: tec?.text != ""
            ? DateFormat(AppComponentBase.getInstance()
                    .getLoginData()
                    .user
                    ?.date_format)
                .parse(tec?.text ?? '')
            : DateTime.now(),
        firstDate: DateTime(1901),
        lastDate: DateTime(2030));
  }
}
