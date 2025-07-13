import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/features/toolkit/accident_report/share_report/report_share_option/report_share_option_bloc.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/shared/service_share_option/widget/selection_item.dart';

class ReportShareOptionPage extends StatefulWidget {
  @override
  _ReportShareOptionPageState createState() => _ReportShareOptionPageState();
}

class _ReportShareOptionPageState extends State<ReportShareOptionPage> {
  final _serviceShareOptionBloc = ReportShareOptionBloc();
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _serviceShareOptionBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: _appTheme.primaryColor,
                  elevation: 0,
                  title: Text(
                    _serviceShareOptionBloc.isShareVehicle
                        ? StringConstants.Share_Timeline
                        : StringConstants.app_share_event,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  leading: InkWell(
                      onTap: () {
                        _serviceShareOptionBloc.btnBackClicked(
                            context: context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(AssetImages.left_arrow),
                      )),
                ),
                body: BlocProvider<ReportShareOptionBloc>(
                  bloc: _serviceShareOptionBloc,
                  child: SafeArea(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Text(
                            //   StringConstants.select_any_one_option_to_share_you,
                            //   style: GoogleFonts.roboto(
                            //       fontWeight: FontWeight.w400,
                            //       fontSize: 16,
                            //       color: Color(0xff121212)),
                            // ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _serviceShareOptionBloc.isGuest = 1;
                                    _serviceShareOptionBloc.btnSubmitClicked(
                                        context: context);
                                  },
                                  child: SelectionItem(
                                    isSelected: false,
                                    text: 'Guest - No MyRide901 Account',
                                    icon: AssetImages.email_selection,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                InkWell(
                                  onTap: () {
                                    _serviceShareOptionBloc.isGuest = 0;
                                    _serviceShareOptionBloc.btnSubmitClicked(
                                        context: context);
                                  },
                                  child: SelectionItem(
                                    isSelected: false,
                                    text: StringConstants.myRide901_users,
                                    icon: AssetImages.car_repair_selection,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ));
          }),
    );
  }
}
