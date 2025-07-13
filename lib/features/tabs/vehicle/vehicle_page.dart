import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/subscription/subscription_bloc.dart';
import 'package:myride901/features/subscription/widgets/subscription_info_popup.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/drawer/my_ride_drawer.dart';
import 'package:myride901/features/tabs/vehicle/vehicle_bloc.dart';
import 'package:myride901/features/tabs/vehicle/widget/about_my_ride_tabview.dart';
import 'package:myride901/features/tabs/vehicle/widget/vehicle_detail_tabview.dart';
import 'package:myride901/features/tabs/vehicle/widget/vehicle_header.dart';
import 'package:myride901/core/services/analytic_services.dart';
import 'package:myride901/features/shared/share_event_user_selection/widget/user_add_dialog.dart';

class VehicleProfilePage extends StatefulWidget {
  @override
  _VehicleProfilePageState createState() => _VehicleProfilePageState();
}

class _VehicleProfilePageState extends State<VehicleProfilePage>
    with SingleTickerProviderStateMixin {
  final _vehicleProfileBloc = VehicleProfileBloc();
  final _subscriptionBloc = SubscriptionBloc();
  AppThemeState _appTheme = AppThemeState();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController? tabController;

  @override
  void initState() {
    locator<AnalyticsService>().logScreens(name: "Vehicle Profile Page");
    super.initState();
    _vehicleProfileBloc.isEditable =
        AppComponentBase.getInstance().isVehicleEditable;
    AppComponentBase.getInstance().changeVehicleEditable(false);
    _vehicleProfileBloc.getVehicleList(
        context: context,
        isProgressBar:
            !AppComponentBase.getInstance().isArrVehicleProfileFetch);
    _vehicleProfileBloc.setLocalData();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(() {
      setState(() {
        _vehicleProfileBloc.selectedIndex = tabController!.index;
      });
    });
    _subscriptionBloc.getUserStatus();
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MyRideDrawer(),
        body: BlocProvider<VehicleProfileBloc>(
          bloc: _vehicleProfileBloc,
          child: StreamBuilder<dynamic>(
            initialData: null,
            stream: _vehicleProfileBloc.mainStream,
            builder: (context, snapshot) {
              return StreamBuilder<dynamic>(
                initialData: null,
                stream: AppComponentBase.getInstance().loadStream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    AppComponentBase.getInstance().load(null);
                    _vehicleProfileBloc.setLocalData();
                  }
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: (AppComponentBase.getInstance()
                                .isArrVehicleProfileFetch &&
                            _vehicleProfileBloc.isLoaded &&
                            _vehicleProfileBloc.isDeleting == false)
                        ? propertiesList()
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget header() {
    return VehicleHeader(
      onImageClick: () {
        _vehicleProfileBloc.openSheetGallery(context: context);
      },
      vehicleImage: _vehicleProfileBloc.arrVehicle.length == 0
          ? ''
          : Utils.getProfileImage(_vehicleProfileBloc
              .arrVehicle[_vehicleProfileBloc.selectedVehicle]),
      vehicleName: _vehicleProfileBloc.arrVehicle.length == 0
          ? ''
          : (_vehicleProfileBloc.arrVehicle[_vehicleProfileBloc.selectedVehicle]
                          .isMyVehicle ==
                      0
                  ? _vehicleProfileBloc
                      .arrVehicle[_vehicleProfileBloc.selectedVehicle]
                      .displayName
                  : _vehicleProfileBloc
                      .arrVehicle[_vehicleProfileBloc.selectedVehicle]
                      .Nickname) ??
              '',
      onVehicleDropDownClick: () async {
        await _vehicleProfileBloc.openSheet(context);
        setState(() {
          tabController?.animateTo(0);
        });
      },
      onDrawerClick: () {
        _scaffoldKey.currentState!.openDrawer();
      },
    );
  }

  Widget propertiesList() {
    return ListView(
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.all(0),
      children: [
        VehicleHeader(
          onImageClick: () {
            _vehicleProfileBloc.openSheetGallery(context: context);
          },
          vehicleImage: _vehicleProfileBloc.arrVehicle.length == 0
              ? ''
              : Utils.getProfileImage(_vehicleProfileBloc
                  .arrVehicle[_vehicleProfileBloc.selectedVehicle]),
          vehicleName: _vehicleProfileBloc.arrVehicle.length == 0
              ? ''
              : (_vehicleProfileBloc
                              .arrVehicle[_vehicleProfileBloc.selectedVehicle]
                              .isMyVehicle ==
                          0
                      ? _vehicleProfileBloc
                          .arrVehicle[_vehicleProfileBloc.selectedVehicle]
                          .displayName
                      : _vehicleProfileBloc
                          .arrVehicle[_vehicleProfileBloc.selectedVehicle]
                          .Nickname) ??
                  '',
          onVehicleDropDownClick: () async {
            await _vehicleProfileBloc.openSheet(context);
            setState(() {
              tabController?.animateTo(0);
            });
          },
          onDrawerClick: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        TabBar(
          unselectedLabelColor: Colors.black.withOpacity(0.5),
          labelPadding: EdgeInsets.symmetric(horizontal: 3),
          labelColor: AppTheme.of(context).primaryColor,
          indicatorColor: AppTheme.of(context).primaryColor,
          labelStyle:
              GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: [
            Tab(
              text: 'Vehicle details'.toUpperCase(),
            ),
            Tab(
              text: 'About My Ride'.toUpperCase(),
            )
          ],
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          onTap: (a) {},
        ),
        SizedBox(
          height: _vehicleProfileBloc.selectedIndex == 1
              ? ((_vehicleProfileBloc
                      .arrVehicle[_vehicleProfileBloc.selectedVehicle]
                      .walletCards!
                      .length *
                  105))
              : 1400,
          child: TabBarView(
            children: [
              VehicleDetailTabView(
                purchaseMileageTextEditController:
                    _vehicleProfileBloc.purchaseMileageTextEditController,
                btnDeleteClicked: () {
                  Utils.showAlertDialogCallBack1(
                      context: context,
                      message:
                          'You are about to delete all data and attachments for the ${_vehicleProfileBloc.arrVehicle[_vehicleProfileBloc.selectedVehicle].Nickname ?? ''} profile. Please click Cancel or Confirm, below.',
                      isConfirmationDialog: false,
                      isOnlyOK: false,
                      navBtnName: 'Cancel',
                      posBtnName: 'Confirm',
                      onNavClick: () {},
                      onPosClick: () {
                        setState(() {
                          _vehicleProfileBloc.isDeleting = true;
                        });
                        _vehicleProfileBloc.deleteVehicle(context: context);
                      });
                },
                btnShareClicked: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UserAddDialog(
                            label: StringConstants.pdf_email,
                            onCancel: () {
                              Navigator.pop(context);
                            },
                            btnText: "Transfer",
                            onAdd: (value) {
                              setState(() {
                                _vehicleProfileBloc.userCheck(
                                    context: context, email: value.trim());
                              });
                              print(_vehicleProfileBloc.users);
                            });
                      });
                },
                btnCopyClicked: () {
                  if (_subscriptionBloc.subscriptionState['hasProAccess'] ==
                      true) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UserAddDialog(
                          label: StringConstants.pdf_copy,
                          subtext: StringConstants.subtext_pdf,
                          btnText: "Send",
                          onAdd: (value) {
                            _vehicleProfileBloc.btnCopyClicked(
                                context: context, email: value.trim());
                          },
                          onCancel: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  } else {
                    Utils.displaySubscriptionPopup(
                      context,
                      SubscriptionFeature.vehicleHistory,
                      _subscriptionBloc.subscriptionState,
                      RouteName.vehicleProfile,
                    );
                  }
                },
                onMileTypePress: (str) {
                  _vehicleProfileBloc.mileUnit = str;
                  setState(() {});
                },
                list: _vehicleProfileBloc.vehicleDetailList,
                mileUnit: _vehicleProfileBloc.mileUnit,
                nameTextEditController:
                    _vehicleProfileBloc.nameTextEditController,
                vinTextEditController:
                    _vehicleProfileBloc.vinTextEditController,
                currencyTextEditController:
                    _vehicleProfileBloc.currencyTextEditController,
                priceTextEditController:
                    _vehicleProfileBloc.priceTextEditController,
                purchaseTextEditController:
                    _vehicleProfileBloc.purchaseTextEditController,
                currentMileageTextEditController:
                    _vehicleProfileBloc.currentMileageTextEditController,
                purchaseDateTextEditController:
                    _vehicleProfileBloc.purchaseDateTextEditController,
                currentDateTextEditController:
                    _vehicleProfileBloc.currentDateTextEditController,
                isEditable: _vehicleProfileBloc.isEditable,
                btnCDateClicked: () {
                  _vehicleProfileBloc.btnCDateClicked(context: context);
                },
                btnPDateClicked: () {
                  _vehicleProfileBloc.btnPDateClicked(context: context);
                },
                btnEditClicked: () {
                  setState(() {
                    _vehicleProfileBloc.isEditable =
                        !_vehicleProfileBloc.isEditable;
                  });
                },
                btnSaveClicked: () {
                  _vehicleProfileBloc.btnSaveClicked(context: context);
                },
              ),
              AboutMyRideTabview(
                vehicleProfileBloc: _vehicleProfileBloc,
                selectedVehicle: _vehicleProfileBloc
                    .arrVehicle[_vehicleProfileBloc.selectedVehicle].id,
                list: _vehicleProfileBloc.vehiclePropertiesList,
              )
            ],
            controller: tabController,
          ),
        ),
      ],
    );
  }

  void openCalender() {
    showDatePicker(
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
      initialDate: DateTime.now(),
      firstDate: DateTime(1901),
      lastDate: DateTime(2025),
    );
  }
}
