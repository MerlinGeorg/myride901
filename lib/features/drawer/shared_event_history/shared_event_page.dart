import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/drawer/shared_event_history/shared_event_bloc.dart';
import 'package:myride901/features/drawer/shared_event_history/widget/revoke_permission_bottom_sheet.dart';
import 'package:myride901/features/drawer/shared_event_history/widget/shared_event_list_item.dart';

class SharedEventPage extends StatefulWidget {
  @override
  _SharedEventPageState createState() => _SharedEventPageState();
}

class _SharedEventPageState extends State<SharedEventPage> {
  final _sharedEventBloc = SharedEventBloc();
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    super.initState();
    _sharedEventBloc.getSharedService(context: context);
    _sharedEventBloc.setLocalData();
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
        stream: _sharedEventBloc.mainStream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: _appTheme.primaryColor,
              elevation: 0,
              title: Text(
                StringConstants.app_shared_event,
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
                ),
              ),
            ),
            body: BlocProvider<SharedEventBloc>(
              bloc: _sharedEventBloc,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: (_sharedEventBloc.arrData.length == 0 &&
                        _sharedEventBloc.isLoaded)
                    ? Center(
                        child: Text(
                          'You have not shared any event',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Color(0xff121212).withOpacity(0.4)),
                        ),
                      )
                    : ListView.builder(
                        physics: ClampingScrollPhysics(),
                        itemCount: _sharedEventBloc.arrData.length,
                        itemBuilder: (_, index) {
                          return SharedItemListItem(
                            onRevokeClick: () {
                              Utils.showAlertDialogCallBack1(
                                context: context,
                                message:
                                    'Are you sure you want to revoke the permission?',
                                isConfirmationDialog: false,
                                isOnlyOK: false,
                                navBtnName: 'Cancel',
                                posBtnName: 'Confirm',
                                onNavClick: () {},
                                onPosClick: () {
                                  _sharedEventBloc.revokeServicePermission(
                                      context: context, index: index);
                                },
                              );
                            },
                            onEditPress: () {
                              openSheet(index);
                            },
                            vehicleService: _sharedEventBloc.arrData[index],
                          );
                        },
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  void openSheet(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return RevokePermissionBottomSheet(
          userList: _sharedEventBloc.arrData[index].servicePermissions ?? [],
          onDone: (arr, str) {
            _sharedEventBloc.arrData[index].servicePermissions = arr;
            _sharedEventBloc.updateServicePermission(
                context: context, index: index, delete_email: str);
          },
        );
      },
    );
  }
}

class SharedEventData {
  final String header;
  final List<RevokeSharedEventData> data;

  SharedEventData(this.header, this.data);
}

class RevokeSharedEventData {
  final String date;
  final String eventName;
  final bool isEditPermission;
  final List<String> sharedUser;

  RevokeSharedEventData(
      this.date, this.eventName, this.isEditPermission, this.sharedUser);
}
