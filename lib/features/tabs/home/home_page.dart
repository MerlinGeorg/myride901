import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/features/subscription/subscription_bloc.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/home/home_bloc.dart';
import 'package:myride901/features/tabs/home/widget/blog_tab_view.dart';
import 'package:myride901/features/tabs/home/widget/event_tab_view.dart';
import 'package:myride901/features/tabs/home/widget/home_header.dart';
import 'package:myride901/features/drawer/my_ride_drawer.dart';
import 'package:myride901/core/services/analytic_services.dart';
import 'package:upgrader/upgrader.dart';

class HomePage extends StatefulWidget {
  final Function? onFullTimelinePress;
  final Function(int)? changeIndex;
  final int? tabview;

  HomePage({this.onFullTimelinePress, this.changeIndex, this.tabview});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _homeBloc = HomeBloc();
  final _subscriptionBloc = SubscriptionBloc();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppThemeState _appTheme = AppThemeState();
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    locator<AnalyticsService>().logScreens(name: "Home Page");
    _subscriptionBloc.getUserStatus();
    _homeBloc.getVehicleList(
        context: context,
        isProgressBar:
            !AppComponentBase.getInstance().isArrVehicleProfileFetch);
    tabController = TabController(length: 2, vsync: this);
    tabController!.index = widget.tabview ?? 0;
    tabController?.addListener(() {
      setState(() {
        _homeBloc.selectedIndex = tabController!.index;
      });
      if (!tabController!.indexIsChanging) {
        if (tabController!.index == 1) {
          locator<AnalyticsService>().logScreens(name: "Tips & Advice");
          print("Event for tips");
        }
      }
    });

