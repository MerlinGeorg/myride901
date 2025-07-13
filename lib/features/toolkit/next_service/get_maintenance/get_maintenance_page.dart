import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/core/services/analytic_services.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/my_ride_textform_field.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/toolkit/next_service/get_maintenance/get_maintenance_bloc.dart';

class GetMaintenancePage extends StatefulWidget {
  const GetMaintenancePage({Key? key}) : super(key: key);

  @override
  _GetMaintenancePageState createState() => _GetMaintenancePageState();
}

class _GetMaintenancePageState extends State<GetMaintenancePage> {
  final _getMaintenanceBloc = GetMaintenanceBloc();
  AppThemeState _appTheme = AppThemeState();
  String vin_num = '';

  _GetMaintenancePageState();

  @override
  void initState() {
    super.initState();
    _getMaintenanceBloc.setLocalData();
    locator<AnalyticsService>().logScreens(name: "Next Service Page");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String? receivedValue =
          ((ModalRoute.of(context)!.settings.arguments as ItemArgument).data
              as dynamic)['value'];
      _getMaintenanceBloc.val = receivedValue ?? '';
      _getMaintenanceBloc.arguments =
          (ModalRoute.of(context)!.settings.arguments as ItemArgument).data;
      if (_getMaintenanceBloc.arguments['reminder'] != null) {
        _getMaintenanceBloc.reminder =
            _getMaintenanceBloc.arguments['reminder'];
      }

      if (_getMaintenanceBloc.arguments['reminderData'] != null) {
        _getMaintenanceBloc.reminderData =
            _getMaintenanceBloc.arguments['reminderData'];
        print("Irina " + _getMaintenanceBloc.reminderData!.first);
      }
    });
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
          stream: _getMaintenanceBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: _appTheme.primaryColor,
                leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AssetImages.left_arrow),
                    )),
                title: Text(
                  StringConstants.maintenance,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              body: BlocProvider<GetMaintenanceBloc>(
                  bloc: _getMaintenanceBloc,
                  child: Container(
                    color: Color(0xffC3D7FF).withOpacity(0.1),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        MyRideTextFormField(
                          textEditingController: _getMaintenanceBloc.txtVin,
                          hintText: 'Enter your VIN*',
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MyRideTextFormField(
                          textEditingController: _getMaintenanceBloc.txtMileage,
                          hintText: 'Enter your current mileage*',
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).unfocus(),
                          ifs: [CustomTextInputFormatter()],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please note this feature is available for cars with 17-digit VINs from 1981 onward; VINs for other vehicle types and some late-model cars may not be supported at this time.",
                          style: GoogleFonts.roboto(
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 10),
                        ),
                        Spacer(),
                        BlueButton(
                          onPress: () {
                            _getMaintenanceBloc.btnSubmitClicked(
                                context: context);
                          },
                          text: StringConstants.submit,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )),
            );
          }),
    );
  }
}
