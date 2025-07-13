import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/service_provider/service_provider.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class AddProviderBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  TextEditingController? name = TextEditingController();
  TextEditingController? email = TextEditingController();
  TextEditingController? phone = TextEditingController();
  TextEditingController? address = TextEditingController();
  TextEditingController? street = TextEditingController();
  TextEditingController? postal_code = TextEditingController();
  TextEditingController? country = TextEditingController();
  TextEditingController? city = TextEditingController();
  TextEditingController? province = TextEditingController();

  List<String> addressList = [];
  List<String> streetList = [];
  List<String> cityList = [];
  List<String> postalList = [];
  List<String> provinceList = [];
  List<String> countryList = [];

  VehicleProvider? provider;

  @override
  void dispose() {
    mainStreamController.close();
  }

  Future<void> getProviderAddress({BuildContext? context}) async {
    try {
      var value = await AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .getProviderAddress(params: address!.text);

      addressList = value['description'];
      streetList = value['street'];

      mainStreamController.sink.add(true);
    } catch (error) {
      print(error);
      throw Exception('Error occurred while getting autocomplete');
    }
  }

  Future<void> getProviderAddresses(
      {BuildContext? context, String? val}) async {
    try {
      var location = val!;
      var value = await AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .getProviderAddress(params: location);

      streetList = value['street'];
      cityList = value['city'];
      postalList = value['postal_code'];
      provinceList = value['province'];
      countryList = value['country'];

      street?.text = streetList.first;
      city?.text = cityList.first;
      postal_code?.text = postalList.first;
      province?.text = provinceList.first;
      country?.text = countryList.first;

      mainStreamController.sink.add(true);
    } catch (error) {
      print(error);
      throw Exception('Error occurred while getting autocomplete');
    }
  }

  bool checkValidation() {
    if (email!.text != '' &&
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email!.text)) {
      CommonToast.getInstance()
          .displayToast(message: StringConstants.pleaseEnterValidEmail);
      return false;
    } else if (phone!.text != '' &&
        !RegExp(r"^\([0-9]{3}\) [0-9]{3}-[0-9]{4}").hasMatch(phone!.text)) {
      CommonToast.getInstance()
          .displayToast(message: StringConstants.pleaseEnterValidPhoneNumber);
      return false;
    } else {
      return true;
    }
  }

  void addProvider({BuildContext? context}) {
    if (checkValidation()) {
      FocusScope.of(context!).requestFocus(FocusNode());
      if (checkValidation()) {
        AppComponentBase.getInstance()
            .getApiInterface()
            .getVehicleRepository()
            .addProvider(
                name: name?.text ?? '',
                email: email?.text ?? '',
                phone: phone?.text ?? '',
                address: address?.text ?? '',
                city: city?.text ?? '',
                street: street?.text ?? '',
                country: country?.text ?? '',
                province: province?.text ?? '',
                postal_code: postal_code?.text ?? '')
            .then((value) {
          CommonToast.getInstance()
              .displayToast(message: StringConstants.contact_added);
          Navigator.pushNamed(context, RouteName.serviceProvider);
        }).catchError((onError) {
          print(onError);
        });
      }
    }
  }
}
