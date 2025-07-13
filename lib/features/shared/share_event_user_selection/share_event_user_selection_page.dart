import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/shared/share_event_user_selection/share_event_user_selection_bloc.dart';
import 'package:myride901/features/shared/share_event_user_selection/widget/user_add_dialog.dart';
import 'package:myride901/features/shared/share_event_user_selection/widget/user_list_item.dart';

class ShareEventUserSelectionPage extends StatefulWidget {
  @override
  _ShareEventUserSelectionPage createState() => _ShareEventUserSelectionPage();
}

class _ShareEventUserSelectionPage extends State<ShareEventUserSelectionPage> {
  final _shareEventUserSelectionBloc = ShareEventUserSelectionBloc();
  AppThemeState _appTheme = AppThemeState();
  var _arguments;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _arguments =
          (ModalRoute.of(context)?.settings.arguments as ItemArgument).data;
      if (_arguments['serviceIds'] != null) {
        _shareEventUserSelectionBloc.serviceIds = _arguments['serviceIds'];
      }
      if (_arguments['vehicleProfile'] != null) {
        _shareEventUserSelectionBloc.vehicleProfile =
            _arguments['vehicleProfile'];
      }
      if (_arguments['isGuest'] != null) {
        _shareEventUserSelectionBloc.isGuest = _arguments['isGuest'];
      }
      if (_arguments['isShareVehicle'] != null) {
        _shareEventUserSelectionBloc.isShareVehicle =
            _arguments['isShareVehicle'];
      }
      _shareEventUserSelectionBloc.getUser(context: context);

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
          stream: _shareEventUserSelectionBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: _appTheme.primaryColor,
                  elevation: 0,
                  actions: [
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return UserAddDialog(
                                label: _shareEventUserSelectionBloc.isGuest == 1
                                    ? StringConstants.label_add_new_email
                                    : StringConstants
                                        .label_search_user_by_email,
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                                btnText:
                                    _shareEventUserSelectionBloc.isGuest == 1
                                        ? "ADD"
                                        : "SEARCH",
                                onAdd: (value) {
                                  print('--$value--');
                                  bool isAlready = false;
                                  _shareEventUserSelectionBloc.arrUser
                                      .forEach((element) {
                                    if (!isAlready &&
                                        element['email'].toString().trim() ==
                                            value.trim()) {
                                      isAlready = true;
                                    }
                                  });
                                  if (isAlready) {
                                    CommonToast.getInstance().displayToast(
                                        message: StringConstants
                                            .This_email_is_already_shared);
                                  } else {
                                    if (_shareEventUserSelectionBloc.isGuest ==
                                        1) {
                                      _shareEventUserSelectionBloc.arrUser.add({
                                        "email": value.trim(),
                                        "user_name": "",
                                        "is_shared": 1,
                                        "display_image": ""
                                      });
                                    } else {
                                      _shareEventUserSelectionBloc.searchUser(
                                          context: context,
                                          email: value.trim());
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                              );
                            });
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          'ADD',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                  title: Text(
                    StringConstants.app_share_event,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  leading: InkWell(
                      onTap: () {
                        _shareEventUserSelectionBloc.btnBackClicked(
                            context: context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(AssetImages.left_arrow),
                      )),
                ),
                body: BlocProvider<ShareEventUserSelectionBloc>(
                  bloc: _shareEventUserSelectionBloc,
                  child: _shareEventUserSelectionBloc.isLoading
                      ? Container()
                      : Container(
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
                                (_shareEventUserSelectionBloc.isGuest == 1)
                                    ? StringConstants
                                        .select_the_users_by_searching_or_adding_new
                                    : StringConstants
                                        .select_the_users_by_searching,
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Color(0xff121212)),
                              ),
                              if (_shareEventUserSelectionBloc
                                  .arrUser.isNotEmpty) ...[
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                    child: ListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        itemCount: _shareEventUserSelectionBloc
                                            .arrUser.length,
                                        itemBuilder: (_, index) {
                                          return UserListItem(
                                            userPicture:
                                                _shareEventUserSelectionBloc
                                                            .arrUser[index]
                                                        ['display_image'] ??
                                                    '',
                                            username:
                                                _shareEventUserSelectionBloc
                                                            .arrUser[index]
                                                        ['user_name'] ??
                                                    '',
                                            email: _shareEventUserSelectionBloc
                                                    .arrUser[index]['email'] ??
                                                '',
                                            isSelected:
                                                (_shareEventUserSelectionBloc
                                                                .arrUser[index]
                                                            ['is_shared'] ??
                                                        0) ==
                                                    1,
                                            onCheckClicked: (value) {
                                              _shareEventUserSelectionBloc
                                                          .arrUser[index]
                                                      ['is_shared'] =
                                                  (_shareEventUserSelectionBloc
                                                                      .arrUser[
                                                                  index]
                                                              ['is_shared'] ==
                                                          0
                                                      ? 1
                                                      : 0);
                                              setState(() {});
                                            },
                                          );
                                        })),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                              if (_shareEventUserSelectionBloc.arrUser.isEmpty)
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      StringConstants.no_user_found,
                                      style: GoogleFonts.roboto(
                                          color: _appTheme.primaryColor
                                              .withOpacity(0.5)),
                                    ),
                                  ),
                                ),
                              BlueButton(
                                enable: _shareEventUserSelectionBloc.arrUser
                                    .where(
                                        (element) => element['is_shared'] == 1)
                                    .isNotEmpty,
                                text: StringConstants.next,
                                onPress: () {
                                  _shareEventUserSelectionBloc.btnSubmitClicked(
                                      context: context);
                                },
                              )
                            ],
                          )),
                ));
          }),
    );
  }
}
