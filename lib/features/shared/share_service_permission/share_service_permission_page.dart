import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/shared/share_event_user_selection/widget/user_list_item.dart';
import 'package:myride901/features/shared/share_service_permission/share_service_permission_bloc.dart';

class ShareServicePermissionPage extends StatefulWidget {
  @override
  _ShareServicePermissionPageState createState() =>
      _ShareServicePermissionPageState();
}

class _ShareServicePermissionPageState
    extends State<ShareServicePermissionPage> {
  final _shareServicePermissionBloc = ShareServicePermissionBloc();
  AppThemeState _appTheme = AppThemeState();
  var _arguments;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _arguments =
          (ModalRoute.of(context)?.settings.arguments as ItemArgument).data;
      if (_arguments['serviceIds'] != null) {
        _shareServicePermissionBloc.serviceIds = _arguments['serviceIds'];
      }
      if (_arguments['vehicleProfile'] != null) {
        _shareServicePermissionBloc.vehicleProfile =
            _arguments['vehicleProfile'];
      }
      if (_arguments['isShareVehicle'] != null) {
        _shareServicePermissionBloc.isShareVehicle =
            _arguments['isShareVehicle'];
      }
      if (_arguments['isGuest'] != null) {
        _shareServicePermissionBloc.isGuest = _arguments['isGuest'];
      }
      if (_arguments['arrUser'] != null) {
        _shareServicePermissionBloc.arrUser = _arguments['arrUser'];
      }

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
          stream: _shareServicePermissionBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: _appTheme.primaryColor,
                  elevation: 0,
                  title: Text(
                    StringConstants.app_share_event,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  leading: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(AssetImages.left_arrow),
                      )),
                ),
                body: BlocProvider<ShareServicePermissionBloc>(
                  bloc: _shareServicePermissionBloc,
                  child: SafeArea(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              StringConstants.check_the_box_to_allow_user,
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Color(0xff121212)),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    StringConstants.user,
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1,
                                        color:
                                            Color(0xff121212).withOpacity(0.5)),
                                  ),
                                ),
                                Text(
                                  StringConstants.edit,
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1,
                                      color:
                                          Color(0xff121212).withOpacity(0.5)),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(
                                    right: 10, top: 10, bottom: 10),
                                itemBuilder: (_, index) {
                                  return UserListItem(
                                    userPicture: _shareServicePermissionBloc
                                            .arrUser[index]['display_image'] ??
                                        '',
                                    username: _shareServicePermissionBloc
                                            .arrUser[index]['user_name'] ??
                                        '',
                                    email: _shareServicePermissionBloc
                                            .arrUser[index]['email'] ??
                                        '',
                                    isSelected: (_shareServicePermissionBloc
                                                .arrUser[index]['is_edit'] ??
                                            0) ==
                                        1,
                                    onCheckClicked: (value) {
                                      _shareServicePermissionBloc.arrUser[index]
                                              ['is_edit'] =
                                          ((_shareServicePermissionBloc
                                                              .arrUser[index]
                                                          ['is_edit'] ==
                                                      null ||
                                                  _shareServicePermissionBloc
                                                              .arrUser[index]
                                                          ['is_edit'] ==
                                                      0)
                                              ? 1
                                              : 0);
                                      setState(() {});
                                    },
                                  );
                                },
                                itemCount:
                                    _shareServicePermissionBloc.arrUser.length,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            BlueButton(
                              text: 'SHARE',
                              onPress: () {
                                _shareServicePermissionBloc.btnSubmitClicked(
                                    context: context);
                              },
                            ),
                          ],
                        )),
                  ),
                ));
          }),
    );
  }
}
