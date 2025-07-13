import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/service_provider/service_provider.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/reminders/widgets/event_list.dart';

class AddReminderBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  TextEditingController? name = TextEditingController();
  TextEditingController? date = TextEditingController();
  TextEditingController? serviceId = TextEditingController();
  TextEditingController? notes = TextEditingController();
  TextEditingController? timezone = TextEditingController();
  int selectedVehicle = 0;
  List<VehicleProfile> arrVehicle = [];
  List<VehicleService> arrService = [];
  VehicleService? vehicleService;
  VehicleProvider? vehicleProvider;
  String val = "add";
  bool passed = false;
  var arguments;

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
        setLocalData();
      }
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void addReminder({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .addReminder(
          reminderName: name?.text,
          serviceId: serviceId?.text,
          vehicleId: arrVehicle[selectedVehicle].id.toString(),
          reminderDate: date?.text,
          timezone: timezone?.text,
          notes: notes?.text ?? '',
        )
        .then((value) {
      Navigator.pushNamed(context, RouteName.reminders);
    }).catchError((onError) {
      print(onError);
    });
  }

  void getServiceList({BuildContext? context, bool? isProgressBar}) {
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
    }).catchError((onError) {
      print(onError);
    });
  }

  void openSheetEvent({BuildContext? context}) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        context: context!,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
                expand: false,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Column(children: <Widget>[
                    Expanded(
                        child: (arrService.length == 0)
                            ? Center(
                                child: Text(
                                  'You do not have any service events',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color:
                                          Color(0xff121212).withOpacity(0.4)),
                                ),
                              )
                            : EventList(
                                list: arrService.toList(),
                                vehicleProfile: arrVehicle.length > 0
                                    ? arrVehicle[selectedVehicle]
                                    : VehicleProfile.fromJson({}),
                                onTap: (index) {
                                  vehicleService = arrService[index];
                                  serviceId?.text =
                                      vehicleService?.id.toString() ?? '';
                                  mainStreamController.sink.add(true);
                                  Navigator.pop(context);
                                },
                              ))
                  ]);
                });
          });
        });
  }

  void btnClicked({BuildContext? context, String message = ''}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicleProviderByProviderId(
          providerId: vehicleService!.serviceProviderId.toString(),
          id: vehicleService!.serviceProviderId.toString(),
        )
        .then((value) {
      if (value.length > 0) {
        if (message != '') {
          CommonToast.getInstance().displayToast(message: message);
        }
        vehicleProvider = value[0];
      }
      List<String> reminderData = [
        name?.text ?? '',
        date?.text ?? '',
        notes?.text ?? '',
      ];
      mainStreamController.sink.add(true);
      Navigator.of(context!, rootNavigator: false)
          .pushNamed(RouteName.serviceDetail,
              arguments: ItemArgument(data: {
                'vehicleProfile': arrVehicle[selectedVehicle],
                'vehicleService': vehicleService!,
                'vehicleProvider': vehicleProvider,
                'reminderData': reminderData,
                'value': val,
                'isReminder': true,
              }))
          .then((value) {
        getVehicleList(context: context, isProgressBar: false);
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  void btnClicked2({BuildContext? context}) {
    List<String> reminderData = [
      name?.text ?? '',
      date?.text ?? '',
      notes?.text ?? '',
    ];
    Navigator.of(context!, rootNavigator: false)
        .pushNamed(RouteName.serviceDetail,
            arguments: ItemArgument(data: {
              'vehicleProfile': arrVehicle[selectedVehicle],
              'vehicleService': vehicleService!,
              'reminderData': reminderData,
              'value': val,
              'isReminder': true,
            }))
        .then((value) {
      getVehicleList(context: context, isProgressBar: false);
    });
  }

  void nextService({BuildContext? context}) {
    List<String> reminderData = [
      name?.text ?? '',
      date?.text ?? '',
      notes?.text ?? '',
    ];
    Navigator.of(context!, rootNavigator: false)
        .pushNamed(RouteName.getMaintenance,
            arguments: ItemArgument(data: {
              'value': val,
              'reminderData': reminderData,
            }))
        .then((value) {});
  }
}
