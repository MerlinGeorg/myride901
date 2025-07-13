import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/reminder/reminder.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/core/services/analytic_services.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/service_event/widget/service_event_bloc_utils.dart';
import 'package:myride901/models/service_provider/service_provider.dart';

class EditServiceEventBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  int selectedVehicle = 0;
  var arguments;
  List<VehicleProfile>? arrVehicle;
  VehicleService? vehicleService;
  VehicleProvider? vehicleProvider;
  List<VehicleProvider> arrProvider = [];
  List<Details> arrServiceList = [];
  List<Details> arrServiceListVerify = [];
  List<Attachments> profilePic = [];
  List<Attachments> docsVerify = [];
  String delete_image = '';
  String selectedAvatar = '1';
  TextEditingController txtDate = TextEditingController();
  TextEditingController? txtProvId = TextEditingController();
  TextEditingController txtEventName = TextEditingController();
  TextEditingController txtMile = TextEditingController();
  TextEditingController? txtEmail = TextEditingController();
  TextEditingController? txtName = TextEditingController();
  TextEditingController? txtPhoneNum = TextEditingController();
  TextEditingController txtNote = TextEditingController();
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
  List<dynamic>? data;
  int selectedIndex = 0;
  bool isLoaded = false;
  String? formDate;
  File? attachUrl;
  String? type;
  String? extensionT;
  bool? isReminder;
  bool? isReminderEdit;
  List<String>? reminderData;
  String? val;
  Reminder? reminder;

  @override
  void dispose() {
    mainStreamController.close();
    addressList = [];
  }

  void deleteServiceAtIndex(int index) {
    arrServiceListVerify.removeAt(index);
    mainStreamController.sink.add(true);
  }

  Future<void> scanImage({BuildContext? context, String? base64image}) async {
    try {
      var value = await AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .scanImage(base64image: base64image);
      arrServiceListVerify.addAll(value.map((item) => Details(
            description: item['description'],
            category: item['category_id'].toString(),
            categoryName: item['category'],
            price: item['amount'].toString(),
          )));
      locator<AnalyticsService>().sendAnalyticsEvent(
          eventName: "ScanButtonClicked", clickevent: "User scanning document");

      mainStreamController.sink.add(true);
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  void getVehicleList({BuildContext? context}) async {
    arrVehicle = AppComponentBase.getInstance().getArrVehicleProfile();
    if (arguments['vehicleProfile'] != null) {
      arguments =
          (ModalRoute.of(context!)!.settings.arguments as ItemArgument).data;
      VehicleProfile vehicleProfile = arguments['vehicleProfile'];
      if (arguments['isEdit']) {
        for (int i = 0; i < (arrVehicle ?? []).length; i++) {
          if (vehicleProfile.id == (arrVehicle ?? [])[i].id) {
            selectedVehicle = i;
          }
        }
      }
    } else if (!arguments['isEdit']) {
      selectedVehicle = arguments['selectedVehicle'] ?? 0;
      //
      await AppComponentBase.getInstance()
          .getSharedPreference()
          .getSelectedVehicle()
          .then((value) {
        for (int i = 0; i < (arrVehicle ?? []).length; i++) {
          if ((arrVehicle ?? [])[i].id.toString() == value) {
            selectedVehicle = i;
          }
        }
        AppComponentBase.getInstance().getSharedPreference().setSelectedVehicle(
            (arrVehicle ?? [])[selectedVehicle].id.toString());
        getServiceList(context: context!, isProgressBar: false);
      });
    }

    mainStreamController.sink.add(true);
  }

  void getServiceList({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicleService(
            vehicleId: (arrVehicle ?? [])[selectedVehicle].id.toString(),
            id: (arrVehicle ?? [])[selectedVehicle].id.toString(),
            isProgressBar: isProgressBar!)
        .then((value) {
      AppComponentBase.getInstance().setArrVehicleService(value);
    }).catchError((onError) {
      print(onError);
    });
  }

  void getProviderList({BuildContext? context}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getProvider()
        .then((value) {
      isLoaded = true;
      arrProvider = [];
      AppComponentBase.getInstance().setArrVehicleProvider(value);
      arrProvider = value;
      arrProvider.sort((a, b) {
        String nameA = a.name?.toLowerCase() ?? '';
        String nameB = b.name?.toLowerCase() ?? '';
        return nameA.compareTo(nameB);
      });
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void addProvider({BuildContext? context}) async {
    if (checkUserInfos(txtName, txtEmail, txtPhoneNum)) {
      FocusScope.of(context!).requestFocus(FocusNode());
      try {
        await AppComponentBase.getInstance()
            .getApiInterface()
            .getVehicleRepository()
            .addProvider(
                name: txtName?.text ?? '',
                email: txtEmail?.text ?? '',
                phone: txtPhoneNum?.text ?? '',
                address: address?.text ?? '',
                city: city?.text ?? '',
                street: street?.text ?? '',
                country: country?.text ?? '',
                province: province?.text ?? '',
                postal_code: postal_code?.text ?? '');

        arrProvider = await getProviderList2(context: context);
        vehicleProvider = arrProvider.first;
        txtProvId?.text = vehicleProvider?.id.toString() ?? '';
        txtPhoneNum!.clear();
        txtEmail!.clear();
        txtName!.clear();
        mainStreamController.sink.add(true);
        Navigator.pop(context);
      } catch (error) {
        print(error);
      }
    }
  }

  Future<List<VehicleProvider>> getProviderList2(
      {BuildContext? context}) async {
    try {
      List<VehicleProvider> value = await AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .getProvider();

      arrProvider = [];
      AppComponentBase.getInstance().setArrVehicleProvider(value);
      arrProvider = value;
      mainStreamController.sink.add(true);

      return value;
    } catch (error) {
      print(error);
      throw error;
    }
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

  void getServiceList2({BuildContext? context, String? value}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicleService(
            vehicleId: (arrVehicle ?? [])[selectedVehicle].id.toString(),
            id: (arrVehicle ?? [])[selectedVehicle].id.toString(),
            isProgressBar: true)
        .then((values) {
      AppComponentBase.getInstance().setArrVehicleService(values);
      AppComponentBase.getInstance().load(true);
      if (data != null) {
        CommonToast.getInstance().displayToast(message: value ?? '');

        Navigator.of(context!)
            .popUntil(ModalRoute.withName(RouteName.dashboard));
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void getVehicleProviderByProviderId(
      {BuildContext? context, bool isScroll = false, String message = ''}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicleProviderByProviderId(
          providerId: vehicleProvider?.id.toString(),
          id: vehicleProvider?.id.toString(),
        )
        .then((value) {
      if (message != '') {
        CommonToast.getInstance().displayToast(message: message);
      }
      if (value.length > 0) {
        vehicleProvider = value[0];
      }
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void btnUpdateClicked({BuildContext? context}) {
    showLoading(context);
    if (checkEventInfo(txtEventName, txtDate, txtMile)) {
      List<File> img = [];
      List<String> attachmentDates = [];
      List<String> attachmentTypes = [];
      List<String> category = [];
      List<String> description = [];
      List<String> price = [];
      for (var a in profilePic) {
        if (a.type == 'file' && selectedIndex != 1) {
          img.add(a.attachmentUrl);
          attachmentDates.add(a.createdAt ?? '');
          attachmentTypes.add(a.docType ?? '');
        }
      }
      for (var a in arrServiceList) {
        category.add(a.category ?? '');
        description.add(a.description ?? '');
        price.add(a.price ?? '');
      }

      if (delete_image.length > 0 &&
          delete_image[0] == ',' &&
          selectedIndex != 1) {
        delete_image = delete_image.substring(1);
      }

      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .updateServiceEvent(
              vehicle_id: (arrVehicle ?? [])[selectedVehicle].id.toString(),
              serviceProviderId: txtProvId!.text,
              notes: txtNote.text,
              category: category,
              description: description,
              mileage: txtMile.text,
              service_attachment: img,
              avatar: selectedAvatar,
              service_date: txtDate.text,
              price: price,
              attachment_dates: attachmentDates,
              attachment_type: attachmentTypes,
              title: txtEventName.text,
              eventId: vehicleService?.id,
              delete_attachment: delete_image)
          .then((value) {
        CommonToast.getInstance().displayToast(message: value);
        if (isReminder == true) {
          AppComponentBase.getInstance()
              .getApiInterface()
              .getVehicleRepository()
              .getVehicleServiceByServiceId(
                  vehicle_id: (arrVehicle ?? [])[selectedVehicle].id.toString(),
                  id: vehicleService?.id.toString(),
                  serviceId: vehicleService?.id.toString())
              .then((value) {
            print('Nikitos' + (value[0].title ?? ''));

            Navigator.of(context!).pushReplacementNamed(
              RouteName.addReminder,
              arguments: ItemArgument(data: {
                'value': value[0],
                'reminderData': reminderData,
              }),
            );
          }).catchError((onError) {
            print(onError);
          });
        } else if (isReminderEdit == true) {
          AppComponentBase.getInstance()
              .getApiInterface()
              .getVehicleRepository()
              .getVehicleServiceByServiceId(
                  vehicle_id: (arrVehicle ?? [])[selectedVehicle].id.toString(),
                  id: vehicleService?.id.toString(),
                  serviceId: vehicleService?.id.toString())
              .then((value) {
            print('Nikitos' + (value[0].title ?? ''));

            Navigator.pushNamed(
              AppComponentBase.getInstance().currentContext,
              RouteName.editReminder,
              arguments: ItemArgument(data: {
                'value': value[0],
                'reminderData': reminderData,
                'reminder': reminder
              }),
            );
          }).catchError((onError) {
            print(onError);
          });
        } else {
          Navigator.of(context!, rootNavigator: true).pushNamedAndRemoveUntil(
              RouteName.dashboard, (route) => false,
              arguments: ItemArgument(data: {}));
        }
      }).catchError((onError) {
        if (onError.toString().contains('413')) {
          CommonToast.getInstance().displayToast(
              message:
                  "The total attachment size exceeds the maximum limit of 100 MB. Please reduce the file size and try again.");
          if (context != null) {
            Navigator.of(context)
                .popUntil(ModalRoute.withName(RouteName.editEvent));
          }
        } else {
          print(onError);
          if (context != null) {
            Navigator.of(context)
                .popUntil(ModalRoute.withName(RouteName.editEvent));
          }
        }
      });
    } else {
      Navigator.of(context!).popUntil(ModalRoute.withName(RouteName.editEvent));
    }
  }

  void btnUpdateClicked2({BuildContext? context}) {
    showLoading(context);
    if (checkEventInfo(txtEventName, txtDate, txtMile)) {
      List<File> img = [];
      List<String> attachmentDates = [];
      List<String> attachmentTypes = [];
      List<String> category = [];
      List<String> description = [];
      List<String> price = [];
      for (var a in profilePic) {
        if (a.type == 'file' && selectedIndex != 1) {
          img.add(a.attachmentUrl);
          attachmentDates.add(a.createdAt ?? '');
          attachmentTypes.add(a.docType ?? '');
        }
      }
      for (var a in arrServiceList) {
        category.add(a.category ?? '');
        description.add(a.description ?? '');
        price.add(a.price ?? '');
      }

      if (delete_image.length > 0 &&
          delete_image[0] == ',' &&
          selectedIndex != 1) {
        delete_image = delete_image.substring(1);
      }
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .updateServiceEvent(
              vehicle_id: (arrVehicle ?? [])[selectedVehicle].id.toString(),
              serviceProviderId: txtProvId!.text,
              notes: txtNote.text,
              category: category,
              description: description,
              mileage: txtMile.text,
              service_attachment: img,
              avatar: selectedAvatar,
              service_date: txtDate.text,
              price: price,
              attachment_dates: attachmentDates,
              attachment_type: attachmentTypes,
              title: txtEventName.text,
              eventId: vehicleService?.id,
              delete_attachment: delete_image)
          .then((value) {
        CommonToast.getInstance().displayToast(message: value);
      }).catchError((onError) {
        if (onError.toString().contains('413')) {
          CommonToast.getInstance().displayToast(
              message:
                  "The total attachment size exceeds the maximum limit of 100 MB. Please reduce the file size and try again.");
          if (context != null) {
            Navigator.of(context)
                .popUntil(ModalRoute.withName(RouteName.editEvent));
          }
        } else {
          print(onError);
          if (context != null) {
            Navigator.of(context)
                .popUntil(ModalRoute.withName(RouteName.editEvent));
          }
        }
      });
    } else {
      Navigator.of(context!).popUntil(ModalRoute.withName(RouteName.editEvent));
    }
  }
}
