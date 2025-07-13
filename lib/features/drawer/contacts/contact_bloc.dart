import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/service_provider/service_provider.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class ServiceProviderBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;

  List<VehicleProvider> arrProvider = [];
  VehicleProvider? vehicleProvider;
  bool isLoaded = false;

  @override
  void dispose() {
    mainStreamController.close();
  }

  void getProviderList({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getProvider()
        .then((value) {
      isLoaded = true;
      arrProvider = [];
      arrProvider = value;
      arrProvider.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

      AppComponentBase.getInstance().setArrVehicleProvider(arrProvider);

      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void deleteProvider({BuildContext? context, int? index}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .deleteProvider(arrProvider[index!])
        .then((value) {
      CommonToast.getInstance()
          .displayToast(message: 'Contact Deleted Successfully!');
      arrProvider.removeAt(index);
      AppComponentBase.getInstance().setArrVehicleProvider(arrProvider);

      if (arrProvider.length > 0) {
        getProviderList(context: context, isProgressBar: false);
      }
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void btnClicked({BuildContext? context, int? index}) {
    Navigator.of(context!, rootNavigator: false)
        .pushNamed(RouteName.editProvider,
            arguments: ItemArgument(data: {
              'vehicleProvider': arrProvider[index!],
            }))
        .then((value) {
      print(arrProvider[index]);
    });
  }
}
