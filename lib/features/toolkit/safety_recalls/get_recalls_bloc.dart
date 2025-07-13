import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/core/utils/utils.dart';

class GetRecallsBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;

  StreamController<bool> _isLoadingController =
      StreamController<bool>.broadcast();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;
  TextEditingController txtVin = TextEditingController();
  List<VehicleProfile> arrVehicle = [];
  int selectedVehicle = 0;
  bool isLoaded = false;

  @override
  void dispose() {
    mainStreamController.close();
    _isLoadingController.close();
  }

  bool checkValidation() {
    if (Validation.checkIsEmpty(
        textEditingController: txtVin, msg: StringConstants.Please_enter_vin)) {
      _isLoadingController.sink.add(false);
      return false;
    } else {
      return true;
    }
  }

  void btnSubmitClicked({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    _isLoadingController.sink.add(true);
    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .recallByVin(
            vin_number: txtVin.text,
          )
          .then((value) {
        getRecall(context: context, recall: value);
      }).catchError((onError) {
        _isLoadingController.sink.add(false);
        print(onError);
      });
    }
  }

  void getRecall({BuildContext? context, dynamic recall}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .recallByVin(vin_number: txtVin.text)
          .then((value) {
        Map<String, dynamic> d = value;
        Navigator.of(context, rootNavigator: false).pushNamed(RouteName.output,
            arguments: ItemArgument(data: {'recall': recall, 'vehicle': d}));
      }).catchError((onError) {
        print(onError);
      });
    }
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
        mainStreamController.sink.add(true);
      });
    }
  }
}
