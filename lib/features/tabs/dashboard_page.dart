import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/services/firebase_messaging_manager.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/tabs/dashboard_bloc.dart';
import 'package:myride901/features/tabs/home/home_page.dart';
import 'package:myride901/features/tabs/reminders/reminders_page.dart';
import 'package:myride901/features/tabs/share/share_page.dart';
import 'package:myride901/features/tabs/vehicle/vehicle_page.dart';
import 'package:myride901/core/services/analytic_services.dart';

class DashboardPage extends StatefulWidget {
  final int? tabview;
  final int? selectedTab;

  DashboardPage({Key? key, this.tabview, this.selectedTab}) : super(key: key);
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  AppThemeState _appTheme = AppThemeState();
  final _dashBoardBloc = DashboardBloc();

  @override
  void initState() {
    super.initState();
    _dashBoardBloc.selectedTab = widget.selectedTab ?? 1;
    _dashBoardBloc.getVehicleList(context: context);
    _dashBoardBloc.cars =
        AppComponentBase.getInstance().getLoginData().user?.totalVehicles;
    print(_dashBoardBloc.cars);
    _dashBoardBloc.events =
        AppComponentBase.getInstance().getLoginData().user!.totalEvents;
    print(_dashBoardBloc.events);
    load();
  }

  void load() async {
    AppComponentBase.getInstance().setContext(context: context);

    final FirebaseMessagingManager _firebaseMessaging =
        FirebaseMessagingManager();
    await _firebaseMessaging.init(
        context: AppComponentBase.getInstance().currentContext);
    _firebaseMessaging.getToken().then((value) {
      print('token:-$value');
      if (value != null) updateToken(value);
    });
    AppComponentBase.getInstance()
        .getSharedPreference()
        .initPreference()
        .then((value) {
      value.remove("url");
    });
  }

