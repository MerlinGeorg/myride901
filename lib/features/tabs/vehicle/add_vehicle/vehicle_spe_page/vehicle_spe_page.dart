import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/enter_vehicle_spec.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/vehicle_spe_page/vehicle_spe_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class VehicleSpePage extends StatefulWidget {
  const VehicleSpePage({Key? key}) : super(key: key);

  @override
  _VehicleSpePageState createState() => _VehicleSpePageState();
}

class _VehicleSpePageState extends State<VehicleSpePage> {
  VehicelSpeBloc _vehicleSpeBloc = VehicelSpeBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _vehicleSpeBloc.arguments =
          (ModalRoute.of(context)!.settings.arguments as ItemArgument).data;
      if (_vehicleSpeBloc.arguments['selectedYear'] != null &&
          _vehicleSpeBloc.arguments['selectedMake'] != null &&
          _vehicleSpeBloc.arguments['selectedModel'] != null) {
        _vehicleSpeBloc.selectedYear =
            _vehicleSpeBloc.arguments['selectedYear'];
        _vehicleSpeBloc.selectedMake =
            _vehicleSpeBloc.arguments['selectedMake'];
        _vehicleSpeBloc.selectedModel =
            _vehicleSpeBloc.arguments['selectedModel'];
        _vehicleSpeBloc.getAdditionalData(context: context, screen: 'engines');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _vehicleSpeBloc.mainStream,
          builder: (context, snapshot) {
            if (_vehicleSpeBloc.isLoaded) {
              return Scaffold(
                resizeToAvoidBottomInset: true,
                body: BlocProvider<VehicelSpeBloc>(
                    bloc: _vehicleSpeBloc,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                      AppTheme.of(context).primaryColor,
                                      AppTheme.of(context)
                                          .primaryColor
                                          .withOpacity(0.4),
                                    ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter)),
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.22,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SvgPicture.asset(
                                      AssetImages.add_vehicle_car),
                                ),
                              ),
                              ColoredBox(
                                color: AppTheme.of(context)
                                    .primaryColor
                                    .withOpacity(0.4),
                                child: Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'Vehicle ${StringConstants.label_spec}',
                                                    style: GoogleFonts.roboto(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 20,
                                                        letterSpacing: 0.5,
                                                        color:
                                                            AppTheme.of(context)
                                                                .primaryColor),
                                                  ),
                                                  SizedBox(
                                                    height: 45,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            CircularPercentIndicator(
                                              radius: 30.0,
                                              lineWidth: 5.0,
                                              percent: 1,
                                              circularStrokeCap:
                                                  CircularStrokeCap.round,
                                              animation: false,
                                              animateFromLastPercent: false,
                                              center: Text(
                                                '5 of 5',
                                                style: GoogleFonts.roboto(
                                                    color: AppTheme.of(context)
                                                        .primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              ),
                                              progressColor:
                                                  AppTheme.of(context)
                                                      .primaryColor,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      EnterVehicleSpec(
                                        onContinuePress: () {
                                          _vehicleSpeBloc.btnAddClicked2(
                                              context: context);
                                        },
                                        onContinuePress2: () {
                                          _vehicleSpeBloc.btnAddClicked(
                                              context: context);
                                        },
                                        txtPMile: _vehicleSpeBloc.txtPMile,
                                        txtPDate: _vehicleSpeBloc.txtPDate,
                                        txtCMile: _vehicleSpeBloc.txtCMile,
                                        txtVin: _vehicleSpeBloc.txtVin,
                                        txtCDate: _vehicleSpeBloc.txtCDate,
                                        txtNickName:
                                            _vehicleSpeBloc.txtNickName,
                                        txtDrive: _vehicleSpeBloc.txtDrive,
                                        txtTrim: _vehicleSpeBloc.txtTrim,
                                        txtEngine: _vehicleSpeBloc.txtEngine,
                                        onEnginePress: _vehicleSpeBloc
                                                .arrEngine!.isEmpty
                                            ? null
                                            : () {
                                                if (_vehicleSpeBloc.arrEngine !=
                                                        null &&
                                                    _vehicleSpeBloc.arrEngine!
                                                            .length !=
                                                        0)
                                                  _vehicleSpeBloc.openSheet(
                                                      context: context,
                                                      arr: _vehicleSpeBloc
                                                          .arrEngine,
                                                      onTap: (str) {
                                                        _vehicleSpeBloc
                                                            .txtEngine
                                                            .text = str;
                                                        setState(() {});
                                                      });
                                              },
                                        onCDatePress: () {
                                          _vehicleSpeBloc.btnCDateClicked(
                                              context: context);
                                        },
                                        onPDatePress: () {
                                          _vehicleSpeBloc.btnPDateClicked(
                                              context: context);
                                        },
                                        mileType: _vehicleSpeBloc.mileType,
                                        onMileTypePress: (str) {
                                          _vehicleSpeBloc.mileType = str ?? '';
                                          setState(() {});
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            Positioned(
                                top: 40,
                                left: 20,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child:
                                      SvgPicture.asset(AssetImages.back_icon_1),
                                )),
                            Positioned(
                                top: 40,
                                right: 20,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        RouteName.dashboard, (route) => false);
                                  },
                                  child: SvgPicture.asset(
                                    AssetImages.vehicle_home,
                                    width: 34,
                                    height: 34,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    )),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
