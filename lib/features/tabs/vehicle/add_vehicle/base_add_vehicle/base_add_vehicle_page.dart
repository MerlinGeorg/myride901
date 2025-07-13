import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/base_add_vehicle_bloc.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/select_vehicle_make.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/select_vehicle_model.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/select_vehicle_year.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/select_vehicle_type.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/widget/base_background_add_vehicle.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BaseAddVehiclePage extends StatefulWidget {
  const BaseAddVehiclePage({Key? key}) : super(key: key);

  @override
  _BaseAddVehiclePageState createState() => _BaseAddVehiclePageState();
}

class _BaseAddVehiclePageState extends State<BaseAddVehiclePage> {
  final _baseAddVehicleBloc = BaseAddVehicleBloc();
  AppThemeState _appTheme = AppThemeState();
  PageController? _pageController;
  StreamController<int> _pageStreamController = StreamController();

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, keepPage: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _baseAddVehicleBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: BlocProvider<BaseAddVehicleBloc>(
                  bloc: _baseAddVehicleBloc,
                  child: BassBGAdfVehicle(
                    hasBackButton: true,
                    onBackPress: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (_pageController!.page!.toInt() > 0) {
                        _pageController?.previousPage(
                            duration: Duration(milliseconds: 900),
                            curve: Curves.linearToEaseOut);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder(
                              initialData: 0,
                              stream: _pageStreamController.stream,
                              builder: (_, snapshot) {
                                return snapshot.hasData
                                    ? getHeader(snapshot.data as int? ?? 0)
                                    : Offstage();
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: PageView(
                              physics: NeverScrollableScrollPhysics(),
                              controller: _pageController,
                              onPageChanged: (index) {
                                _pageStreamController.sink.add(index);
                              },
                              children: [
                                SelectVehicleType(
                                  arrData: [
                                    {
                                      'title': 'Cars',
                                      'img': AssetImages.type1,
                                      'value': 'car'
                                    },
                                    {
                                      'title': 'Motorcycles',
                                      'img': AssetImages.type2,
                                      'value': 'moto'
                                    }
                                  ],
                                  onVehicleTypeSelect: (type) {
                                    if (type == 'moto') {
                                      // Temporary switch from vehapi to carmd, looking for alternative to restore moto services
                                      CommonToast.getInstance().displayToast(
                                          message:
                                              "Service is currently unavailable");
                                    } else {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      _baseAddVehicleBloc.txtSearchYear.text =
                                          '';
                                      _baseAddVehicleBloc.arrYear = [];
                                      setState(() {});
                                      _pageController?.nextPage(
                                          duration: Duration(milliseconds: 900),
                                          curve: Curves.linearToEaseOut);
                                      _baseAddVehicleBloc.selectedType = type;
                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        _baseAddVehicleBloc.getData(
                                            context: context,
                                            screen: 'year',
                                            year: null);
                                      });
                                    }
                                  },
                                ),
                                SelectVehicleYear(
                                  onVehicleTypeSelect: (type) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    _baseAddVehicleBloc.txtSearchMake.text = '';
                                    _baseAddVehicleBloc.arrMake = [];
                                    setState(() {});
                                    _pageController?.nextPage(
                                        duration: Duration(milliseconds: 900),
                                        curve: Curves.linearToEaseOut);
                                    _baseAddVehicleBloc.selectedYear = type;
                                    Future.delayed(Duration(milliseconds: 500),
                                        () {
                                      _baseAddVehicleBloc.getData(
                                          context: context,
                                          screen: 'makes',
                                          year: type);
                                    });
                                  },
                                  txtSearch: _baseAddVehicleBloc.txtSearchYear,
                                  onChanged: (str) {
                                    setState(() {});
                                  },
                                  arrData: _baseAddVehicleBloc
                                              .txtSearchYear.text ==
                                          ''
                                      ? _baseAddVehicleBloc.arrYear
                                      : _baseAddVehicleBloc.arrYear
                                          .where((element) => element
                                              .toLowerCase()
                                              .contains(_baseAddVehicleBloc
                                                  .txtSearchYear.text
                                                  .toLowerCase()))
                                          .toList(),
                                ),
                                SelectVehicleMake(
                                  onVehicleSelect: (type) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    _baseAddVehicleBloc.txtSearchModel.text =
                                        '';
                                    _baseAddVehicleBloc.arrModel = [];
                                    setState(() {});
                                    _pageController?.nextPage(
                                        duration: Duration(milliseconds: 900),
                                        curve: Curves.linearToEaseOut);
                                    _baseAddVehicleBloc.selectedMake = type;
                                    Future.delayed(Duration(milliseconds: 500),
                                        () {
                                      _baseAddVehicleBloc.getData(
                                          context: context,
                                          screen: 'models',
                                          make: type);
                                    });
                                  },
                                  txtSearch: _baseAddVehicleBloc.txtSearchMake,
                                  onChanged: (str) {
                                    setState(() {});
                                  },
                                  arrData: _baseAddVehicleBloc
                                              .txtSearchMake.text ==
                                          ''
                                      ? _baseAddVehicleBloc.arrMake
                                      : _baseAddVehicleBloc.arrMake
                                          .where((element) => element.name
                                              .toLowerCase()
                                              .startsWith(_baseAddVehicleBloc
                                                  .txtSearchMake.text
                                                  .toLowerCase()))
                                          .toList(),
                                ),
                                SelectVehicleMode(
                                  onVehicleName: (type) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    _baseAddVehicleBloc.selectedModel = type;

                                    Navigator.pushNamed(
                                        context, RouteName.addVehicleSpe,
                                        arguments: ItemArgument(data: {
                                          'selectedType':
                                              _baseAddVehicleBloc.selectedType,
                                          'selectedYear':
                                              _baseAddVehicleBloc.selectedYear,
                                          'selectedMake':
                                              _baseAddVehicleBloc.selectedMake,
                                          'selectedModel':
                                              _baseAddVehicleBloc.selectedModel
                                        }));
                                  },
                                  txtSearch: _baseAddVehicleBloc.txtSearchModel,
                                  onChanged: (str) {
                                    setState(() {});
                                  },
                                  arrData:
                                      _baseAddVehicleBloc.txtSearchModel.text ==
                                              ''
                                          ? _baseAddVehicleBloc.arrModel
                                          : _baseAddVehicleBloc.arrModel
                                              .where((element) => element
                                                  .toLowerCase()
                                                  .contains(_baseAddVehicleBloc
                                                      .txtSearchModel.text
                                                      .toLowerCase()))
                                              .toList(),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            );
          }),
    );
  }

  @override
  void dispose() {
    _pageStreamController.close();
    _pageController?.dispose();
    super.dispose();
  }

  Widget getHeader(int index) {
    var title = StringConstants.label_type;
    switch (index) {
      case 1:
        title = StringConstants.label_year;
        break;
      case 2:
        title = StringConstants.label_make;
        break;
      case 3:
        title = StringConstants.label_model;
        break;
      case 4:
        title = StringConstants.label_spec;
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle $title',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      letterSpacing: 0.5,
                      color: AppTheme.of(context).primaryColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Select your vehicle ${title.toLowerCase()}',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      letterSpacing: 0.5,
                      color: Color(0xff121212).withOpacity(0.7)),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 5.0,
            percent: 0.20 * (index + 1),
            circularStrokeCap: CircularStrokeCap.round,
            animation: false,
            animateFromLastPercent: false,
            center: Text(
              '${index + 1} of 5',
              style: GoogleFonts.roboto(
                  color: AppTheme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
            progressColor: AppTheme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
