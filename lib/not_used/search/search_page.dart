import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/drawer/my_ride_drawer.dart';
import 'package:myride901/not_used/search/search_bloc.dart';
import 'package:myride901/features/tabs/home/widget/seach_header.dart';
import 'package:myride901/features/tabs/share/widget/timeline_list_item.dart';
import 'package:myride901/core/services/analytic_services.dart';

class SearchPage extends StatefulWidget {
  final Function(int)? changeIndex;

  SearchPage({this.changeIndex});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchBloc = SearchBloc();
  AppThemeState _appTheme = AppThemeState();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    locator<AnalyticsService>().logScreens(name: "Search Page");
    super.initState();
    _searchBloc.user = AppComponentBase.getInstance().getLoginData().user;

    _searchBloc.getVehicleList(context: context, isProgressBar: false);
    _searchBloc.setLocalData();
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _searchBloc.mainStream,
          builder: (context, snapshot) {
            return StreamBuilder<dynamic>(
                initialData: null,
                stream: AppComponentBase.getInstance().loadStream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    AppComponentBase.getInstance().load(null);
                    _searchBloc.setLocalData();
                  }
                  return Scaffold(
                    key: _scaffoldKey,
                    drawer: MyRideDrawer(),
                    body: BlocProvider<SearchBloc>(
                        bloc: _searchBloc,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              SearchHeader(
                                fromDate: _searchBloc.fromDate,
                                toDate: _searchBloc.toDate,
                                fromMileage: _searchBloc.fromMileage,
                                toMileage: _searchBloc.toMileage,
                                onFromDateTap: () {
                                  _searchBloc.fromDatePicker(context);
                                },
                                onToDateTap: () {
                                  _searchBloc.toDatePicker(context);
                                },
                                onFieldSubmittedFromMileage: (data) {
                                  _searchBloc.filterData(false);
                                },
                                onFieldSubmittedToMileage: (data) {
                                  _searchBloc.filterData(false);
                                },
                              ),
                              if (_searchBloc.arrVehicle.length == 0 &&
                                  _searchBloc.isLoaded)
                                Expanded(
                                  child: Container(
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            StringConstants.add_first_vehicle,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15,
                                                color: _appTheme.primaryColor),
                                          ),
                                        )),
                                  ),
                                ),
                              if (_searchBloc.arrVehicle.length != 0)
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: _searchBloc.arrService.length,
                                      padding: const EdgeInsets.all(0),
                                      itemBuilder: (_, index) {
                                        return TimelineListItem(
                                          price: ((_searchBloc
                                                          .arrVehicle[_searchBloc
                                                              .selectedVehicle]
                                                          .isMyVehicle ??
                                                      0) ==
                                                  0)
                                              ? ''
                                              : _searchBloc.arrService[index]
                                                      .totalPrice ??
                                                  '',
                                          onCheckBoxClick: (value) {
                                            setState(() {
                                              _searchBloc.arrService[index]
                                                  .isSelected = value;
                                            });
                                          },
                                          currency: _searchBloc
                                              .arrVehicle[
                                                  _searchBloc.selectedVehicle]
                                              .currency,
                                          isSelected: _searchBloc
                                                  .arrService[index]
                                                  .isSelected ??
                                              false,
                                          hasCheckBox: false,
                                          onTap: () {
                                            _searchBloc.arrService[index]
                                                        .serviceProviderId ==
                                                    null
                                                ? _searchBloc.btnClicked2(
                                                    context: context,
                                                    index: index)
                                                : _searchBloc.btnClicked(
                                                    context: context,
                                                    index: index);
                                          },
                                          serviceName: _searchBloc
                                              .arrService[index].title,
                                          avatar: (_searchBloc
                                                  .arrService[index].avatar ??
                                              ''),
                                          miles: (_searchBloc.arrService[index]
                                                      .mileage ??
                                                  '') +
                                              ' ' +
                                              ((_searchBloc.arrService[index]
                                                              .mileage ??
                                                          '') ==
                                                      ''
                                                  ? ''
                                                  : ((_searchBloc
                                                                  .arrVehicle[
                                                                      _searchBloc
                                                                          .selectedVehicle]
                                                                  .mileageUnit ??
                                                              '') ==
                                                          'mile'
                                                      ? 'mi'
                                                      : 'km')),
                                          date: _searchBloc.arrService[index]
                                                  .serviceDate ??
                                              '',
                                          isLast: index ==
                                              _searchBloc.arrService.length - 1,
                                        );
                                      }),
                                )
                            ],
                          ),
                        )),
                  );
                });
          }),
    );
  }
}

class TimelineData {
  final String serviceName;
  final String km;
  final String date;
  final String amount;

  TimelineData(this.serviceName, this.km, this.date, this.amount);
}
