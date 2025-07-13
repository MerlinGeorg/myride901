import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class SearchFromVINBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();
  TextEditingController vinController = TextEditingController();

  Stream<bool> get mainStream => mainStreamController.stream;

  @override
  void dispose() {
    mainStreamController.close();
  }

  bool checkValidation() {
    if (Validation.checkIsEmpty(
        textEditingController: vinController,
        msg: StringConstants.Please_enter_vin)) {
      return false;
    }
    // else  if (Validation.checkLength(
    //     textEditingController: vinController,
    //     msg: StringConstants.Please_valid_vin,length: 17)) {
    //   return false;
    // }
    else {
      return true;
    }
  }

  void btnAddClicked({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .searchbyVinNumber(vin_number: vinController.text)
          .then((value) {
        Navigator.pushNamed(context, RouteName.vinFinal,
            arguments: ItemArgument(data: {'data': value}));
      }).catchError((onError) {
        print(onError);
      });
    }
  }
}
