import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/reminder/reminder.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class RemindersBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;

  List<Reminder> arrReminder = [];
  TextEditingController? date = TextEditingController();
  Reminder? reminder;
  bool isLoaded = false;
  int selectedVehicle = 0;
  List<VehicleProfile> arrVehicle = [];
  List<VehicleService> arrService = [];

  @override
  void dispose() {
    mainStreamController.close();
  }

  void getReminderList({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getReminder()
        .then((value) {
      isLoaded = true;
      arrReminder = value
          .where((reminder) =>
              reminder.vehicleId == arrVehicle[selectedVehicle].id.toString())
          .toList();

      arrReminder.sort((a, b) {
        DateTime dateA =
            DateTime.tryParse(a.reminderDate ?? '') ?? DateTime.now();
        DateTime dateB =
            DateTime.tryParse(b.reminderDate ?? '') ?? DateTime.now();
        return dateA.compareTo(dateB);
      });

      AppComponentBase.getInstance().setArrReminder(arrReminder);

      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
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

  void deleteReminder({BuildContext? context, int? index}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .deleteReminder(arrReminder[index!])
        .then((value) {
      CommonToast.getInstance()
          .displayToast(message: 'Reminder deleted successfully!');
      arrReminder.removeAt(index);
      AppComponentBase.getInstance().setArrReminder(arrReminder);

      if (arrReminder.length > 0) {
        getReminderList(context: context, isProgressBar: false);
      }
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<void> updateReminder({BuildContext? context, int? index}) async {
    String reminderDateString = arrReminder[index!].reminderDate!;

    String dateFormat =
        AppComponentBase.getInstance().getLoginData().user?.date_format ??
            'yyyy-MM-dd';

    DateTime currentDate = DateFormat(dateFormat).parse(reminderDateString);

    DateTime newReminderDate = currentDate.add(Duration(days: 7));

    String formattedDate = DateFormat(dateFormat).format(newReminderDate);

    try {
      await AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .updateReminder(
            reminderDate: formattedDate,
            reminderId: arrReminder[index].id,
            notes: arrReminder[index].notes,
            serviceId: arrReminder[index].serviceId ?? "",
            timezone: arrReminder[index].timezone,
            reminderName: arrReminder[index].reminderName,
          );

      CommonToast.getInstance().displayToast(message: "Reminder Snoozed!");
    } catch (onError) {
      print(onError);
    }
  }

  void btnClicked({BuildContext? context, int? index}) {
    Navigator.of(context!, rootNavigator: false)
        .pushNamed(RouteName.editReminder,
            arguments: ItemArgument(data: {
              'reminder': arrReminder[index!],
            }))
        .then((value) {
      print(arrReminder[index]);
    });
  }
}
