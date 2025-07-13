import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/share/widget/vehicle_selection_bottom_sheet.dart';
import 'package:myride901/features/tabs/vehicle/widget/vehicle_detail_tabview.dart';
import 'package:myride901/features/tabs/service_event/service_detail/widget/add_attachment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleProfileBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  List<VehicleProfile> arrVehicle = [];
  int selectedVehicle = 0;
  List<VehicleDetailData> vehicleDetailList = [];
  TextEditingController nameTextEditController = TextEditingController();
  TextEditingController vinTextEditController = TextEditingController();
  TextEditingController licenceTextEditController = TextEditingController();
  TextEditingController priceTextEditController = TextEditingController();
  TextEditingController currencyTextEditController = TextEditingController();
  TextEditingController purchaseTextEditController = TextEditingController();
  TextEditingController purchaseMileageTextEditController =
      TextEditingController();
  TextEditingController currentMileageTextEditController =
      TextEditingController();
  TextEditingController purchaseDateTextEditController =
      TextEditingController();
  TextEditingController currentDateTextEditController = TextEditingController();
  bool isEditable = false;
  String mileUnit = 'mile';
  bool isLoaded = false;
  bool isDeleting = false;
  int selectedIndex = 0;
  List<WalletCard>? vehiclePropertiesList;
  bool? users;

  @override
  void dispose() {
    mainStreamController.close();
  }

  Future<List<WalletCard>?> addWallet(
      {BuildContext? context,
      String value = '',
      String wallet_key = ''}) async {
    final response = await AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .addWallet(
            value: value,
            wallet_key: wallet_key,
            vehicle_id: arrVehicle[selectedVehicle].id.toString())
        .catchError((onError) {
      print(onError);
    });

    if (response['wallet_cards'] != null) {
      final List<dynamic> walletCardsJson = response['wallet_cards'];

      vehiclePropertiesList = walletCardsJson
          .map((json) => WalletCard.fromJson(json))
          .where((walletCard) =>
              walletCard.walletKeyId != 1 && walletCard.walletKeyId != 2)
          .toList();

      await updatePrefList(vehiclePropertiesList ?? []);
      getWalletLength(context: context, isProgressBar: true);
      return vehiclePropertiesList;
    }
  }

  void getWalletLength({BuildContext? context, bool? isProgressBar}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getShareVehicle(isProgressBar: isProgressBar!)
        .then((value) {
      if (value.length > 0) {
        AppComponentBase.getInstance().setArrVehicleProfile(value);
        getServiceList(context: context!, isProgressBar: false);
      } else {
        AppComponentBase.getInstance().setArrVehicleProfile([]);
      }
      setLocalData();

      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<List<WalletCard>?> updateWallet(
      {BuildContext? context,
      String value = '',
      String wallet_key = '',
      WalletCard? walletCard}) async {
    if (walletCard == null) {
      // Handle the case where walletCard is null.
      return vehiclePropertiesList;
    }

    await AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .updateWallet(
            value: value,
            wallet_key: wallet_key,
            is_default: walletCard.isDefault ?? 0,
            wallet_id: walletCard.id.toString())
        .catchError((onError) {
      print(onError);
    });

    int indexToUpdate = vehiclePropertiesList!
        .indexWhere((element) => element.id == walletCard.id);

    if (indexToUpdate != -1) {
      WalletCard updatedWalletCard = walletCard.copyWith(
        value: value,
        walletKey: wallet_key,
      );

      vehiclePropertiesList![indexToUpdate] = updatedWalletCard;
    }
    // await getVehicleList(context: context, isProgressBar: true);

    return vehiclePropertiesList;
  }

  Future<List<WalletCard>?> deleteWallet(
      {BuildContext? context, WalletCard? walletCard}) async {
    await AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .deleteWallet(wallet_id: walletCard!.id.toString())
        .catchError((onError) {
      print(onError);
    });
    getWalletLength(context: context, isProgressBar: true);
    vehiclePropertiesList!.remove(walletCard);
    return vehiclePropertiesList;
  }

  Future<List<WalletCard>?> deleteWalletDefault(
      {BuildContext? context, WalletCard? walletCard}) async {
    await AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .deleteWalletDefault(id: walletCard!.id.toString())
        .catchError((onError) {
      print(onError);
    });
    getWalletLength(context: context, isProgressBar: true);
    vehiclePropertiesList!.remove(walletCard);
    return vehiclePropertiesList;
  }

  Future<void> getVehicleList(
      {BuildContext? context, bool? isProgressBar}) async {
    final sharedVehicles = await AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getShareVehicle(isProgressBar: isProgressBar!);

    if (sharedVehicles.length > 0) {
      AppComponentBase.getInstance().setArrVehicleProfile(sharedVehicles);

      vehiclePropertiesList = (arrVehicle).length == 0
          ? []
          : (arrVehicle[selectedVehicle].walletCards ?? [])
              .where((element) =>
                  element.walletKeyId != 1 && element.walletKeyId != 2)
              .toList();

      updatePrefList(vehiclePropertiesList ?? []);
      await getServiceList(context: context!, isProgressBar: false);
      mainStreamController.sink.add(true);
    } else {
      AppComponentBase.getInstance().setArrVehicleProfile([]);
    }

    await setLocalData();
  }

  Future<void> getServiceList(
      {BuildContext? context, bool? isProgressBar}) async {
    final response = await AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicleService(
            vehicleId: arrVehicle[selectedVehicle].id.toString(),
            id: arrVehicle[selectedVehicle].id.toString(),
            isProgressBar: isProgressBar!);

    AppComponentBase.getInstance().setArrVehicleService(response);

    mainStreamController.sink.add(true);
  }

  Future<void> openSheet(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return VehicleSelectionBottomSheet(
            arrVehicleProfile: arrVehicle,
            onlyMy: true,
            index: selectedVehicle,
            onTap: (index) async {
              FocusScope.of(context).requestFocus(FocusNode());
              selectedVehicle = index;
              isEditable = false;
              mainStreamController.sink.add(true);

              vehiclePropertiesList = (arrVehicle).length == 0
                  ? []
                  : (arrVehicle[selectedVehicle].walletCards ?? [])
                      .where((element) =>
                          element.walletKeyId != 1 && element.walletKeyId != 2)
                      .toList();
              AppComponentBase.getInstance()
                  .getSharedPreference()
                  .setSelectedVehicle(
                      arrVehicle[selectedVehicle].id.toString());
              mainStreamController.sink.add(true);
              await setLocalData();
              await getServiceList(context: context, isProgressBar: false);
              Navigator.pop(context);
            },
          );
        });
  }

  void btnCDateClicked({BuildContext? context}) {
    openCalender(context: context!, tec: currentDateTextEditController)
        .then((value) {
      if (value != null) {
        currentDateTextEditController.text = DateFormat(
                AppComponentBase.getInstance().getLoginData().user?.date_format)
            .format(value);
        mainStreamController.sink.add(true);
      }
    });
  }

  void btnPDateClicked({BuildContext? context}) {
    openCalender(context: context!, tec: purchaseDateTextEditController)
        .then((value) {
      if (value != null) {
        purchaseDateTextEditController.text = DateFormat(
                AppComponentBase.getInstance().getLoginData().user?.date_format)
            .format(value);
        mainStreamController.sink.add(true);
      }
    });
  }

  Future<DateTime?> openCalender(
      {BuildContext? context, TextEditingController? tec}) async {
    FocusScope.of(context!).requestFocus(FocusNode());
    AppThemeState _appTheme = AppThemeState();
    return await showDatePicker(
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
        initialDate: tec!.text != ""
            ? DateFormat(AppComponentBase.getInstance()
                    .getLoginData()
                    .user
                    ?.date_format)
                .parse(tec.text)
            : DateTime.now(),
        firstDate: DateTime(1901),
        lastDate: DateTime(2030));
  }

  void openSheetGallery({BuildContext? context}) {
    if (arrVehicle.length > 0) {
      FocusScope.of(context!).requestFocus(FocusNode());
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return AddAttachment(
              onlyImage: true,
              onDocumentClick: () {},
              onGalleryClick: () {
                Utils.imgFromGallery().then((value) {
                  if (value != null) {
                    btnImageClicked(context: context, img: value);
                  }
                });
                Navigator.pop(context);
              },
              onTakePhotoClick: () {
                Utils.imgFromCamera().then((value) {
                  if (value != null) {
                    btnImageClicked(context: context, img: value);
                  }
                });
                Navigator.pop(context);
              },
              onVideoClick: () {},
            );
          });
    }
  }

  void btnImageClicked({BuildContext? context, File? img}) {
    String delete_image = '';
    (arrVehicle[selectedVehicle].images ?? []).forEach((element) {
      delete_image = delete_image + ',' + element['id'].toString();
    });
    if (delete_image.length > 0 && delete_image[0] == ',') {
      delete_image = delete_image.substring(1);
    }
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDate = formatter.format(DateTime.now());
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .updateVehicle(
            body_trim: arrVehicle[selectedVehicle].Body ?? '',
            current_date: arrVehicle[selectedVehicle].CDate ?? '',
            current_mileage: arrVehicle[selectedVehicle].CKm ?? '',
            drive: arrVehicle[selectedVehicle].Drive ?? '',
            engine: arrVehicle[selectedVehicle].Engine ?? '',
            feature_image: [img!],
            license_plate: arrVehicle[selectedVehicle].LicensePlate ?? '',
            make_company: arrVehicle[selectedVehicle].Make ?? '',
            mileage_unit: mileUnit,
            model: arrVehicle[selectedVehicle].Model ?? '',
            nick_name: arrVehicle[selectedVehicle].Nickname ?? '',
            notes: arrVehicle[selectedVehicle].note ?? '',
            previous_date: arrVehicle[selectedVehicle].PDate ?? '',
            previous_mileage: arrVehicle[selectedVehicle].PKm ?? '',
            price: arrVehicle[selectedVehicle].Price ?? '',
            set_profile_index: '0',
            vin_number: arrVehicle[selectedVehicle].VIN ?? '',
            image_dates: [formattedDate],
            image_type: ['1'],
            year: arrVehicle[selectedVehicle].Year ?? '',
            delete_image: delete_image,
            reset_as_profile_image: '',
            vehicle_id: arrVehicle[selectedVehicle].id,
            currency: arrVehicle[selectedVehicle].currency ?? '')
        .then((value) {
      CommonToast.getInstance().displayToast(message: value.message ?? '');
      arrVehicle[selectedVehicle] = VehicleProfile.fromJson(value.result);
      getVehicleList(context: context, isProgressBar: false);

      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  bool checkValidation() {
    if (vinTextEditController.text != '' &&
        Validation.checkLength(
            textEditingController: vinTextEditController,
            msg: StringConstants.Please_valid_vin,
            length: 17)) {
      return false;
    } else if (vehicleDetailList[4].textEditingController.text.trim() != '' &&
        (vehicleDetailList[4].textEditingController.text.length != 4 ||
            vehicleDetailList[4].textEditingController.text == '0000' ||
            int.parse(vehicleDetailList[4].textEditingController.text) <
                1901)) {
      CommonToast.getInstance()
          .displayToast(message: StringConstants.Please_hint_valid_car_year);
      return false;
    } else if (nameTextEditController.text == '' &&
        Validation.checkIsEmpty(
          textEditingController: nameTextEditController,
          msg: StringConstants.Please_valid_name,
        )) {
      return false;
    } else if (currentDateTextEditController.text != '' &&
        DateFormat(AppComponentBase.getInstance().getLoginData().user?.date_format)
            .parse(currentDateTextEditController.text)
            .isAfter(DateTime.now())) {
      CommonToast.getInstance().displayToast(
          message: StringConstants
              .Current_mileage_date_must_be_less_than_today_date);
      return false;
    } else if (purchaseDateTextEditController.text != '' &&
        currentDateTextEditController.text == '') {
      CommonToast.getInstance().displayToast(
          message: StringConstants.pleaseSelectCurrentMileageDate);
      return false;
    } else if (purchaseDateTextEditController.text != '' &&
        DateFormat(AppComponentBase.getInstance().getLoginData().user?.date_format)
            .parse(purchaseDateTextEditController.text)
            .isAfter(DateFormat(AppComponentBase.getInstance()
                    .getLoginData()
                    .user
                    ?.date_format)
                .parse(currentDateTextEditController.text))) {
      CommonToast.getInstance().displayToast(
          message: StringConstants
              .Purchase_date_must_be_less_than_current_mileage_date);
      return false;
    } else if (currentMileageTextEditController.text != '' &&
        Validation.isNotValidNumber(
            textEditingController: currentMileageTextEditController,
            msg: StringConstants.Please_hint_valid_current_mileage)) {
      return false;
    } else if (purchaseMileageTextEditController.text != '' &&
        Validation.isNotValidNumber(
            textEditingController: purchaseMileageTextEditController,
            msg: StringConstants.Please_hint_valid_purchase_mileage)) {
      return false;
    } else {
      return true;
    }
  }

  void btnSaveClicked({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .updateVehicle(
              body_trim: vehicleDetailList[3].textEditingController.text,
              current_date: currentDateTextEditController.text,
              current_mileage: currentMileageTextEditController.text,
              drive: vehicleDetailList[1].textEditingController.text,
              engine: vehicleDetailList[5].textEditingController.text,
              feature_image: [],
              license_plate: licenceTextEditController.text,
              make_company: vehicleDetailList[0].textEditingController.text,
              mileage_unit: mileUnit,
              model: vehicleDetailList[2].textEditingController.text,
              nick_name: nameTextEditController.text,
              notes: arrVehicle[selectedVehicle].note ?? '',
              previous_date: purchaseDateTextEditController.text,
              previous_mileage: purchaseMileageTextEditController.text,
              price: purchaseTextEditController.text,
              set_profile_index: '',
              vin_number: vinTextEditController.text,
              currency: arrVehicle[selectedVehicle].currency ?? '',
              image_dates: [],
              image_type: [],
              year: vehicleDetailList[4].textEditingController.text,
              delete_image: '',
              reset_as_profile_image: '',
              vehicle_id: arrVehicle[selectedVehicle].id)
          .then((value) {
        isEditable = false;
        arrVehicle[selectedVehicle] = VehicleProfile.fromJson(value.result);
        getVehicleList(context: context, isProgressBar: false);
        CommonToast.getInstance().displayToast(message: value.message ?? '');
        mainStreamController.sink.add(true);
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void userCheck({BuildContext? context, String? email = ''}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .checkEmail(email: email!)
          .then((value) {
        users = value.result;
        if (users!) {
          Utils.showAlertDialogCallBack1(
              context: context,
              message:
                  'Please confirm you wish to transfer the ${arrVehicle[selectedVehicle].Nickname!.toUpperCase()} vehicle details & timeline to ${email.toUpperCase()}. If you tap Confirm, the ${arrVehicle[selectedVehicle].Nickname!.toUpperCase()} vehicle details & timeline will no longer be available to you.',
              isConfirmationDialog: false,
              isOnlyOK: false,
              navBtnName: 'Cancel',
              posBtnName: 'Confirm',
              onNavClick: () {},
              onPosClick: () {
                btnShareClicked(context: context, email: email);
              });
        }
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  void btnShareClicked({BuildContext? context, String email = ''}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    _showLoading(context);

    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .shareVehicle(
            vehicle_id: arrVehicle[selectedVehicle].id.toString(),
            email: email,
          )
          .then((value) {
        Utils.getDetail();
        CommonToast.getInstance().displayToast(message: value.message ?? '');
        arrVehicle.removeAt(selectedVehicle);
        selectedVehicle = 0;
        AppComponentBase.getInstance().setArrVehicleProfile(arrVehicle);
        if (arrVehicle.length > 0) {
          getServiceList(context: context, isProgressBar: false);
        }
        Navigator.pushNamed(context, RouteName.dashboard);
        mainStreamController.sink.add(true);
        setLocalData();
      }).catchError((onError) {
        Navigator.pop(context);
        print(onError);
      });
    }
  }

  void btnCopyClicked({BuildContext? context, String email = ''}) {
    FocusScope.of(context!).requestFocus(FocusNode());
    _showLoading(context);

    if (checkValidation()) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .vehiclePdf(
            vehicle_id: arrVehicle[selectedVehicle].id.toString(),
            email: email,
          )
          .then((value) {
        CommonToast.getInstance().displayToast(message: value.message ?? '');

        mainStreamController.sink.add(true);
        Navigator.pop(context);
        Navigator.pop(context);
      }).catchError((onError) {
        Navigator.pop(context);
        Navigator.pop(context);
        print(onError);
      });
    }
  }

  void deleteVehicle({BuildContext? context}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .deleteVehicle(arrVehicle[selectedVehicle])
        .then((value) {
      Utils.getDetail();
      CommonToast.getInstance().displayToast(message: value);
      arrVehicle.removeAt(selectedVehicle);
      selectedVehicle = 0;
      AppComponentBase.getInstance().setArrVehicleProfile(arrVehicle);
      if (arrVehicle.length > 0) {
        getServiceList(context: context, isProgressBar: false);
      }
      mainStreamController.sink.add(true);
      Navigator.pushNamed(context!, RouteName.dashboard);
      setLocalData();
    }).catchError((onError) {
      print(onError);
    });
  }

  void btnAddVehicleProfileClicked({BuildContext? context}) {
    Navigator.of(context!, rootNavigator: false)
        .pushNamed(RouteName.addVehicleOption)
        .then((value) {});
  }

  Future<void> updatePrefList(List<WalletCard> listFromServer) async {
    List<String> indexesFromServer =
        (listFromServer).map((card) => card.id.toString()).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String vehicleId = arrVehicle[selectedVehicle].id.toString();

    List<String>? existingList =
        prefs.getStringList('walletCardOrder_$vehicleId') ?? [];

    Set<String> uniqueElements = Set<String>.from(indexesFromServer);
    List<String> result = [];

    for (String item in existingList) {
      if (uniqueElements.contains(item)) {
        result.add(item);
        uniqueElements.remove(item); // Remove to avoid duplicates
      }
    }

    result.addAll(uniqueElements); // Add remaining unique items

    await prefs.setStringList('walletCardOrder_$vehicleId', result);
  }

  Future<void> setLocalData() async {
    if (AppComponentBase.getInstance().isArrVehicleProfileFetch) {
      await AppComponentBase.getInstance()
          .getSharedPreference()
          .getSelectedVehicle()
          .then((value) {
        arrVehicle = Utils.arrangeVehicle(
            AppComponentBase.getInstance().getArrVehicleProfile(onlyMy: true),
            int.parse(value));

        selectedVehicle = 0;
        for (int i = 0; i < arrVehicle.length; i++) {
          if (arrVehicle[i].id.toString() == value) {
            selectedVehicle = i;
          }
        }
        if (arrVehicle.length < selectedVehicle) selectedVehicle = 0;

        vehicleDetailList = [];
        if (arrVehicle.length > selectedVehicle) {
          AppComponentBase.getInstance()
              .getSharedPreference()
              .setSelectedVehicle(arrVehicle[selectedVehicle].id.toString());
          mileUnit = arrVehicle[selectedVehicle].mileageUnit ?? 'mile';
          nameTextEditController = TextEditingController(
              text: arrVehicle[selectedVehicle].Nickname ?? '');
          vinTextEditController = TextEditingController(
              text: arrVehicle[selectedVehicle].VIN ?? '');
          licenceTextEditController = TextEditingController(
              text: arrVehicle[selectedVehicle].LicensePlate ?? '');
          priceTextEditController = TextEditingController(
              text: arrVehicle[selectedVehicle].totalPrice.toString());
          purchaseTextEditController = TextEditingController(
              text: arrVehicle[selectedVehicle].Price.toString());
          currencyTextEditController = TextEditingController(
              text: arrVehicle[selectedVehicle].currency.toString());
          purchaseMileageTextEditController = TextEditingController(
              text: arrVehicle[selectedVehicle].PKm ?? '');
          currentMileageTextEditController = TextEditingController(
              text: arrVehicle[selectedVehicle].CKm ?? '');
          purchaseDateTextEditController = TextEditingController(
              text: arrVehicle[selectedVehicle].PDate ?? '');
          currentDateTextEditController = TextEditingController(
              text: arrVehicle[selectedVehicle].CDate ?? '');
          vehicleDetailList.add(VehicleDetailData(
              'Make',
              '',
              AssetImages.user,
              TextEditingController(
                  text: arrVehicle[selectedVehicle].Make ?? ''),
              textInputType: TextInputType.text));
          vehicleDetailList.add(VehicleDetailData(
              'Drivetrain',
              '',
              AssetImages.power,
              TextEditingController(
                  text: arrVehicle[selectedVehicle].Drive ?? ''),
              textInputType: TextInputType.text));
          vehicleDetailList.add(VehicleDetailData(
              'Model',
              '',
              AssetImages.car,
              TextEditingController(
                  text: arrVehicle[selectedVehicle].Model ?? ''),
              textInputType: TextInputType.text));
          vehicleDetailList.add(VehicleDetailData(
              'Body/Trim',
              '',
              AssetImages.car_body,
              TextEditingController(
                  text: arrVehicle[selectedVehicle].Body ?? ''),
              textInputType: TextInputType.text));
          vehicleDetailList.add(VehicleDetailData(
              'Year',
              '',
              AssetImages.calendar_1,
              TextEditingController(
                  text: arrVehicle[selectedVehicle].Year ?? '')));
          vehicleDetailList.add(VehicleDetailData(
              'Engine',
              '',
              AssetImages.engine,
              TextEditingController(
                  text: arrVehicle[selectedVehicle].Engine ?? ''),
              textInputType: TextInputType.text));
        } else {
          nameTextEditController = TextEditingController(text: '');
          vinTextEditController = TextEditingController(text: '');
          licenceTextEditController = TextEditingController(text: '');
          priceTextEditController = TextEditingController(text: '');
          purchaseTextEditController = TextEditingController(text: '');
          purchaseMileageTextEditController = TextEditingController(text: '');
          currentMileageTextEditController = TextEditingController(text: '');

          purchaseDateTextEditController = TextEditingController(text: '');
          currentDateTextEditController = TextEditingController(text: '');
          vehicleDetailList.add(VehicleDetailData(
              'Make', '', AssetImages.user, TextEditingController(text: ''),
              textInputType: TextInputType.text));
          vehicleDetailList.add(VehicleDetailData('Drivetrain', '',
              AssetImages.power, TextEditingController(text: ''),
              textInputType: TextInputType.text));
          vehicleDetailList.add(VehicleDetailData(
              'Model', '', AssetImages.car, TextEditingController(text: ''),
              textInputType: TextInputType.text));
          vehicleDetailList.add(VehicleDetailData('Body/Trim', '',
              AssetImages.car_body, TextEditingController(text: ''),
              textInputType: TextInputType.text));
          vehicleDetailList.add(VehicleDetailData(
              'Engine', '', AssetImages.engine, TextEditingController(text: ''),
              textInputType: TextInputType.text));
          vehicleDetailList.add(VehicleDetailData('Year', '',
              AssetImages.calendar_1, TextEditingController(text: '')));
        }
        isLoaded = true;
        // mainStreamController.sink.add(true);
      });
    }
  }
}
