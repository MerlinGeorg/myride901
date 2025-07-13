import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/features/subscription/subscription_bloc.dart';
import 'package:myride901/features/subscription/widgets/subscription_info_popup.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/trip/trip.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/core/services/analytic_services.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/toolkit/track_mileage/track_mileage_bloc.dart';
import 'package:myride901/features/toolkit/track_mileage/widget/dropdown_item.dart';
import 'package:myride901/features/toolkit/track_mileage/widget/trip_list_view.dart';

class TripPage extends StatefulWidget {
  const TripPage({Key? key}) : super(key: key);

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  final _tripBloc = TripBloc();
  AppThemeState _appTheme = AppThemeState();
  var _arguments;

  VehicleProfile _selectedItem = VehicleProfile.getInstance();
  List<DropdownMenuItem<VehicleProfile>> _dropdownList = [];
  bool initial = false;
  List<DropdownMenuItem<VehicleProfile>> _buildFavouriteFoodModelDropdown(
      List itemList) {
    List<DropdownMenuItem<VehicleProfile>> items = [];
    if (!initial) {
      if (itemList.isNotEmpty) {
        _selectedItem = itemList[0];
        initial = true;
      }
    }
    for (VehicleProfile item in itemList) {
      items.add(DropdownMenuItem(
          value: item,
          child: Text(item.Nickname ?? "",
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff121212)))));
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    locator<AnalyticsService>().logScreens(name: "Track Mileage Page");

