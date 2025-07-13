import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:myride901/core/services/api_interface.dart';
import 'package:myride901/core/services/network_manager.dart';
import 'package:myride901/core/services/shared_preference.dart';
import 'package:myride901/models/login_data/login_data.dart';
import 'package:myride901/models/reminder/reminder.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/models/service_provider/service_provider.dart';
import 'package:myride901/models/trip/trip.dart';

class AppComponentBase extends AppComponentBaseRepository {
  static AppComponentBase? _instance;
  NetworkManager _networkManager = NetworkManager();
  ApiInterface _apiInterface = ApiInterface();
  List<String> _currentlySyncingIds = [];
  StreamController<bool> _progressDialogStreamController =
      StreamController.broadcast();
  StreamController<bool> _disableWidgetStreamController =
      StreamController.broadcast();
  StreamController<bool> _hideKeyBoardStreamController =
      StreamController.broadcast();
  BuildContext? _context;
  BuildContext get currentContext => _context!;
  StreamSubscription<String>? _streamSubscription;
  Stream<bool> get progressDialogStream =>
      _progressDialogStreamController.stream;
  Stream<bool> get disableWidgetStream => _disableWidgetStreamController.stream;

  StreamController<dynamic> _loadStreamController =
      StreamController.broadcast();

  Stream<dynamic> get loadStream => _loadStreamController.stream;
  StreamController<dynamic> _changeIndexStreamController =
      StreamController.broadcast();

  Stream<dynamic> get changeIndexStream => _changeIndexStreamController.stream;

  Stream<bool> get hideKeyBoard => _hideKeyBoardStreamController.stream;
  LoginData _loginData = LoginData();
  //vehicle
  List<VehicleProfile> _arrVehicleProfile = [];
  bool _isArrVehicleProfileFetch = false;
  bool get isArrVehicleProfileFetch => _isArrVehicleProfileFetch;
  //trip
  List<Trip> _arrTrip = [];
  bool _isArrTripFetch = false;
  bool get isArrTripFetch => _isArrTripFetch;
  //reminder
  List<Reminder> _arrReminder = [];
  bool _isArrReminderFetch = false;
  bool get isArrReminderFetch => _isArrReminderFetch;
  //provider
  List<VehicleProvider> _arrVehicleProvider = [];
  bool _isArrVehicleProviderFetch = false;
  bool get isArrVehicleProviderFetch => _isArrVehicleProviderFetch;
  //service
  List<VehicleService> _arrVehicleService = [];
  bool _isArrVehicleServiceFetch = false;
  bool get isArrVehicleServiceFetch => _isArrVehicleServiceFetch;

  bool _isRedirect = false;
  bool get isRedirect => _isRedirect;
  bool _isVehicleEditable = false;
  bool get isVehicleEditable => _isVehicleEditable;
  static AppComponentBase getInstance() {
    if (_instance == null) {
      _instance = AppComponentBase();
    }
    return _instance!;
  }

  changeRedirect(bool direct) {
    _isRedirect = direct;
  }

  changeVehicleEditable(bool VehicleEditable) {
    _isVehicleEditable = VehicleEditable;
  }

  clearData() {
    _arrVehicleProfile = [];
    _arrVehicleService = [];
    _arrVehicleProvider = [];
    _arrTrip = [];
    _arrReminder = [];
    _isArrVehicleProfileFetch = false;
    _isArrVehicleProviderFetch = false;
    _isArrVehicleServiceFetch = false;
    _isArrTripFetch = false;
    _isArrReminderFetch = false;
    _loginData = LoginData();
  }

  setLoginData(LoginData loginData) {
    _loginData = loginData;
  }

  LoginData getLoginData() {
    return _loginData;
  }

  setArrVehicleProfile(List<VehicleProfile> arrVehicleProfile) {
    _arrVehicleProfile = arrVehicleProfile;
    _isArrVehicleProfileFetch = true;
  }

  List<VehicleProfile> getArrVehicleProfile({bool onlyMy = false}) {
    if (onlyMy) {
      return _arrVehicleProfile.where((i) => i.isMyVehicle == 1).toList();
    }
    return _arrVehicleProfile;
  }

  setArrVehicleService(List<VehicleService> arrVehicleService) {
    _arrVehicleService = arrVehicleService;
    _isArrVehicleServiceFetch = true;
  }

  List<VehicleService> getArrVehicleService({bool onlyMy = false}) {
    return _arrVehicleService;
  }

  setArrVehicleProvider(List<VehicleProvider> arrVehicleProvider) {
    _arrVehicleProvider = arrVehicleProvider;
    _isArrVehicleProviderFetch = true;
  }

  List<VehicleProvider> getArrVehicleProvider({bool onlyMy = false}) {
    return _arrVehicleProvider;
  }

  setArrTrip(List<Trip> arrTrip) {
    _arrTrip = arrTrip;
    _isArrTripFetch = true;
  }

  List<Trip> getArrTrip({bool onlyMy = false}) {
    return _arrTrip;
  }

  setArrReminder(List<Reminder> arrReminder) {
    _arrReminder = arrReminder;
    _isArrReminderFetch = true;
  }

  List<Reminder> getArrReminder({bool onlyMy = false}) {
    return _arrReminder;
  }

  setContext({BuildContext? context}) {
    _context = context;
  }

  initialiseNetworkManager() async {
    await _networkManager.initialiseNetworkManager();
  }

  removeSyncingId(String id) {
    _currentlySyncingIds.remove(id);
  }

  showProgressDialog(bool value) {
    _progressDialogStreamController.sink.add(value);
    disableWidgets(value);
  }

  disableWidgets(bool value) {
    _disableWidgetStreamController.sink.add(value);
  }

  load(dynamic value) {
    _loadStreamController.sink.add(value);
  }

  changeIndex(dynamic value) {
    _changeIndexStreamController.sink.add(value);
  }

  dismissKeyboard() {
    _hideKeyBoardStreamController.sink.add(true);
  }

  dispose() {
    _streamSubscription?.cancel();
    _progressDialogStreamController.close();
    _disableWidgetStreamController.close();
    _hideKeyBoardStreamController.close();
    _loadStreamController.close();
    _changeIndexStreamController.close();
  }

  @override
  ApiInterface getApiInterface() {
    return _apiInterface;
  }

  @override
  SharedPreference getSharedPreference() {
    return SharedPreference();
  }

  @override
  NetworkManager getNetworkManager() {
    return _networkManager;
  }

  syncForm(String id) {
    _currentlySyncingIds.add(id);
  }

  containsForm(String id) {
    return _currentlySyncingIds.contains(id);
  }
}

abstract class AppComponentBaseRepository {
  ApiInterface getApiInterface();

  SharedPreference getSharedPreference();

  NetworkManager getNetworkManager();
}
