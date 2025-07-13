import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/login_data/login_data.dart';
import 'package:myride901/models/service_provider/service_provider.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/share/widget/vehicle_selection_bottom_sheet.dart';

class SearchBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  List<VehicleProfile> arrVehicle = [];
  List<VehicleService> arrService = [];
  List<VehicleService> arrMainService = [];
  VehicleProvider? vehicleProvider;

  User? user;
  int selectedVehicle = 0;
  String fromDate = '';
  String toDate = '';
  TextEditingController fromMileage = TextEditingController();
  TextEditingController toMileage = TextEditingController();
  bool isLoaded = false;

  @override
  void dispose() {
    mainStreamController.close();
  }

  Future<void> setLocalData() async {
    if (AppComponentBase.getInstance().isArrVehicleProfileFetch) {
      await AppComponentBase.getInstance()
          .getSharedPreference()
          .getSelectedVehicle()
          .then((value) {
        arrVehicle = Utils.arrangeVehicle(
            AppComponentBase.getInstance().getArrVehicleProfile(),
            int.parse(value));
        arrService = AppComponentBase.getInstance().getArrVehicleService();
        selectedVehicle = 0;
        for (int i = 0; i < arrVehicle.length; i++) {
          if (arrVehicle[i].id.toString() == value) {
            selectedVehicle = i;
          }
        }
        if (arrVehicle.length < selectedVehicle) selectedVehicle = 0;
        if (arrVehicle.length > 0) {
          AppComponentBase.getInstance()
              .getSharedPreference()
              .setSelectedVehicle(arrVehicle[selectedVehicle].id.toString());
        }
        setDateText();
        setMileageText();
        arrMainService = arrService;
        filterData(true);
        isLoaded = true;
        mainStreamController.sink.add(true);
      });
    }
  }

  void btnClicked({BuildContext? context, int? index, String message = ''}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicleProviderByProviderId(
            providerId: arrService[index!].serviceProviderId.toString(),
            id: arrService[index].serviceProviderId.toString())
        .then((value) {
      if (value.length > 0) {
        if (message != '') {
          CommonToast.getInstance().displayToast(message: message);
        }
        vehicleProvider = value[0];
      }

      mainStreamController.sink.add(true);
      Navigator.of(context!, rootNavigator: false)
          .pushNamed(RouteName.serviceDetail,
              arguments: ItemArgument(data: {
                'vehicleProfile': arrVehicle[selectedVehicle],
                'vehicleService': arrService[index],
                'vehicleProvider': vehicleProvider,
              }))
          .then((value) {
        arrVehicle =
            AppComponentBase.getInstance().getArrVehicleProfile(onlyMy: false);
        setLocalData();
        getServiceList(
            context: context,
            isProgressBar:
                !AppComponentBase.getInstance().isArrVehicleProfileFetch);
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  void btnClicked2({BuildContext? context, int? index}) {
    Navigator.of(context!, rootNavigator: false)
        .pushNamed(RouteName.serviceDetail,
            arguments: ItemArgument(data: {
              'vehicleProfile': arrVehicle[selectedVehicle],
              'vehicleService': arrService[index!],
            }))
        .then((value) {
      arrVehicle =
          AppComponentBase.getInstance().getArrVehicleProfile(onlyMy: false);
      setLocalData();
      getServiceList(
          context: context,
          isProgressBar:
              !AppComponentBase.getInstance().isArrVehicleProfileFetch);
    });
  }

  void getVehicleList({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getShareVehicle(isProgressBar: isProgressBar!)
        .then((value) {
      if (value.length > 0) {
        AppComponentBase.getInstance().setArrVehicleProfile(value);
        arrVehicle = value;
        setLocalData().then((value) {
          getServiceList(context: context!, isProgressBar: isProgressBar);
        });
      } else {
        AppComponentBase.getInstance().setArrVehicleProfile([]);
      }
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void getServiceList({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getSharedPreference()
        .getSelectedVehicle()
        .then((value) {
      arrVehicle = Utils.arrangeVehicle(
          AppComponentBase.getInstance().getArrVehicleProfile(),
          int.parse(value));
      arrService = AppComponentBase.getInstance().getArrVehicleService();
      selectedVehicle = 0;
      for (int i = 0; i < arrVehicle.length; i++) {
        if (arrVehicle[i].id.toString() == value) {
          selectedVehicle = i;
        }
      }
      if (arrVehicle.length < selectedVehicle) selectedVehicle = 0;
      if (arrVehicle.length > 0) {
        AppComponentBase.getInstance()
            .getSharedPreference()
            .setSelectedVehicle(arrVehicle[selectedVehicle].id.toString());
      }
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .getVehicleService(
              vehicleId: arrVehicle[selectedVehicle].id.toString(),
              id: arrVehicle[selectedVehicle].id.toString(),
              isProgressBar: isProgressBar!)
          .then((value) {
        arrService = [];
        AppComponentBase.getInstance().setArrVehicleService(value);
        arrService = value;
        setLocalData();
      }).catchError((onError) {
        print(onError);
      });
    });
  }

  void openSheet(BuildContext context, Function onCall) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return VehicleSelectionBottomSheet(
            arrVehicleProfile: arrVehicle,
            index: selectedVehicle,
            onTap: (index) {
              selectedVehicle = index;
              mainStreamController.sink.add(true);
              AppComponentBase.getInstance()
                  .getSharedPreference()
                  .setSelectedVehicle(
                      arrVehicle[selectedVehicle].id.toString());
              arrService = [];
              mainStreamController.sink.add(true);
              getServiceList(context: context, isProgressBar: true);
              Navigator.pop(context);
            },
            btnAddVehicleProfileClicked: () {
              Navigator.of(context, rootNavigator: false)
                  .pushNamed(RouteName.addVehicleOption)
                  .then((value) {
                if (AppComponentBase.getInstance().isRedirect) {
                  AppComponentBase.getInstance().changeRedirect(false);
                  onCall();
                }
              });
            },
          );
        });
  }

  void setDateText() {
    DateTime startdate = DateFormat(
            AppComponentBase.getInstance().getLoginData().user?.date_format)
        .parse(DateFormat(
                AppComponentBase.getInstance().getLoginData().user?.date_format)
            .format(DateTime.now()));
    DateTime enddate = DateFormat(
            AppComponentBase.getInstance().getLoginData().user?.date_format)
        .parse(DateFormat(
                AppComponentBase.getInstance().getLoginData().user?.date_format)
            .format(DateTime.now()));

    for (int i = 0; i < arrService.length; i++) {
      if ((arrService[i].serviceDate ?? '') != "" &&
          DateFormat(AppComponentBase.getInstance()
                      .getLoginData()
                      .user
                      ?.date_format)
                  .parse(arrService[i].serviceDate ?? '')
                  .difference(startdate)
                  .inDays <
              0) {
        startdate = DateFormat(
                AppComponentBase.getInstance().getLoginData().user?.date_format)
            .parse(arrService[i].serviceDate ?? '');
      }
      if ((arrService[i].serviceDate ?? '') != "" &&
          DateFormat(AppComponentBase.getInstance()
                      .getLoginData()
                      .user
                      ?.date_format)
                  .parse(arrService[i].serviceDate ?? '')
                  .difference(enddate)
                  .inDays >
              0) {
        enddate = DateFormat(
                AppComponentBase.getInstance().getLoginData().user?.date_format)
            .parse(arrService[i].serviceDate ?? '');
      }
    }
    fromDate = DateFormat(
            AppComponentBase.getInstance().getLoginData().user?.date_format)
        .format(startdate);
    toDate = DateFormat(
            AppComponentBase.getInstance().getLoginData().user?.date_format)
        .format(enddate);
  }

  void setMileageText() {
    int startMileage = 0;
    int endMileage = 0;

    for (int i = 0; i < arrService.length; i++) {
      if ((arrService[i].mileage ?? '').trim() != "" && startMileage == 0) {
        startMileage =
            int.parse((arrService[i].mileage ?? '').replaceAll(',', ''));
      }
      if ((arrService[i].mileage ?? '').trim() != "" &&
          int.parse((arrService[i].mileage ?? '').replaceAll(',', '')) <
              startMileage) {
        startMileage =
            int.parse((arrService[i].mileage ?? '').replaceAll(',', ''));
      }
      if ((arrService[i].mileage ?? '').trim() != "" &&
          int.parse((arrService[i].mileage ?? '').replaceAll(',', '')) >
              endMileage) {
        endMileage =
            int.parse((arrService[i].mileage ?? '').replaceAll(',', ''));
      }
    }
    fromMileage.text = Utils.addComma(startMileage.toString());
    toMileage.text = Utils.addComma(endMileage.toString());
  }

  void filterData(bool isChangeDate) {
    arrService = [];
    int startMileage = fromMileage.text.trim() == ''
        ? 0
        : int.parse((fromMileage.text).replaceAll(',', ''));
    int endMileage = toMileage.text.trim() == ''
        ? 0
        : int.parse((toMileage.text).replaceAll(',', ''));
    for (int i = 0; i < arrMainService.length; i++) {
      bool isAdded = true;
      if ((fromDate).trim() != "" &&
          DateFormat(AppComponentBase.getInstance()
                      .getLoginData()
                      .user
                      ?.date_format)
                  .parse(arrMainService[i].serviceDate ?? '')
                  .difference(DateFormat(AppComponentBase.getInstance()
                          .getLoginData()
                          .user
                          ?.date_format)
                      .parse(fromDate))
                  .inDays <
              0) {
        isAdded = false;
      }
      print('jdjd');
      print(DateFormat(
              AppComponentBase.getInstance().getLoginData().user?.date_format)
          .parse(arrMainService[i].serviceDate ?? '')
          .difference(DateFormat(AppComponentBase.getInstance()
                  .getLoginData()
                  .user
                  ?.date_format)
              .parse(toDate))
          .inDays);
      if (isAdded &&
          (toDate).trim() != "" &&
          DateFormat(AppComponentBase.getInstance()
                      .getLoginData()
                      .user
                      ?.date_format)
                  .parse(arrMainService[i].serviceDate ?? '')
                  .difference(DateFormat(AppComponentBase.getInstance()
                          .getLoginData()
                          .user
                          ?.date_format)
                      .parse(toDate))
                  .inDays >
              0) {
        isAdded = false;
      }
      if (isAdded &&
          startMileage != 0 &&
          int.parse((arrMainService[i].mileage ?? '').replaceAll(',', '')) <
              startMileage &&
          !isChangeDate) {
        isAdded = false;
      }
      if (isAdded &&
          endMileage != 0 &&
          int.parse((arrMainService[i].mileage ?? '').replaceAll(',', '')) >
              endMileage &&
          !isChangeDate) {
        isAdded = false;
      }
      if (isAdded) {
        arrService.add(arrMainService[i]);
      }
    }
    if (isChangeDate) setMileageText();

    mainStreamController.sink.add(true);
  }

  Future<Null> fromDatePicker(BuildContext context) async {
    AppThemeState _appTheme = AppThemeState();
    FocusScope.of(context).requestFocus(FocusNode());
    final DateTime? picked = await showDatePicker(
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
        initialDate: fromDate != ""
            ? DateFormat(AppComponentBase.getInstance()
                    .getLoginData()
                    .user
                    ?.date_format)
                .parse(fromDate)
            : DateTime.now(),
        firstDate: DateTime(1901),
        lastDate: DateTime(2030));
    if (picked != null) {
      final DateFormat formatter = DateFormat(
          AppComponentBase.getInstance().getLoginData().user?.date_format);
      fromDate = formatter.format(picked);
      filterData(true);
    } else {
      fromDate = "";
      filterData(true);
    }
    mainStreamController.sink.add(true);
  }

  Future<Null> toDatePicker(BuildContext context) async {
    AppThemeState _appTheme = AppThemeState();
    FocusScope.of(context).requestFocus(FocusNode());
    final DateTime? picked = await showDatePicker(
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
        initialDate: toDate != ""
            ? DateFormat(AppComponentBase.getInstance()
                    .getLoginData()
                    .user
                    ?.date_format)
                .parse(toDate)
            : DateTime.now(),
        firstDate: DateTime(1901),
        lastDate: DateTime(2030));
    if (picked != null) {
      final DateFormat formatter = DateFormat(
          AppComponentBase.getInstance().getLoginData().user?.date_format);
      toDate = formatter.format(picked);
      filterData(true);
    } else {
      toDate = "";
      filterData(true);
    }
    mainStreamController.sink.add(true);
  }
}