  void updateToken(String value) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getUserRepository()
        .updateToken(deviceToken: value)
        .then((value) {})
        .catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    AppComponentBase.getInstance().setContext(context: context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return WillPopScope(
      onWillPop: () {
        if (_dashBoardBloc.selectedTab == 1) {
          SystemNavigator.pop();
        } else {
          setState(() {
            _dashBoardBloc.selectedTab = 1;
          });
        }

        return Future.value(false);
      },
      child: StreamBuilder<dynamic>(
          initialData: null,
          stream: AppComponentBase.getInstance().changeIndexStream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              _dashBoardBloc.selectedTab = snapshot.data;

              AppComponentBase.getInstance().changeIndex(null);
            }
            return StreamBuilder<dynamic>(
                initialData: null,
                stream: _dashBoardBloc.mainStream,
                builder: (context, snapshot) {
                  return Scaffold(
                    backgroundColor: _appTheme.whiteColor,
                    bottomNavigationBar: BottomAppBar(
                      surfaceTintColor: _appTheme.whiteColor,
                      elevation: 0,
                      color: _appTheme.whiteColor,
                      height: 90,
                      child: Container(
                        color: _appTheme.whiteColor,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    BottomIcon(
                                      isSelected:
                                          _dashBoardBloc.selectedTab == 1,
                                      icon: AssetImages.home,
                                      title: 'Home',
                                      onTap: () {
                                        setState(() {
                                          _dashBoardBloc.selectedTab = 1;
                                        });
                                      },
                                    ),
                                    BottomIcon(
                                      isSelected:
                                          _dashBoardBloc.selectedTab == 2,
                                      onTap: () {
                                        locator<AnalyticsService>()
                                            .sendAnalyticsEvent(
                                                eventName: "RemindersButton",
                                                clickevent:
                                                    "User tap on reminders button");
                                        setState(() {
                                          _dashBoardBloc.arrVehicle.isEmpty
                                              ? Utils.showAlertDialogCallBack1(
                                                  context: context,
                                                  message: StringConstants
                                                      .reminder_requirement,
                                                  isConfirmationDialog: false,
                                                  isOnlyOK: false,
                                                  navBtnName: 'Cancel',
                                                  posBtnName: 'Add a vehicle',
                                                  onNavClick: () {},
                                                  onPosClick: () {
                                                    Navigator.pushNamed(
                                                        context,
                                                        RouteName
                                                            .addVehicleOption);
                                                  })
                                              : _dashBoardBloc.selectedTab = 2;
                                        });
                                      },
                                      icon: AssetImages.notification_bell,
                                      title: StringConstants.reminder,
                                    ),
                                    _dashBoardBloc.cars != 0 &&
                                            _dashBoardBloc.events != 0
                                        ? FloatingActionButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            backgroundColor:
                                                _appTheme.primaryColor,
                                            onPressed: () {
                                              locator<AnalyticsService>()
                                                  .sendAnalyticsEvent(
                                                      eventName: "plusButton",
                                                      clickevent:
                                                          "User tap on plus button");
                                              if (AppComponentBase.getInstance()
                                                      .getArrVehicleProfile(
                                                          onlyMy: true)
                                                      .length ==
                                                  0) {
                                                Navigator.of(context)
                                                    .pushNamed(RouteName
                                                        .addVehicleOption)
                                                    .then((value) {
                                                  if (AppComponentBase
                                                          .getInstance()
                                                      .isRedirect) {
                                                    AppComponentBase
                                                            .getInstance()
                                                        .changeRedirect(false);
                                                    _dashBoardBloc
                                                        .changeIndex(4);
                                                  }
                                                });
                                              } else {
                                                _dashBoardBloc.openSheetService(
                                                    context: context);
                                              }
                                            },
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          )
                                        : AvatarGlow(
                                            glowColor: _appTheme.primaryColor,
                                            endRadius: 33.0,
                                            duration:
                                                Duration(milliseconds: 2000),
                                            repeat: true,
                                            showTwoGlows: true,
                                            repeatPauseDuration:
                                                Duration(milliseconds: 100),
                                            child: FloatingActionButton(
                                              backgroundColor:
                                                  _appTheme.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              onPressed: () {
                                                locator<AnalyticsService>()
                                                    .sendAnalyticsEvent(
                                                        eventName: "plusButton",
                                                        clickevent:
                                                            "User tap on plus button");
                                                if (AppComponentBase
                                                            .getInstance()
                                                        .getArrVehicleProfile(
                                                            onlyMy: true)
                                                        .length ==
                                                    0) {
                                                  Navigator.of(context)
                                                      .pushNamed(RouteName
                                                          .addVehicleOption)
                                                      .then((value) {
                                                    if (AppComponentBase
                                                            .getInstance()
                                                        .isRedirect) {
                                                      AppComponentBase
                                                              .getInstance()
                                                          .changeRedirect(
                                                              false);
                                                      _dashBoardBloc
                                                          .changeIndex(4);
                                                    }
                                                  });
                                                } else {
                                                  _dashBoardBloc
                                                      .openSheetService(
                                                          context: context);
                                                }
                                              },
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                    BottomIcon(
                                      isSelected:
                                          _dashBoardBloc.selectedTab == 3,
                                      icon: AssetImages.share,
                                      title: 'Share',
                                      onTap: () {
                                        locator<AnalyticsService>()
                                            .sendAnalyticsEvent(
                                                eventName: "ShareButton",
                                                clickevent:
                                                    "User tap on share button");
                                        setState(() {
                                          _dashBoardBloc.selectedTab = 3;
                                        });
                                      },
                                    ),
                                    BottomIcon(
                                      isSelected:
                                          _dashBoardBloc.selectedTab == 4,
                                      icon: AssetImages.car,
                                      title: 'Vehicle',
                                      onTap: () {
                                        locator<AnalyticsService>()
                                            .sendAnalyticsEvent(
                                                eventName: "VehicleButton",
                                                clickevent:
                                                    "User tap on share button");
                                        setState(() {
                                          _dashBoardBloc.arrVehicle.isEmpty
                                              ? Utils.showAlertDialogCallBack1(
                                                  context: context,
                                                  message: StringConstants
                                                      .veh_profile_requirement,
                                                  isConfirmationDialog: false,
                                                  isOnlyOK: false,
                                                  navBtnName: 'Cancel',
                                                  posBtnName: 'Add a vehicle',
                                                  onNavClick: () {},
                                                  onPosClick: () {
                                                    Navigator.pushNamed(
                                                        context,
                                                        RouteName
                                                            .addVehicleOption);
                                                  })
                                              : _dashBoardBloc.selectedTab = 4;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                    body: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                      child: Container(
                        child: _dashBoardBloc.needRefresh
                            ? Container()
                            : _getSelectedTabWidget(),
                      ),
                    ),
                  );
                });
          }),
    );
  }

  Widget _getSelectedTabWidget([int? tabIndex]) {
    switch (tabIndex ?? _dashBoardBloc.selectedTab) {
      case 1:
        return HomePage(
          onFullTimelinePress: () {
            setState(() {
              _dashBoardBloc.selectedTab = 3;
            });
          },
          changeIndex: _dashBoardBloc.changeIndex,
          tabview: widget.tabview ?? 0,
        );
      case 2:
        return RemindersPage(
          changeIndex: _dashBoardBloc.changeIndex,
        );
      case 3:
        return SharePage(
          changeIndex: _dashBoardBloc.changeIndex,
        );
      case 4:
        return VehicleProfilePage();
      default:
        return Container();
    }
  }
}

class BottomIcon extends StatelessWidget {
  final String icon;
  final String title;
  final bool isSelected;
  final Function()? onTap;

  const BottomIcon(
      {Key? key,
      this.icon = AssetImages.home,
      this.isSelected = false,
      this.title = '',
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              width: 30,
              color: isSelected
                  ? AppTheme.of(context).primaryColor
                  : Color(0xff707070),
              height: 30,
            ),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: isSelected
                    ? AppTheme.of(context).primaryColor
                    : Color(0xff707070),
              ),
            ),
          ],
        ),
      ),
    );
  }
}