    _tripBloc.getArrVehicle(
        context: context,
        isProgressBar:
            !AppComponentBase.getInstance().isArrVehicleProfileFetch);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _arguments =
          (ModalRoute.of(context)?.settings.arguments as ItemArgument).data;
      if (_arguments['selectedVehicle'] != null) {
        _tripBloc.selectedVehicle = _arguments['selectedVehicle'];
      }
      if (_arguments['isTrip'] != null) {
        _tripBloc.isTrip = _arguments['isTrip'];
      }
      setState(() {
        _tripBloc.isLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    int selectedChipIndex = 0;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
        initialData: false,
        stream: _tripBloc.mainStream,
        builder: (context, snapshot) {
          _dropdownList =
              _buildFavouriteFoodModelDropdown(_tripBloc.arrVehicle);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: _appTheme.primaryColor,
              elevation: 0,
              title: Text(
                StringConstants.app_mileage_tracker,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white),
              ),
              leading: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.dashboard);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(AssetImages.left_arrow),
                ),
              ),
              actions: [
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () async {
                        final _subscriptionBloc = SubscriptionBloc();
                        EasyLoading.show();
                        await _subscriptionBloc.getUserStatus();
                        EasyLoading.dismiss();

                        if (_subscriptionBloc
                                .subscriptionState['hasProAccess'] ==
                            true) {
                          Navigator.pushNamed(context, RouteName.addTrip,
                              arguments: ItemArgument(data: {
                                'selectedVehicle': _tripBloc.selectedVehicle,
                                'mileageUnit': _tripBloc
                                    .arrVehicle[_tripBloc.selectedVehicle]
                                    .mileageUnit
                              }));
                        } else {
                          Utils.displaySubscriptionPopup(
                            context,
                            SubscriptionFeature.trackMileage,
                            _subscriptionBloc.subscriptionState,
                            RouteName.dashboard,
                          );
                        }
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
            body: BlocProvider<TripBloc>(
              bloc: _tripBloc,
              child: StreamBuilder<dynamic>(
                  initialData: false,
                  stream: _tripBloc.mainStream,
                  builder: (context, snapshot) {
                    return StreamBuilder<dynamic>(
                        initialData: false,
                        stream: AppComponentBase.getInstance().loadStream,
                        builder: (context, snapshot) {
                          return !_tripBloc.isLoaded
                              ? Scaffold(
                                  body: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ActionChip(
                                          label: Text(
                                            'All',
                                            style: TextStyle(
                                              color: selectedChipIndex == 0
                                                  ? Colors.white
                                                  : _appTheme.primaryColor,
                                            ),
                                          ),
                                          backgroundColor:
                                              selectedChipIndex == 0
                                                  ? _appTheme.primaryColor
                                                  : Colors.white,
                                          onPressed: () {
                                            selectedChipIndex = 0;
                                            _tripBloc.getTripList(
                                                context: context);
                                          },
                                        ),
                                        ActionChip(
                                          label: Text(
                                            'Personal',
                                            style: TextStyle(
                                              color: selectedChipIndex == 1
                                                  ? Colors.white
                                                  : _appTheme.primaryColor,
                                            ),
                                          ),
                                          backgroundColor:
                                              selectedChipIndex == 1
                                                  ? _appTheme.primaryColor
                                                  : Colors.white,
                                          onPressed: () {
                                            selectedChipIndex = 1;
                                            _tripBloc.getTripPersonal(
                                                context: context);
                                          },
                                        ),
                                        ActionChip(
                                          label: Text(
                                            'Business',
                                            style: TextStyle(
                                              color: selectedChipIndex == 2
                                                  ? Colors.white
                                                  : _appTheme.primaryColor,
                                            ),
                                          ),
                                          backgroundColor:
                                              selectedChipIndex == 2
                                                  ? _appTheme.primaryColor
                                                  : Colors.white,
                                          onPressed: () {
                                            selectedChipIndex = 2;
                                            _tripBloc.getTripBusiness(
                                                context: context);
                                          },
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      alignment: Alignment.center,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            DropdownItem(
                                              textEditingController:
                                                  TextEditingController(),
                                              onVehicleSelect: (value) async {
                                                setState(() {
                                                  _tripBloc.selectedVehicle =
                                                      value;
                                                  _tripBloc.vehicleProfile =
                                                      _tripBloc
                                                          .arrVehicle[value];
                                                  _selectedItem = _tripBloc
                                                      .arrVehicle[value];
                                                  _tripBloc.getTripList(
                                                      context: context);
                                                });
                                              },
                                              vehicleList: _tripBloc.arrVehicle,
                                              selectedVehicle:
                                                  _tripBloc.selectedVehicle,
                                            ),
                                          ]),
                                    ),
                                    // Export CSV
                                    _tripBloc.arrTrip.length == 0
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  StringConstants.export_csv,
                                                  style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                IconButton(
                                                  icon:
                                                      Icon(Icons.file_download),
                                                  onPressed: () {
                                                    AppComponentBase
                                                            .getInstance()
                                                        .showProgressDialog(
                                                            true);
                                                    _tripBloc.exportToCsv(
                                                        _tripBloc.arrTripAll);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                    // List of Trips
                                    Expanded(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: (_tripBloc.arrTrip.length == 0 &&
                                                _tripBloc.isLoaded)
                                            ? Center(
                                                child: Text(
                                                  'You do not have any records yet',
                                                  style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 15,
                                                    color: Color(0xff121212)
                                                        .withOpacity(0.4),
                                                  ),
                                                ),
                                              )
                                            : ListView(
                                                physics:
                                                    ClampingScrollPhysics(),
                                                padding:
                                                    const EdgeInsets.all(0),
                                                children: [
                                                  TripListView(
                                                    list: _tripBloc.arrTrip,
                                                    trip: Trip.fromJson({}),
                                                    btnDeleteClicked: (index) {
                                                      _tripBloc.deleteTrip(
                                                          context: context,
                                                          index: index);
                                                    },
                                                    currency: _tripBloc
                                                            .arrVehicle[_tripBloc
                                                                .selectedVehicle]
                                                            .currency ??
                                                        '',
                                                    btnEditClicked: (index) {
                                                      _tripBloc.btnClicked(
                                                          context: context,
                                                          index: index);
                                                    },
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ],
                                );
                        });
                  }),
            ),
          );
        },
      ),
    );
  }
}
