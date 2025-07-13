import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/toolkit/accident_report/widget/add_attachment_replica.dart';
import 'package:myride901/features/tabs/share/widget/vehicle_selection_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccidentReportFormBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;

  TextEditingController txtTime = TextEditingController();
  TextEditingController txtData = TextEditingController();
  TextEditingController txtStreet = TextEditingController();
  TextEditingController txtCity = TextEditingController();
  TextEditingController txtProvince = TextEditingController();
  TextEditingController txtMySpeed = TextEditingController();
  TextEditingController txtOtherDriverSpeed = TextEditingController();

  TextEditingController txtMyName = TextEditingController();
  TextEditingController txtMyAddress = TextEditingController();
  TextEditingController txtMyContactNumber = TextEditingController();
  TextEditingController txtLicensePlateNum = TextEditingController();
  TextEditingController txtDriverLicenseNum = TextEditingController();
  TextEditingController txtInsuranceCompanyNameAndPolicyNum =
      TextEditingController();
  TextEditingController txtVehicleMakeModelYear = TextEditingController();
  TextEditingController txtInjuriesDetail = TextEditingController();

  TextEditingController txtOtherDriverName = TextEditingController();
  TextEditingController txtOtherDriverAddress = TextEditingController();
  TextEditingController txtOtherDriverContactNumber = TextEditingController();
  TextEditingController txtOtherDriverLicensePlateNum = TextEditingController();
  TextEditingController txtOtherDriversDriverLicenseNum =
      TextEditingController();
  TextEditingController txtOtherDriverInsuranceCompanyNameAndPolicyNum =
      TextEditingController();
  TextEditingController txtOtherDriverVehicleMakeModelYear =
      TextEditingController();
  TextEditingController txtNameAddressDriverVehicle = TextEditingController();

  TextEditingController txtName = TextEditingController();
  TextEditingController txtBadgeNo = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtLocalPoliceDepartment = TextEditingController();
  TextEditingController txtIncidentReportNumber = TextEditingController();
  TextEditingController txtOccurrenceNumber = TextEditingController();

  TextEditingController txtWitnessName1 = TextEditingController();
  TextEditingController txtWitnessAddress1 = TextEditingController();
  TextEditingController txtWitnessLicensePlateNumber1 = TextEditingController();
  TextEditingController txtWitnessContact1 = TextEditingController();

  TextEditingController txtWitnessName2 = TextEditingController();
  TextEditingController txtWitnessAddress2 = TextEditingController();
  TextEditingController txtWitnessLicensePlateNumber2 = TextEditingController();
  TextEditingController txtWitnessContact2 = TextEditingController();

  TextEditingController txtWitnessName3 = TextEditingController();
  TextEditingController txtWitnessAddress3 = TextEditingController();
  TextEditingController txtWitnessLicensePlateNumber3 = TextEditingController();
  TextEditingController txtWitnessContact3 = TextEditingController();

  TextEditingController txtYourVehicleDamage = TextEditingController();
  TextEditingController txtOtherVehicleDamage = TextEditingController();
  TextEditingController txtAccidentHappen = TextEditingController();

  TextEditingController txtAdditionalInformation = TextEditingController();

  AccidentReportFormBloc() {
    txtData.text = DateFormat(
            AppComponentBase.getInstance().getLoginData().user?.date_format)
        .format(DateTime.now());
  }

  int mySpeedRadioGroup = 1;
  int otherSpeedRadioGroup = 1;

  DateTime? initSData;
  TimeOfDay? initTimeOfDay;

  List<Attachments> attachmentList = [];

  List<File> attachments = [];

  String delete_image = '';

  int selectedVehicle = 0;
  VehicleProfile? vehicleProfile;
  bool isDisplaySelectionCheckBox = false;
  bool isLoaded = false;
  List<VehicleProfile> arrVehicle = [];
  List<VehicleService> arrService = [];

  @override
  void dispose() {
    mainStreamController.close();
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
              id: arrVehicle[selectedVehicle].id.toString(),
              vehicleId: arrVehicle[selectedVehicle].id.toString(),
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

  void openSheet(BuildContext context, Function onCall) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (contexts) {
          return VehicleSelectionBottomSheet(
            arrVehicleProfile: arrVehicle,
            index: selectedVehicle,
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

  bool checkValidationPage2() {
    // return true;
    if (txtYourVehicleDamage.text.isEmpty) {
      txtYourVehicleDamage.text = "";
    }
    if (txtAccidentHappen.text.isEmpty) {
      txtAccidentHappen.text = "";
    }
    if (txtOtherVehicleDamage.text.isEmpty) {
      txtOtherVehicleDamage.text = "";
    }

    return true;
  }

  bool checkValidationPage3() {
    // return true;
    if (txtMyName.text.isEmpty) {
      txtMyName.text = "";
    }
    if (txtMyAddress.text.isEmpty) {
      txtMyAddress.text = "";
    }
    if (txtMyContactNumber.text.isEmpty) {
      txtMyContactNumber.text = "";
    }
    if (txtLicensePlateNum.text.isEmpty) {
      txtLicensePlateNum.text = "";
    }
    if (txtDriverLicenseNum.text.isEmpty) {
      txtDriverLicenseNum.text = "";
    }
    if (txtInsuranceCompanyNameAndPolicyNum.text.isEmpty) {
      txtInsuranceCompanyNameAndPolicyNum.text = "";
    }
    if (txtVehicleMakeModelYear.text.isEmpty) {
      txtVehicleMakeModelYear.text = "";
    }
    if (txtInjuriesDetail.text.isEmpty) {
      txtInjuriesDetail.text = "";
    }

    return true;
  }

  bool checkValidationPage4() {
    if (txtOtherDriverName.text.isEmpty) {
      txtOtherDriverName.text = "";
    }
    if (txtOtherDriverAddress.text.isEmpty) {
      txtOtherDriverAddress.text = "";
    }
    if (txtOtherDriverContactNumber.text.isEmpty) {
      txtOtherDriverContactNumber.text = "";
    }
    if (txtOtherDriverLicensePlateNum.text.isEmpty) {
      txtOtherDriverLicensePlateNum.text = "";
    }
    if (txtOtherDriversDriverLicenseNum.text.isEmpty) {
      txtOtherDriversDriverLicenseNum.text = "";
    }
    if (txtOtherDriverInsuranceCompanyNameAndPolicyNum.text.isEmpty) {
      txtOtherDriverInsuranceCompanyNameAndPolicyNum.text = "";
    }
    if (txtOtherDriverVehicleMakeModelYear.text.isEmpty) {
      txtOtherDriverVehicleMakeModelYear.text = "";
    }
    if (txtNameAddressDriverVehicle.text.isEmpty) {
      txtNameAddressDriverVehicle.text = "";
    }
    return true;
  }

  bool checkValidationPage5() {
    if (txtName.text.isEmpty) {
      txtName.text = "";
    }
    if (txtBadgeNo.text.isEmpty) {
      txtBadgeNo.text = "";
    }
    if (txtPhone.text.isEmpty) {
      txtPhone.text = "";
    }
    if (txtLocalPoliceDepartment.text.isEmpty) {
      txtLocalPoliceDepartment.text = "";
    }
    if (txtIncidentReportNumber.text.isEmpty) {
      txtIncidentReportNumber.text = "";
    }
    if (txtOccurrenceNumber.text.isEmpty) {
      txtOccurrenceNumber.text = "";
    }
    return true;
  }

  bool checkValidationPage7() {
    if (attachmentList.isEmpty) {
      CommonToast.getInstance()
          .displayToast(message: "Please attach images of attachment");
      return false;
    } else {
      return true;
    }
  }

  Future<DateTime?> openCalender({BuildContext? context}) async {
    AppThemeState _appTheme = AppThemeState();

    // Show date picker dialog
    return await showDatePicker(
      context: context!,
      initialDate: DateTime.now(), // Default date to now
      firstDate: DateTime(1901),
      lastDate: DateTime.now(),
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
    );
  }

  void btnDateClicked({BuildContext? context}) {
    openCalender(context: context!).then((value) {
      if (value != null) {
        txtData.text = DateFormat(
                AppComponentBase.getInstance().getLoginData().user?.date_format)
            .format(value);
        mainStreamController.sink.add(true);
      }
    });
  }

  Future<String?> openTime({BuildContext? context}) async {
    AppThemeState _appTheme = AppThemeState();
    var date = await showTimePicker(
      context: context!,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: _appTheme.primaryColor,
              primary: _appTheme.primaryColor,
              onPrimary: Colors.white,
              surface: _appTheme.whiteColor,
              onSurface: _appTheme.blackColor,
            ),
          ),
          child: child!,
        );
      },
      initialTime: initTimeOfDay ?? TimeOfDay.now(),
    );
    if (date != null) {
      initTimeOfDay = date;
      return '${pad(date.hour)}:${pad(date.minute)}';
    }
    return null;
  }

  String pad(int input) {
    if (input >= 10) {
      String re = input.toString();
      return re;
    } else {
      return "0" + input.toString();
    }
  }

  void openSheetGallery({BuildContext? context}) {
    showModalBottomSheet(
      context: context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddAttachmentReplica(
          onDocumentClick: () {
            Utils.docFromGallery().then((value) {
              if (value != null) {
                print("++> onDocumentClick ${value.path}");
                attachments.add(value);

                var a = value.path.split('.');
                var b = StringConstants.arrAudio
                    .contains(a[a.length - 1].toLowerCase());
                var now = new DateTime.now();
                var formatter = new DateFormat((AppComponentBase.getInstance()
                            .getLoginData()
                            .user
                            ?.date_format ??
                        'yyyy-MM-dd') +
                    ' HH:mm:ss');
                String formattedDate = formatter.format(now);
                attachmentList.add(Attachments(
                    type: 'file',
                    createdAt: formattedDate,
                    attachmentUrl: value,
                    docType: b ? '2' : '4',
                    id: -1,
                    extensionName: value.path.split('/').last));
                mainStreamController.sink.add(true);
              }
            });
            Navigator.pop(context);
          },
          onGalleryClick: () {
            Utils.imgFromGallery().then((value) {
              if (value != null) {
                print("++> onGalleryClick ${value.path}");
                attachments.add(value);

                var now = new DateTime.now();
                var formatter = new DateFormat((AppComponentBase.getInstance()
                            .getLoginData()
                            .user
                            ?.date_format ??
                        'yyyy-MM-dd') +
                    ' HH:mm:ss');
                String formattedDate = formatter.format(now);
                attachmentList.add(Attachments(
                    type: 'file',
                    createdAt: formattedDate,
                    attachmentUrl: value,
                    docType: '1',
                    id: -1,
                    extensionName: value.path.split('/').last));
                mainStreamController.sink.add(true);
              }
            });
            Navigator.pop(context);
          },
          onTakePhotoClick: () {
            Utils.imgFromCamera().then((value) {
              if (value != null) {
                print("++> onTakePhotoClick ${value.path}");
                attachments.add(value);

                var now = new DateTime.now();
                var formatter = new DateFormat((AppComponentBase.getInstance()
                            .getLoginData()
                            .user
                            ?.date_format ??
                        'yyyy-MM-dd') +
                    ' HH:mm:ss');
                String formattedDate = formatter.format(now);
                attachmentList.add(Attachments(
                    type: 'file',
                    createdAt: formattedDate,
                    attachmentUrl: value,
                    docType: '1',
                    id: -1,
                    extensionName:
                        '${DateTime.now().millisecondsSinceEpoch}.png'));
                mainStreamController.sink.add(true);
              }
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> saveData(Map<String, String> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data.forEach((key, value) {
      prefs.setString(key, value);
    });
  }

  Future<void> loadData(Map<String, TextEditingController> controllers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    controllers.forEach((key, controller) {
      controller.text = prefs.getString(key) ?? "";
    });
  }

  Future<void> fillPage1() async {
    await loadData({
      "accidentTime": txtTime,
      "accidentDate": txtData,
      "accidentStreet": txtStreet,
      "accidentCity": txtCity,
      "accidentProvince": txtProvince,
      "accidentMyCarSpeed": txtMySpeed,
      "accidentOtherCarSpeed": txtOtherDriverSpeed,
    });
  }

  Future<void> btnSaveDraft1() async {
    await saveData({
      "accidentTime": txtTime.text,
      "accidentDate": txtData.text,
      "accidentStreet": txtStreet.text,
      "accidentCity": txtCity.text,
      "accidentProvince": txtProvince.text,
      "accidentMyCarSpeed": txtMySpeed.text,
      "accidentOtherCarSpeed": txtOtherDriverSpeed.text,
      "vehicle_id": arrVehicle[selectedVehicle].id.toString(),
      "otherSpeedRadio": otherSpeedRadioGroup.toString(),
      "mySpeedRadio": mySpeedRadioGroup.toString(),
    });
  }

  Future<void> btnNextPage1(BuildContext context) async {
    await btnSaveDraft1();
    Navigator.pushNamed(context, RouteName.accidentReportForm2);
  }

  Future<void> fillPage2() async {
    await loadData({
      "accidentMyVehicleDescription": txtYourVehicleDamage,
      "accidentOtherVehicleDescription": txtOtherVehicleDamage,
      "accidentHappened": txtAccidentHappen,
    });
  }

  Future<void> btnSaveDraft2() async {
    await saveData({
      "accidentMyVehicleDescription": txtYourVehicleDamage.text,
      "accidentOtherVehicleDescription": txtOtherVehicleDamage.text,
      "accidentHappened": txtAccidentHappen.text,
    });
  }

  Future<void> btnNextPage2(BuildContext context) async {
    if (checkValidationPage2()) {
      await btnSaveDraft2();
      Navigator.pushNamed(context, RouteName.accidentReportForm3);
    }
  }

  Future<void> fillPage3() async {
    await loadData({
      "myName": txtMyName,
      "myAddress": txtMyAddress,
      "myContactNumber": txtMyContactNumber,
      "myLicencePlateNumber": txtLicensePlateNum,
      "myDriverLicenceNumber": txtDriverLicenseNum,
      "myInsuranceCompanyPolicyNumber": txtInsuranceCompanyNameAndPolicyNum,
      "myVehicleModelYear": txtVehicleMakeModelYear,
      "myInjuryDetail": txtInjuriesDetail,
    });
  }

  Future<void> btnSaveDraft3() async {
    await saveData({
      "myName": txtMyName.text,
      "myAddress": txtMyAddress.text,
      "myContactNumber": txtMyContactNumber.text,
      "myLicencePlateNumber": txtLicensePlateNum.text,
      "myDriverLicenceNumber": txtDriverLicenseNum.text,
      "myInsuranceCompanyPolicyNumber":
          txtInsuranceCompanyNameAndPolicyNum.text,
      "myVehicleModelYear": txtVehicleMakeModelYear.text,
      "myInjuryDetail": txtInjuriesDetail.text,
    });
  }

  Future<void> btnNextPage3(BuildContext context) async {
    if (checkValidationPage3()) {
      await btnSaveDraft3();
      Navigator.pushNamed(context, RouteName.accidentReportForm4);
    }
  }

  Future<void> fillPage4() async {
    await loadData({
      "otherName": txtOtherDriverName,
      "otherAddress": txtOtherDriverAddress,
      "otherContactNumber": txtOtherDriverContactNumber,
      "otherLicencePlateNumber": txtOtherDriverLicensePlateNum,
      "otherDriverLicenceNumber": txtOtherDriversDriverLicenseNum,
      "otherInsuranceCompanyPolicyNumber":
          txtOtherDriverInsuranceCompanyNameAndPolicyNum,
      "otherVehicleModelYear": txtOtherDriverVehicleMakeModelYear,
      "otherInjuryDetail": txtNameAddressDriverVehicle,
    });
  }

  Future<void> btnSaveDraft4() async {
    await saveData({
      "otherName": txtOtherDriverName.text,
      "otherAddress": txtOtherDriverAddress.text,
      "otherContactNumber": txtOtherDriverContactNumber.text,
      "otherLicencePlateNumber": txtOtherDriverLicensePlateNum.text,
      "otherDriverLicenceNumber": txtOtherDriversDriverLicenseNum.text,
      "otherInsuranceCompanyPolicyNumber":
          txtOtherDriverInsuranceCompanyNameAndPolicyNum.text,
      "otherVehicleModelYear": txtOtherDriverVehicleMakeModelYear.text,
      "otherInjuryDetail": txtNameAddressDriverVehicle.text,
    });
  }

  Future<void> btnNextPage4(BuildContext context) async {
    if (checkValidationPage4()) {
      await btnSaveDraft4();
      Navigator.pushNamed(context, RouteName.accidentReportForm5);
    }
  }

  Future<void> fillPage5() async {
    await loadData({
      "policeName": txtName,
      "badgeNo": txtBadgeNo,
      "phone": txtPhone,
      "localPoliceDepartment": txtLocalPoliceDepartment,
      "incidentReportNumber": txtIncidentReportNumber,
      "occurrenceNumber": txtOccurrenceNumber,
    });
  }

  Future<void> btnSaveDraft5() async {
    await saveData({
      "policeName": txtName.text,
      "badgeNo": txtBadgeNo.text,
      "phone": txtPhone.text,
      "localPoliceDepartment": txtLocalPoliceDepartment.text,
      "incidentReportNumber": txtIncidentReportNumber.text,
      "occurrenceNumber": txtOccurrenceNumber.text,
    });
  }

  Future<void> btnNextPage5(BuildContext context) async {
    if (checkValidationPage5()) {
      await btnSaveDraft5();
      Navigator.pushNamed(context, RouteName.accidentReportForm6);
    }
  }

  Future<void> fillPage6() async {
    await loadData({
      "witnessName1": txtWitnessName1,
      "witnessContactNumber1": txtWitnessContact1,
      "witnessAddress1": txtWitnessAddress1,
      "witnessLicencePlateNumber1": txtWitnessLicensePlateNumber1,
      "witnessName2": txtWitnessName2,
      "witnessContactNumber2": txtWitnessContact2,
      "witnessAddress2": txtWitnessAddress2,
      "witnessLicencePlateNumber2": txtWitnessLicensePlateNumber2,
      "witnessName3": txtWitnessName3,
      "witnessContactNumber3": txtWitnessContact3,
      "witnessAddress3": txtWitnessAddress3,
      "witnessLicencePlateNumber3": txtWitnessLicensePlateNumber3,
    });
  }

  Future<void> btnSaveDraft6() async {
    Map<String, String> dataToSave = {};

    if (txtWitnessName1.text.isNotEmpty) {
      dataToSave["witnessName1"] = txtWitnessName1.text;
      dataToSave["witnessContactNumber1"] = txtWitnessContact1.text;
      dataToSave["witnessAddress1"] = txtWitnessAddress1.text;
      dataToSave["witnessLicencePlateNumber1"] =
          txtWitnessLicensePlateNumber1.text;
    }
    if (txtWitnessName2.text.isNotEmpty) {
      dataToSave["witnessName2"] = txtWitnessName2.text;
      dataToSave["witnessContactNumber2"] = txtWitnessContact2.text;
      dataToSave["witnessAddress2"] = txtWitnessAddress2.text;
      dataToSave["witnessLicencePlateNumber2"] =
          txtWitnessLicensePlateNumber2.text;
    }
    if (txtWitnessName3.text.isNotEmpty) {
      dataToSave["witnessName3"] = txtWitnessName3.text;
      dataToSave["witnessContactNumber3"] = txtWitnessContact3.text;
      dataToSave["witnessAddress3"] = txtWitnessAddress3.text;
      dataToSave["witnessLicencePlateNumber3"] =
          txtWitnessLicensePlateNumber3.text;
    }

    await saveData(dataToSave);
  }

  Future<void> btnNextPage6(BuildContext context) async {
    await btnSaveDraft6();
    Navigator.pushNamed(context, RouteName.accidentReportForm7);
  }

  Future<void> fillPage7() async {
    await loadData({
      "additionalInfo": txtAdditionalInformation,
    });
  }

  Future<void> btnSaveDraft7() async {
    await saveData({
      "additionalInfo": txtAdditionalInformation.text,
    });
  }

  Future<void> btnNextPage7(BuildContext context) async {
    AppComponentBase.getInstance().showProgressDialog(true);

    await btnSaveDraft7();
    btnUpload(context: context);
  }

  Future<void> savePage7() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("additionalInfo", txtAdditionalInformation.text);
  }

  Future<void> btnUpload({BuildContext? context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = AppComponentBase.getInstance().getLoginData().token.toString();
    var userId =
        AppComponentBase.getInstance().getLoginData().user!.id!.toString();

//page 1
    var accidentTime = prefs.getString("accidentTime");
    var accidentDate = prefs.getString("accidentDate");
    var accidentStreet = prefs.getString("accidentStreet");
    var accidentCity = prefs.getString("accidentCity");
    var accidentProvince = prefs.getString("accidentProvince");
    var accidentMyCarSpeed = prefs.getString("accidentMyCarSpeed");
    var mySpeedRadio = prefs.getString("mySpeedRadio") == "1" ? "kph" : "mph";
    var accidentOtherCarSpeed = prefs.getString("accidentOtherCarSpeed");
    var otherSpeedRadio =
        prefs.getString("otherSpeedRadio") == "1" ? "kph" : "mph";
    //vehicle_id missing

//page 2
    var accidentMyVehicleDescription =
        prefs.getString("accidentMyVehicleDescription");
    var accidentOtherVehicleDescription =
        prefs.getString("accidentOtherVehicleDescription");
    var accidentHappened = prefs.getString("accidentHappened");

//page 3
    var myName = prefs.getString("myName");
    var myAddress = prefs.getString("myAddress");
    var myContactNumber = prefs.getString("myContactNumber");
    var myLicencePlateNumber = prefs.getString("myLicencePlateNumber");
    var myDriverLicenceNumber = prefs.getString("myDriverLicenceNumber");
    var myInsuranceCompanyPolicyNumber =
        prefs.getString("myInsuranceCompanyPolicyNumber");
    var myVehicleModelYear = prefs.getString("myVehicleModelYear");
    var myInjuryDetail = prefs.getString("myInjuryDetail");

//page 4
    var otherName = prefs.getString("otherName");
    var otherAddress = prefs.getString("otherAddress");
    var otherContactNumber = prefs.getString("otherContactNumber");
    var otherLicencePlateNumber = prefs.getString("otherLicencePlateNumber");
    var otherDriverLicenceNumber = prefs.getString("otherDriverLicenceNumber");
    var otherInsuranceCompanyPolicyNumber =
        prefs.getString("otherInsuranceCompanyPolicyNumber");
    var otherVehicleModelYear =
        prefs.getString("otherVehicleModelYear") ?? 'N/A';
    var otherInjuryDetail = prefs.getString("otherInjuryDetail");

// page5
    var policeName = prefs.getString("policeName");
    var badgeNo = prefs.getString("badgeNo");
    var phone = prefs.getString("phone");
    var localPoliceDepartment = prefs.getString("localPoliceDepartment");
    var incidentReportNumber = prefs.getString("incidentReportNumber");
    var occurrenceNumber = prefs.getString("occurrenceNumber");

    // page 7
    var additionalInfo = prefs.get("additionalInfo") ?? 'N/A';

    var body = {
      'user_id': userId,
      'accident_time': accidentTime.toString().isEmpty ? "N/A" : accidentTime,
      'accident_date': accidentDate.toString().isEmpty ? "N/A" : accidentDate,
      'street': accidentStreet.toString().isEmpty ? "N/A" : accidentStreet,
      'city': accidentCity.toString().isEmpty ? "N/A" : accidentCity,
      'province':
          accidentProvince.toString().isEmpty ? "N/A" : accidentProvince,
      'my_speed':
          accidentMyCarSpeed.toString().isEmpty ? "N/A" : accidentMyCarSpeed,
      'my_speed_unit': mySpeedRadio.toString().isEmpty ? "N/A" : mySpeedRadio,
      'their_speed': accidentOtherCarSpeed.toString().isEmpty
          ? "N/A"
          : accidentOtherCarSpeed,
      'their_speed_unit':
          otherSpeedRadio.toString().isEmpty ? "N/A" : otherSpeedRadio,
      'my_damage': accidentMyVehicleDescription.toString().isEmpty
          ? "N/A"
          : accidentMyVehicleDescription,
      'their_damage': accidentOtherVehicleDescription.toString().isEmpty
          ? "N/A"
          : accidentOtherVehicleDescription,
      'accident_details':
          accidentHappened.toString().isEmpty ? "N/A" : accidentHappened,
      'my_name': myName.toString().isEmpty ? "N/A" : myName,
      'my_address': myAddress.toString().isEmpty ? "N/A" : myAddress,
      'my_contact_no':
          myContactNumber.toString().isEmpty ? "N/A" : myContactNumber,
      'my_license_plate_no': myLicencePlateNumber.toString().isEmpty
          ? "N/A"
          : myLicencePlateNumber,
      'my_driver_license_no': myDriverLicenceNumber.toString().isEmpty
          ? "N/A"
          : myDriverLicenceNumber,
      'my_insurance_company_and_policy_no':
          myInsuranceCompanyPolicyNumber.toString().isEmpty
              ? "N/A"
              : myInsuranceCompanyPolicyNumber,
      'my_make_model_year':
          myVehicleModelYear.toString().isEmpty ? "N/A" : myVehicleModelYear,
      'my_injury_details':
          myInjuryDetail.toString().isEmpty ? "N/A" : myInjuryDetail,
      'their_name': otherName.toString().isEmpty ? "N/A" : otherName,
      'their_address': otherAddress.toString().isEmpty ? "N/A" : otherAddress,
      'their_contact_no':
          otherContactNumber.toString().isEmpty ? "N/A" : otherContactNumber,
      'their_license_plate_no': otherLicencePlateNumber.toString().isEmpty
          ? "N/A"
          : otherLicencePlateNumber,
      'their_driver_license_no': otherDriverLicenceNumber.toString().isEmpty
          ? "N/A"
          : otherDriverLicenceNumber,
      'their_insurance_company_and_policy_no':
          otherInsuranceCompanyPolicyNumber.toString().isEmpty
              ? "N/A"
              : otherInsuranceCompanyPolicyNumber,
      'their_make_model_year': otherVehicleModelYear.toString().isEmpty
          ? "N/A"
          : otherVehicleModelYear,
      'otherInjuryDetail':
          otherInjuryDetail.toString().isEmpty ? "N/A" : otherInjuryDetail,
      'authority_name': policeName.toString().isEmpty ? "N/A" : policeName,
      'authority_badge_no': badgeNo.toString().isEmpty ? "N/A" : badgeNo,
      'authority_contact_no': phone.toString().isEmpty ? "N/A" : phone,
      'local_police_dept': localPoliceDepartment.toString().isEmpty
          ? "N/A"
          : localPoliceDepartment,
      'incident_report_no': incidentReportNumber.toString().isEmpty
          ? "N/A"
          : incidentReportNumber,
      'occurrence_no':
          occurrenceNumber.toString().isEmpty ? "N/A" : occurrenceNumber,
      'additional_info':
          additionalInfo.toString().isEmpty ? "N/A" : additionalInfo,
    };

    await sendAccidentReport(body, context!);
  }

  Future<void> sendAccidentReport(dynamic body, BuildContext context) async {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getAccidentReportRepository()
        .addAccidentReport(body)
        .then((value) async {
      var accidentId = "${value['accident_id']}";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("accident_id", accidentId);
      await uploadAttachments(accidentId, context);
    }).catchError((onError) {
      print("onError sendAccidentReport -----> $onError");
      CommonToast.getInstance()
          .displayToast(message: "Error in report submitting");
      AppComponentBase.getInstance().showProgressDialog(false);
    });
  }

  Future<void> sendWitnesses(
    String accidentId,
    BuildContext? context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var nameW1 = prefs.getString("witnessName1");
    var nameW2 = prefs.getString("witnessName2");
    var nameW3 = prefs.getString("witnessName3");

    if (nameW1 != null) {
      print("------ w1 not null");
      var contactW1 = prefs.getString("witnessContactNumber1") ?? "N/A";
      var addressW1 = prefs.getString("witnessAddress1") ?? "N/A";
      var licenseW1 = prefs.getString("witnessLicencePlateNumber1") ?? "N/A";

      var body = {
        'accident_id': accidentId,
        'name': nameW1,
        'contact_no': contactW1,
        'address': addressW1,
        'license_plate_no': licenseW1,
      };

      postWitness(body, context!);
    }

    if (nameW2 != null) {
      print("------ w2 not null");
      var contactW2 = prefs.getString("witnessContactNumber2") ?? "N/A";
      var addressW2 = prefs.getString("witnessAddress2") ?? "N/A";
      var licenseW2 = prefs.getString("witnessLicencePlateNumber2") ?? "N/A";

      var body = {
        'accident_id': accidentId,
        'name': nameW2,
        'contact_no': contactW2,
        'address': addressW2,
        'license_plate_no': licenseW2,
      };

      postWitness(body, context!);
    }

    if (nameW3 != null) {
      print("------ w3 not null");
      var contactW3 = prefs.getString("witnessContactNumber3") ?? "N/A";
      var addressW3 = prefs.getString("witnessAddress3") ?? "N/A";
      var licenseW3 = prefs.getString("witnessLicencePlateNumber3") ?? "N/A";

      var body = {
        'accident_id': accidentId,
        'name': nameW3,
        'contact_no': contactW3,
        'address': addressW3,
        'license_plate_no': licenseW3,
      };

      postWitness(body, context!);
    }

    print("+++++ deone postWitness");
    Navigator.pushNamed(context!, RouteName.accidentReportClosingPage);
  }

  Future<void> postWitness(dynamic body, BuildContext context) async {
    AppComponentBase.getInstance().showProgressDialog(true);
    AppComponentBase.getInstance()
        .getApiInterface()
        .getAccidentReportRepository()
        .addWitness(body)
        .then((value) async {})
        .catchError((onError) {
      print("onError postWitness -----> $onError");
      CommonToast.getInstance().displayToast(message: "Error send witness");
      AppComponentBase.getInstance().showProgressDialog(false);
    });
  }

  Future<void> uploadAttachments(
      String accidentId, BuildContext context) async {
    print("+++++ uploadAttachments");
    if (attachments.isNotEmpty) {
      var attachmentBody = {
        'accident_id': accidentId,
        'accident_documents[]': attachments
      };

      AppComponentBase.getInstance()
          .getApiInterface()
          .getAccidentReportRepository()
          .addAttachments(attachmentBody)
          .then((value) async {
        CommonToast.getInstance()
            .displayToast(message: "Document uploaded successfully");
        print("+++++ stopLoader response uploadAttachments");
        await sendWitnesses(accidentId, context);
        // AppComponentBase.getInstance().showProgressDialog(false);
        // Navigator.pushNamed(context!, RouteName.accidentReportClosingPage);
      }).catchError((onError) {
        print("onError uploadAttachments -----> $onError");
        if (onError.toString().contains("413")) {
          CommonToast.getInstance().displayToast(
              message:
                  'One of the file is too big, please remove attachements');
        } else {
          CommonToast.getInstance().displayToast(message: "Error send witness");
        }
        AppComponentBase.getInstance().showProgressDialog(false);
      });
    } else {
      await sendWitnesses(accidentId, context);
    }
  }
}

class Witness {
  String WitnessName;
  String WitnessContactNumber;
  String WitnessAddress;
  String WitnessLicencePlateNumber;

  Witness({
    required this.WitnessName,
    required this.WitnessContactNumber,
    required this.WitnessAddress,
    required this.WitnessLicencePlateNumber,
  });
}