    _homeBloc.user = AppComponentBase.getInstance().getLoginData().user;
    _homeBloc.getBlogList(context: context);
    _homeBloc.getVehicleList(
        context: context,
        isProgressBar:
            !AppComponentBase.getInstance().isArrVehicleProfileFetch);
    _homeBloc.setLocalData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showReminderPopupWithDelay();
    });
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return UpgradeAlert(
      upgrader: Upgrader(messages: MyrideUpgraderMessages()),
      showIgnore: false,
      showLater: false,
      dialogStyle: Platform.isAndroid
          ? UpgradeDialogStyle.material
          : UpgradeDialogStyle.cupertino,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MyRideDrawer(),
        body: BlocProvider<HomeBloc>(
          bloc: _homeBloc,
          child: StreamBuilder<dynamic>(
              initialData: null,
              stream: _homeBloc.mainStream,
              builder: (context, snapshot) {
                return StreamBuilder<dynamic>(
                    initialData: null,
                    stream: AppComponentBase.getInstance().loadStream,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        AppComponentBase.getInstance().load(null);
                        _homeBloc.setLocalData();
                      }
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: [
                            ListView(
                              physics: ClampingScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              children: [
                                HomeHeader(
                                  isMyVehicle: _homeBloc.arrVehicle.length == 0
                                      ? 0
                                      : (_homeBloc
                                              .arrVehicle[
                                                  _homeBloc.selectedVehicle]
                                              .isMyVehicle ??
                                          0),
                                  lastEvent: _homeBloc.arrVehicle.length == 0
                                      ? '\$ 0'
                                      : '${_homeBloc.arrVehicle[_homeBloc.selectedVehicle].currency} ${_homeBloc.totalPrice}',
                                  totalEvent:
                                      _homeBloc.arrService.length.toString(),
                                  vehicleImage: _homeBloc.arrVehicle.length == 0
                                      ? ''
                                      : Utils.getProfileImage(
                                          _homeBloc.arrVehicle[
                                              _homeBloc.selectedVehicle]),
                                  vehicleName: _homeBloc.arrVehicle.length == 0
                                      ? ''
                                      : (_homeBloc
                                                      .arrVehicle[_homeBloc
                                                          .selectedVehicle]
                                                      .isMyVehicle ==
                                                  0
                                              ? _homeBloc
                                                  .arrVehicle[
                                                      _homeBloc.selectedVehicle]
                                                  .displayName
                                              : _homeBloc
                                                  .arrVehicle[
                                                      _homeBloc.selectedVehicle]
                                                  .Nickname) ??
                                          '',
                                  onVehicleDropDownClick: () {
                                    _homeBloc.openSheet(context, () {
                                      widget.changeIndex!(4);
                                    });
                                  },
                                  onDrawerClick: () {
                                    _scaffoldKey.currentState?.openDrawer();
                                  },
                                ),
                                SizedBox(height: 20),
                                TabBar(
                                  unselectedLabelColor:
                                      Colors.black.withOpacity(0.5),
                                  labelPadding:
                                      EdgeInsets.symmetric(horizontal: 3),
                                  labelColor: AppTheme.of(context).primaryColor,
                                  indicatorColor:
                                      AppTheme.of(context).primaryColor,
                                  labelStyle: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  tabs: [
                                    Tab(text: 'RECENT SERVICE EVENTS'),
                                    Tab(text: 'TIPS & ADVICE')
                                  ],
                                  controller: tabController,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  onTap: (index) {},
                                ),
                                SizedBox(
                                  height: _homeBloc.selectedIndex == 1
                                      ? ((_homeBloc.arrBlog.length * 115.0) +
                                          (_homeBloc.blogIsFinish ? 85 : 0))
                                      : (((_homeBloc.arrService.length > 3
                                              ? _homeBloc.arrService.length
                                              : 3) *
                                          145.0)),
                                  child: TabBarView(
                                    children: [
                                      _homeBloc.arrVehicle.length > 0
                                          ? _homeBloc.arrService.length > 0 ||
                                                  _homeBloc.isFilter
                                              ? EventTabView(
                                                  homeBloc: _homeBloc,
                                                  list: _homeBloc.arrService
                                                      .toList(),
                                                  searchController: _homeBloc
                                                      .searchController,
                                                  onFullTimelinePress: widget
                                                      .onFullTimelinePress!,
                                                  vehicleProfile: _homeBloc
                                                              .arrVehicle
                                                              .length >
                                                          0
                                                      ? _homeBloc.arrVehicle[
                                                          _homeBloc
                                                              .selectedVehicle]
                                                      : VehicleProfile.fromJson(
                                                          {}),
                                                  onTap: (index) {
                                                    _homeBloc.searchController
                                                        ?.clear();

                                                    _homeBloc.arrService[index]
                                                                .serviceProviderId ==
                                                            null
                                                        ? _homeBloc.btnClicked2(
                                                            context: context,
                                                            index: index)
                                                        : _homeBloc.btnClicked(
                                                            context: context,
                                                            index: index);
                                                  },
                                                )
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                      EmptyListItem(
                                                        title:
                                                            "Add Your First Service Event",
                                                      ),
                                                      EmptyListItem(
                                                        title: "Purchased on " +
                                                            _homeBloc
                                                                .arrVehicle[
                                                                    _homeBloc
                                                                        .selectedVehicle]
                                                                .PDate
                                                                .toString(),
                                                        icon: SvgPicture.asset(
                                                            AssetImages.star),
                                                      )
                                                    ])
                                          : Container(),
                                      BlocTabView(
                                          list: _homeBloc.arrBlog,
                                          onLoadMorePress: () {
                                            _homeBloc.getBlogList(
                                                context: context);
                                          },
                                          blogIsFinish: _homeBloc.blogIsFinish)
                                    ],
                                    controller: tabController,
                                  ),
                                ),
                              ],
                            ),
                            if (_homeBloc.isFilter == true &&
                                _homeBloc.arrService.length == 0)
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            _appTheme.primaryColor),
                                    child: Text(
                                      "Reset Filter",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _homeBloc.isFilter = false;
                                        _homeBloc.searchController?.clear();
                                        _homeBloc.setLocalData();
                                      });
                                    },
                                  ),
                                ),
                              )
                          ],
                        ),
                      );
                    });
              }),
        ),
      ),
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
              primary: _appTheme.primaryColor,
              onPrimary: Colors.white,
              surface: _appTheme.primaryColor,
              onSurface: Colors.grey,
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

  void showReminderPopupWithDelay() async {
    await Future.delayed(Duration(seconds: 2));

    Utils.displayReminderTrialEndPopup(
      context,
      _subscriptionBloc.subscriptionState,
    );
  }
}
