import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myride901/models/login_data/login_data.dart';

class SharedPreference extends SharedPreferenceRepository {
  SharedPreferences? _pref;

  final String _userDetails = "user_details";
  final String _sv = "sv";
  final String _name = "name";
  final String _shouldDisplayEndTrialPopup = "should_display_end_trial_popup";

  @override
  Future<LoginData?> getUserDetail() async {
    _pref = await initPreference();

    String userDetail = _pref?.getString(_userDetails) ?? "";
    LoginData? user;

    print(" +++++++++++++++ ${_pref?.getKeys()} - userDetail: $userDetail");
    if (userDetail.isNotEmpty) {
      var jsonDecoded = jsonDecode(userDetail);
      user = LoginData.fromJson(jsonDecoded);
    }
    return user;
  }

  @override
  Future<bool?> clearData() async {
    _pref = await initPreference();
    return _pref?.clear();
  }

  Future<SharedPreferences> initPreference() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<bool?> setUserDetail(LoginData? user) async {
    _pref = await initPreference();
    if (user == null) {
      return _pref?.remove(_userDetails);
    } else {
      return _pref?.setString(_userDetails, jsonEncode(user));
    }
  }

  @override
  Future<bool?> setSelectedVehicle(String? id) async {
    _pref = await initPreference();
    if (id == null) {
      return _pref?.remove(_sv);
    } else {
      return _pref?.setString(_sv, id);
    }
  }

  @override
  Future<String> getSelectedVehicle() async {
    _pref = await initPreference();
    return _pref?.getString(_sv) ?? "0";
  }

  @override
  Future<bool> getShouldReminderTrialEnd() async {
    _pref = await initPreference();
    final value = _pref?.getBool(_shouldDisplayEndTrialPopup);
    debugPrint("---> value $value ");
    return value == false ? false : true;
  }

  @override
  Future<bool?> setShouldReminderTrialEnd(bool value) async {
    _pref = await initPreference();
    final save = _pref?.setBool(_shouldDisplayEndTrialPopup, value);
    debugPrint("---> setShouldReminderTrialEnd value $value ");

    return save;
  }

  @override
  Future<bool?> setUserName(LoginData? user) async {
    _pref = await initPreference();
    if (user == null) {
      return _pref?.remove(_name);
    } else {
      return _pref?.setString(_name, jsonEncode(user));
    }
  }

  @override
  Future<LoginData?> getUserName() async {
    _pref = await initPreference();
    String userDetail = _pref?.getString(_name) ?? "";
    LoginData? user;
    if (userDetail.isNotEmpty) {
      var jsonDecoded = jsonDecode(userDetail);
      user = LoginData.fromJson(jsonDecoded);
    }
    return user;
  }

  @override
  Future<bool?> clearAccidentReport() async {
    _pref = await initPreference();

    String userDetail = _pref?.getString(_userDetails) ?? "";
    String sv = _pref?.getString(_sv) ?? "";
    String name = _pref?.getString(_name) ?? "";

    print("--> before clear - remove key ${_pref?.getKeys()}");
    _pref?.clear();

    _pref?.setString(_userDetails, userDetail);
    _pref?.setString(_sv, sv);
    _pref?.setString(_name, name);

    print("--> after clear - key ${_pref?.getKeys()}");

    return true;
  }

  Future<void> saveWalletCardOrder(List<String> order, int? vehicleId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('walletCardOrder_$vehicleId',
        order); // Since 'order' is already a List<String>
  }
}

abstract class SharedPreferenceRepository {
  Future<LoginData?> getUserDetail();

  Future<bool?> setUserDetail(LoginData? user);

  Future<bool?> clearData();

  Future<void> saveWalletCardOrder(List<String> order, int vehicleId);

  Future<bool?> setSelectedVehicle(String? id);

  Future<String> getSelectedVehicle();
  Future<LoginData?> getUserName();
  Future<bool?> setUserName(LoginData? user);

  Future<bool?> clearAccidentReport();
  Future<bool> getShouldReminderTrialEnd();
  Future<bool?> setShouldReminderTrialEnd(bool value);
}
