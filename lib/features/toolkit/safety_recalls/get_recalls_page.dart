import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/analytic_services.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/my_ride_textform_field.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/toolkit/safety_recalls/get_recalls_bloc.dart';

class GetRecallPage extends StatefulWidget {
  const GetRecallPage({Key? key}) : super(key: key);

  @override
  _GetRecallPageState createState() => _GetRecallPageState();
}

class _GetRecallPageState extends State<GetRecallPage> {
  final _getRecallsBloc = GetRecallsBloc();
  AppThemeState _appTheme = AppThemeState();
  String vin_num = '';

  _GetRecallPageState();

  @override
  void initState() {
    super.initState();
    locator<AnalyticsService>().logScreens(name: "Safety Recalls Page");

    _getRecallsBloc.setLocalData();
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
        stream: _getRecallsBloc.mainStream,
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
                ),
              ),
              title: Text(
                StringConstants.recalls_scan,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            body: BlocProvider<GetRecallsBloc>(
              bloc: _getRecallsBloc,
              child: StreamBuilder<bool>(
                stream: _getRecallsBloc.isLoadingStream,
                builder: (context, isLoadingSnapshot) {
                  final isLoading = isLoadingSnapshot.data ?? false;

                  if (isLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container(
                      color: Color(0xffC3D7FF).withOpacity(0.1),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          MyRideTextFormField(
                            textEditingController: _getRecallsBloc.txtVin,
                            hintText: 'Enter your VIN*',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Please note this feature is available for cars with 17-digit VINs from 1981 onward; VINs for other vehicle types and some late-model cars may not be supported at this time.",
                            style: GoogleFonts.roboto(
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                          Spacer(),
                          BlueButton(
                            onPress: () {
                              _getRecallsBloc.btnSubmitClicked(
                                  context: context);
                            },
                            text: StringConstants.submit,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
