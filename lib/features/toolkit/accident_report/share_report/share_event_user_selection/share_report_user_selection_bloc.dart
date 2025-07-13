import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/login_data/login_data.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/my_ride_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareReportUserSelectionBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  int isGuest = -1;
  TextEditingController txtSearch = TextEditingController();
  List<dynamic> arrUser = [];
  bool isLoading = true;
  User? user;

  @override
  void dispose() {
    mainStreamController.close();
  }

  void btnBackClicked({BuildContext? context}) {
    Navigator.pop(context!);
  }

  void btnSubmitClicked({BuildContext? context}) async {
    List<String> email = [];
    for (var i = 0; i < arrUser.length; i++) {
      if (arrUser[i]['is_shared'] == 1) {
        email.add(arrUser[i]['email']);
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(
        "-------------------------eee----------- $email ${prefs.getString("accident_id") ?? ""}  ${prefs.getString("vehicle_id")}");
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .shareAccidentReportPermission(
            report_id: prefs.getString("accident_id") ?? "",
            vehicle_id: prefs.getString("vehicle_id"),
            is_guest: isGuest.toString(),
            email: email)
        .then((value) {
      print("+++++++++++++ shared value $value");
      showDialog(
          context: context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox.accidentShare(
              onPress: () async {
                AppComponentBase.getInstance()
                    .getSharedPreference()
                    .clearAccidentReport();
                print(
                    "+++++++++++++ sharedPreferences clear in ShareReportPermissionBloc");
                Navigator.popUntil(
                    context, ModalRoute.withName(RouteName.dashboard));
              },
            );
          });
    }).catchError((onError) {
      print("onError ---> $onError");
    });
  }

  void getContactList({BuildContext? context, String search = ''}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .contactList(is_guest: isGuest)
        .then((value) {
      isLoading = false;
      arrUser = [];
      if (user?.email != null) {
        print("email added");
        arrUser.add({
          "email": user!.email,
          "user_name": user?.lastName ?? '',
          "is_shared": 1,
          "display_image": '',
        });
      }
      (value ?? []).forEach((e) {
        var e2 = e;
        e2['is_shared'] = 0;
        arrUser.add(e2);
      });
      arrUser.sort((a, b) => a["email"]
          .toString()
          .toLowerCase()
          .compareTo(b["email"].toString().toLowerCase()));

      mainStreamController.sink.add(true);
    }).catchError((onError) {
      isLoading = false;
      mainStreamController.sink.add(true);
      print(onError);
    });
  }

  void searchUser({BuildContext? context, String email = ''}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .searchUser(email: email)
        .then((value) {
      arrUser.add({
        "email": value["email"] ?? '',
        "user_name": value["user_name"] ?? '',
        "is_shared": 1,
        "display_image": value["display_image"] ?? '',
      });
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      isLoading = false;
      mainStreamController.sink.add(true);
      print(onError);
    });
  }
}
