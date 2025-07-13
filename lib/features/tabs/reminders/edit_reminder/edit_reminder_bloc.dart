import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/reminder/reminder.dart';
import 'package:myride901/models/service_provider/service_provider.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/reminders/widgets/event_list.dart';

import '../../../../models/vehicle_service/vehicle_service.dart';

class EditReminderBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;

  var arguments;
  List<Reminder>? arrReminder;
  Reminder? reminder;
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
  String val = "edit";
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

  void updateReminder({BuildContext? context}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .updateReminder(
          reminderName: name?.text,
          reminderDate: date?.text,
          notes: notes!.text,
          serviceId: serviceId?.text,
          timezone: timezone?.text,
          reminderId: reminder?.id,
        )
        .then((value) {
      CommonToast.getInstance()
          .displayToast(message: "Reminder Updated Successfully!");
      Navigator.pushNamed(context!, RouteName.reminders);
    }).catchError((onError) {
      print(onError);
    });
  }

  void getReminderById(
      {BuildContext? context, bool isScroll = false, String message = ''}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getReminderById(
          reminderId: reminder?.id.toString(),
          id: reminder?.id.toString(),
        )
        .then((value) {
      if (message != '') {
        CommonToast.getInstance().displayToast(message: message);
      }

      if (value.length > 0) {
        reminder = value[0];
        name!.text = reminder?.reminderName ?? '';
        date!.text = reminder?.reminderDate ?? '';
        notes!.text = reminder?.notes ?? '';
      }

      getVehicleById(context: context);

      isLoaded = true;
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void deleteReminder({BuildContext? context}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .deleteReminder(reminder!)
        .then((value) {
      CommonToast.getInstance()
          .displayToast(message: 'Reminder deleted successfully!');

      mainStreamController.sink.add(true);

      Navigator.of(context!, rootNavigator: true).pushNamedAndRemoveUntil(
          RouteName.reminders, (route) => false,
          arguments: ItemArgument(data: {}));
    }).catchError((onError) {
      print(onError);
    });
  }

  void getVehicleById({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicleProfileById(
            vehicleId: reminder!.vehicleId, id: reminder!.vehicleId)
        .then((value) {
      arrVehicle = value;
    }).catchError((onError) {
      print(onError);
    });
  }

  void getEventById({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicleServiceByServiceId(
            vehicle_id: reminder!.vehicleId,
            id: serviceId!.text,
            serviceId: serviceId!.text)
        .then((value) {
      vehicleService = value[0];
      mainStreamController.sink.add(true);
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
          providerId: vehicleService!.serviceProviderId,
          id: vehicleService!.serviceProviderId,
        )
        .then((value) {
      if (value.length > 0) {
        if (message != '') {
          CommonToast.getInstance().displayToast(message: message);
        }
        vehicleProvider = value[0];
      }
      mainStreamController.sink.add(true);
      List<String> reminderData = [
        name?.text ?? '',
        date?.text ?? '',
        notes?.text ?? '',
      ];
      Navigator.of(context!, rootNavigator: false)
          .pushNamed(RouteName.serviceDetail,
              arguments: ItemArgument(data: {
                'vehicleProfile': arrVehicle[0],
                'vehicleService': vehicleService!,
                'vehicleProvider': vehicleProvider,
                'isReminderEdit': true,
                'reminderData': reminderData,
                'reminder': reminder
              }))
          .then((value) {
        getVehicleById(context: context, isProgressBar: false);
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
              'vehicleProfile': arrVehicle[0],
              'vehicleService': vehicleService!,
              'isReminderEdit': true,
              'reminderData': reminderData,
              'reminder': reminder
            }))
        .then((value) {
      getVehicleById(context: context, isProgressBar: false);
    });
  }

  void nextService({BuildContext? context}) {
    Navigator.of(context!, rootNavigator: false)
        .pushNamed(RouteName.getMaintenance,
            arguments: ItemArgument(data: {
              'value': val,
              'reminder': reminder,
            }))
        .then((value) {});
  }
}
