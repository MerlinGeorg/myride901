import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/add_vehicle_option/add_vehicle_option_bloc.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/widget/base_background_add_vehicle.dart';

class AddVehicleOptionPage extends StatefulWidget {
  const AddVehicleOptionPage({Key? key}) : super(key: key);

  @override
  _AddVehicleOptionPageState createState() => _AddVehicleOptionPageState();
}

class _AddVehicleOptionPageState extends State<AddVehicleOptionPage> {
  final _addVehicleOptionBloc = AddVehicleOptionBloc();
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
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
          stream: _addVehicleOptionBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              body: BlocProvider<AddVehicleOptionBloc>(
                  bloc: _addVehicleOptionBloc,
                  child: BassBGAdfVehicle(
                    hasBackButton: true,
                    onBackPress: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringConstants.label_add_your_vehicle,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                letterSpacing: 0.5,
                                color: _appTheme.primaryColor),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            StringConstants.label_select_any_option,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                letterSpacing: 0.5,
                                color: Color(0xff121212).withOpacity(0.7)),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                          SelectionButton(
                            text: StringConstants.search_from_vin.toUpperCase(),
                            isSelected: false,
                            onPress: () {
                              setState(() {
                                _addVehicleOptionBloc.selected = 2;
                              });
                              _addVehicleOptionBloc.btnContinueClicked(
                                  context: context);
                            },
                          ),
                          SizedBox(
                            height: 45,
                          ),
                          SelectionButton(
                            text: StringConstants.choose_your_vehicle
                                .toUpperCase(),
                            isSelected: false,
                            onPress: () {
                              setState(() {
                                _addVehicleOptionBloc.selected = 1;
                              });
                              _addVehicleOptionBloc.btnContinueClicked(
                                  context: context);
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SelectionButton(
                            text: StringConstants.label_add_manually
                                .toUpperCase(),
                            isSelected: false,
                            onPress: () {
                              setState(() {
                                _addVehicleOptionBloc.selected = 3;
                              });
                              _addVehicleOptionBloc.btnContinueClicked(
                                  context: context);
                            },
                          ),
                          // Spacer(),
                          // BlueButton(
                          //   onPress: () {
                          //     _addVehicleOptionBloc.btnContinueClicked(context: context);
                          //   },
                          //   text: StringConstants.label_continue.toUpperCase(),
                          // )
                        ],
                      ),
                    ),
                  )),
            );
          }),
    );
  }
}

class SelectionButton extends StatelessWidget {
  final bool? isSelected;
  final String? text;
  final Function()? onPress;

  const SelectionButton({Key? key, this.isSelected, this.text, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress?.call();
      },
      child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: (isSelected ?? false)
                      ? AppTheme.of(context).primaryColor
                      : Colors.grey.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: (isSelected ?? false)
                        ? AppTheme.of(context).primaryColor.withOpacity(0.3)
                        : Colors.transparent,
                    blurRadius: 12.0,
                    spreadRadius: 2.0,
                    offset: Offset(4, 3)),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Text(
                (text ?? '').toUpperCase(),
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Color(0xff121212)),
              ),
            ),
          )),
    );
  }
}
