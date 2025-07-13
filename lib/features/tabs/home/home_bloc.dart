import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/blog/blog.dart';
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
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/tabs/home/widget/seach_header.dart';
import 'package:myride901/features/tabs/share/widget/vehicle_selection_bottom_sheet.dart';

class HomeBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  List<VehicleProfile> arrVehicle = [];
  List<VehicleService> arrService = [];
  TextEditingController? searchController = TextEditingController();
  VehicleProvider? vehicleProvider;
  User? user;
  int selectedVehicle = 0;
  bool isDisplaySelectionCheckBox = false;
  bool hasMore = true;
  bool blogIsFinish = true;
  List<Blog> arrBlog = [];
  int selectedIndex = 0;
  bool isLoaded = false;
  String fromDate = '';
  String toDate = '';
  String? totalPrice;
  TextEditingController fromMileage = TextEditingController();
  TextEditingController toMileage = TextEditingController();
  List<VehicleService> arrMainService = [];
  bool isFilter = false;
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

  void _calculateTotalPrice() {
    double total = 0;

    for (var service in arrService) {
      if (service.totalPrice != null) {
        String sanitizedPrice = service.totalPrice!.replaceAll(',', '');
        total += double.tryParse(sanitizedPrice) ?? 0;
      }
    }
    final formatter = NumberFormat("#,##0.00", "en_US");
    totalPrice = formatter.format(total);
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
        filterData(true, null);
        _calculateTotalPrice();
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
        setLocalData();
      }
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void getBlogList({BuildContext? context}) {
    if (hasMore) {
      hasMore = false;
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .getBlog(offset: arrBlog.length)
          .then((value) {
        (value['blogs'] ?? []).forEach((e) {
          print(e);
          arrBlog.add(Blog.fromJson(e));
        });
        hasMore = arrBlog.length < (value['total_blogs'] ?? 0);
        blogIsFinish = hasMore;
        mainStreamController.sink.add(true);
      }).catchError((onError) {
        print(onError);
      });
    }
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
      setLocalData();
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
              isFilter = false;
              searchController?.clear();
              mainStreamController.sink.add(true);
              getServiceList(context: context, isProgressBar: true);
              Navigator.pop(context);
            },
            btnDeleteClicked: (index) async {
              await revokeTimelinePermission(
                  context: context, vehicleId: arrVehicle[index].id);
              await getVehicleList2(
                  context: context,
                  isProgressBar:
                      !AppComponentBase.getInstance().isArrVehicleProfileFetch);
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

  Future<void> getVehicleList2(
      {BuildContext? context, bool? isProgressBar}) async {
    try {
      final value = await AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .getShareVehicle(isProgressBar: isProgressBar!);

      AppComponentBase.getInstance().setArrVehicleProfile(value);
      arrVehicle = value;
      await setLocalData();

      mainStreamController.sink.add(true);
    } catch (error) {
      print(error);
    }
  }

  Future<void> revokeTimelinePermission(
      {BuildContext? context, int? vehicleId}) async {
    try {
      await AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .revokeTimelinePermission(vehicle_id: vehicleId);
      mainStreamController.sink.add(true);
    } catch (error) {
      print(error);
    }
  }

  void btnClicked({BuildContext? context, int? index, String message = ''}) {
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
        getVehicleList(context: context, isProgressBar: false);
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
      getVehicleList(context: context, isProgressBar: false);
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

  void filterData(bool isChangeDate, String? searchTerm) {
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
      if (isAdded && (searchTerm?.isNotEmpty ?? false)) {
        List<String?> fieldsToSearch = [
          arrMainService[i].title,
          arrMainService[i].notes,
          ...?arrMainService[i].details?.map((detail) => detail.description),
          ...?arrMainService[i].details?.map((detail) => detail.categoryName)
        ];

        bool matchesSearchTerm = fieldsToSearch.any((field) =>
            field?.toLowerCase().contains(searchTerm!.toLowerCase()) ?? false);

        if (!matchesSearchTerm) {
          isAdded = false;
        }
      }
      if (isAdded) {
        arrService.add(arrMainService[i]);
      }
    }
    _calculateTotalPrice();

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
      filterData(true, null);
    } else {
      fromDate = "";
      filterData(true, null);
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
      filterData(true, null);
    } else {
      toDate = "";
      filterData(true, null);
    }
    mainStreamController.sink.add(true);
  }

  void openSheetFilter({BuildContext? context}) {
    var _appTheme = AppTheme.of(context!);

    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      backgroundColor: _appTheme.greyBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2 +
                          MediaQuery.of(context).viewInsets.bottom,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: [
                                SearchHeader(
                                  fromDate: fromDate,
                                  toDate: toDate,
                                  fromMileage: fromMileage,
                                  toMileage: toMileage,
                                  onFromDateTap: () {
                                    fromDatePicker(context);
                                    isFilter = true;
                                  },
                                  onToDateTap: () {
                                    toDatePicker(context);
                                    isFilter = true;
                                  },
                                  onFieldSubmittedFromMileage: (data) {
                                    filterData(false, null);
                                    isFilter = true;
                                  },
                                  onFieldSubmittedToMileage: (data) {
                                    filterData(false, null);
                                    isFilter = true;
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: BlueButton(
                                    text: "Reset Filter",
                                    onPress: () {
                                      setState(() {
                                        searchController?.clear();
                                        setLocalData();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
