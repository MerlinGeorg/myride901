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
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/share/widget/vehicle_selection_bottom_sheet.dart';

class ShareBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  List<VehicleProfile> arrVehicle = [];
  List<VehicleService> arrService = [];
  VehicleProvider? vehicleProvider;

  User? user;
  int selectedVehicle = 0;
  bool isDisplaySelectionCheckBox = false;
  bool isLoaded = false;
  String vehicleId = "";

  List<String> emailsVehiclePermission = [];
  List<String> editVehiclePermission = [];

  @override
  void dispose() {
    mainStreamController.close();
  }

  getArrServiceLength() => arrVehicle[selectedVehicle].isMyVehicle == 1
      ? (arrService.length + 2)
      : (arrService.length + 1);

  void selectDisSelectAllArrService(bool isSelect) {
    for (int i = 0; i < arrService.length; i++) {
      arrService[i].isSelected = isSelect;
    }
  }

  bool isAllSelected() {
    bool check = true;
    for (int i = 0; i < arrService.length; i++) {
      if (arrService[i].isSelected == null ||
          !(arrService[i].isSelected ?? false)) {
        check = false;
      }
    }
    return check;
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
        isLoaded = true;
        mainStreamController.sink.add(true);
      });
    }
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

  void selectVehicle(BuildContext context, Function onCall) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return VehicleSelectionBottomSheet(
            arrVehicleProfile: arrVehicle,
            index: selectedVehicle,
            onlyMy: false,
            onTap: (index) {
              isDisplaySelectionCheckBox = false;
              selectedVehicle = index;
              mainStreamController.sink.add(true);
              AppComponentBase.getInstance()
                  .getSharedPreference()
                  .setSelectedVehicle(
                      arrVehicle[selectedVehicle].id.toString());
              arrService = [];
              mainStreamController.sink.add(true);
              getServiceList(context: context, isProgressBar: true);
              vehicleId = arrVehicle[selectedVehicle].id.toString();
              getSharedVehiclePermission(
                  vehicleId: arrVehicle[selectedVehicle].id.toString());
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

  void serviceEventSelected(
      {BuildContext? context, int? index, String message = ''}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicleProviderByProviderId(
          providerId: arrService[index!].serviceProviderId.toString(),
          id: arrService[index].serviceProviderId.toString(),
        )
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
        arrVehicle = AppComponentBase.getInstance().getArrVehicleProfile();
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

  void serviceEventSelected2({BuildContext? context, int? index}) {
    Navigator.of(context!, rootNavigator: false)
        .pushNamed(RouteName.serviceDetail,
            arguments: ItemArgument(data: {
              'vehicleProfile': arrVehicle[selectedVehicle],
              'vehicleService': arrService[index!],
            }))
        .then((value) {
      arrVehicle = AppComponentBase.getInstance().getArrVehicleProfile();
      setLocalData();

      getServiceList(
          context: context,
          isProgressBar:
              !AppComponentBase.getInstance().isArrVehicleProfileFetch);
    });
  }

  void btnShareClicked({BuildContext? context}) {
    if (isDisplaySelectionCheckBox) {
      String serviceIds = '';
      for (int i = 0; i < arrService.length; i++) {
        if (arrService[i].isSelected != null && arrService[i].isSelected!) {
          serviceIds = serviceIds + '${arrService[i].id.toString()},';
        }
      }
      if (serviceIds.length == 0) {
        CommonToast.getInstance().displayToast(
            message: StringConstants.Please_select_atleast_one_service_event);
      } else {
        serviceIds = serviceIds.substring(0, serviceIds.length - 1);
      }
      if (serviceIds != '') {
        isDisplaySelectionCheckBox = !isDisplaySelectionCheckBox;
        selectDisSelectAllArrService(false);
        mainStreamController.sink.add(true);
        Navigator.pushNamed(context!, RouteName.serviceShareOption,
            arguments: ItemArgument(data: {
              'vehicleProfile': arrVehicle[selectedVehicle],
              'serviceIds': serviceIds,
              'isShareVehicle': true
            }));
      }
    } else {
      isDisplaySelectionCheckBox = !isDisplaySelectionCheckBox;
    }
    mainStreamController.sink.add(true);
  }

  void btnPurchaseDateClicked({BuildContext? context, String? date}) {
    VehicleProfile vehicleProfile = arrVehicle[selectedVehicle];
    vehicleProfile.PDate = date;
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .updateVehicle(
            body_trim: vehicleProfile.Body ?? '',
            current_date: vehicleProfile.CDate ?? '',
            current_mileage: vehicleProfile.CKm ?? '',
            drive: vehicleProfile.Drive ?? '',
            engine: vehicleProfile.Engine ?? '',
            feature_image: [],
            license_plate: vehicleProfile.LicensePlate ?? '',
            make_company: vehicleProfile.Make ?? '',
            mileage_unit: vehicleProfile.mileageUnit ?? '',
            model: vehicleProfile.Model ?? '',
            nick_name: vehicleProfile.Nickname ?? '',
            notes: vehicleProfile.note ?? '',
            previous_date: vehicleProfile.PDate ?? '',
            previous_mileage: vehicleProfile.PKm ?? '',
            price: vehicleProfile.Price ?? '',
            set_profile_index: '',
            vin_number: vehicleProfile.VIN ?? '',
            image_dates: [],
            image_type: [],
            year: vehicleProfile.Year ?? '',
            currency: vehicleProfile.currency ?? '',
            delete_image: '',
            reset_as_profile_image: '',
            vehicle_id: vehicleProfile.id)
        .then((value) {
      arrVehicle[selectedVehicle] = vehicleProfile;
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void openCalender({BuildContext? context}) async {
    AppThemeState _appTheme = AppThemeState();
    var date = await showDatePicker(
      context: context!,
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
      initialDate: DateTime.now(),
      firstDate: DateTime(1901),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      btnPurchaseDateClicked(
          context: context,
          date: DateFormat(AppComponentBase.getInstance()
                  .getLoginData()
                  .user
                  ?.date_format)
              .format(date));
    }
  }

  void revokeTimelinePermission({BuildContext? context, int? vehicleId}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .revokeTimelinePermission(vehicle_id: vehicleId)
        .then((value) {
      CommonToast.getInstance().displayToast(message: value);
      print(value);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<void> getSharedVehiclePermission({String? vehicleId}) async {
    emailsVehiclePermission = [];
    editVehiclePermission = [];
    await AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehiclePermissionByVehicleId(vehicleId: vehicleId)
        .then((value) {
      (value["user_emails"] ?? []).forEach((e) {
        emailsVehiclePermission.add(e);
        editVehiclePermission.add("0");
      });
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void updateVehiclePermission(
      {String? vehicleId,
      List<String>? emails,
      List<String>? permissions,
      String? emailToDelete}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .editVehiclePermission(
            vehicle_id: vehicleId,
            delete_email: emailToDelete,
            email: emails,
            is_edit: permissions)
        .then((value) {
      getSharedVehiclePermission(vehicleId: vehicleId);
    }).catchError((onError) {
      print(onError);
    });
  }
}
