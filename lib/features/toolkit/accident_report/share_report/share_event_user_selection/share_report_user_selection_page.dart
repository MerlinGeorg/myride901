import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/features/toolkit/accident_report/share_report/share_event_user_selection/share_report_user_selection_bloc.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/shared/share_event_user_selection/widget/user_add_dialog.dart';
import 'package:myride901/features/shared/share_event_user_selection/widget/user_list_item.dart';

class ShareReportUserSelectionPage extends StatefulWidget {
  @override
  _ShareReportUserSelectionPage createState() =>
      _ShareReportUserSelectionPage();
}

class _ShareReportUserSelectionPage
    extends State<ShareReportUserSelectionPage> {
  final _ShareReportUserSelectionBloc = ShareReportUserSelectionBloc();
  AppThemeState _appTheme = AppThemeState();
  var _arguments;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _arguments =
          (ModalRoute.of(context)?.settings.arguments as ItemArgument).data;

      if (_arguments['isGuest'] != null) {
        _ShareReportUserSelectionBloc.isGuest = _arguments['isGuest'];
      }
      _ShareReportUserSelectionBloc.getContactList(context: context);

      _ShareReportUserSelectionBloc.user =
          AppComponentBase.getInstance().getLoginData().user;

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
          stream: _ShareReportUserSelectionBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: _appTheme.primaryColor,
                  elevation: 0,
                  actions: [buttonAdd()],
                  title: Text(
                    StringConstants.app_share_accident_report,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  leading: InkWell(
                      onTap: () {
                        _ShareReportUserSelectionBloc.btnBackClicked(
                            context: context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(AssetImages.left_arrow),
                      )),
                ),
                body: BlocProvider<ShareReportUserSelectionBloc>(
                  bloc: _ShareReportUserSelectionBloc,
                  child: _ShareReportUserSelectionBloc.isLoading
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                (_ShareReportUserSelectionBloc.isGuest == 1)
                                    ? StringConstants.add_email_address
                                    : StringConstants
                                        .select_the_users_by_searching,
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Color(0xff121212)),
                              ),
                              if (_ShareReportUserSelectionBloc
                                  .arrUser.isNotEmpty) ...[
                                SizedBox(height: 10),
                                userList(),
                                SizedBox(height: 10),
                              ],
                              if (_ShareReportUserSelectionBloc.arrUser.isEmpty)
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
                                enable: _ShareReportUserSelectionBloc.arrUser
                                    .where(
                                        (element) => element['is_shared'] == 1)
                                    .isNotEmpty,
                                text: StringConstants.share,
                                onPress: () {
                                  _ShareReportUserSelectionBloc
                                      .btnSubmitClicked(context: context);
                                },
                              )
                            ],
                          )),
                ));
          }),
    );
  }

  userList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: _ShareReportUserSelectionBloc.arrUser.length,
        itemBuilder: (_, index) {
          return UserListItem(
            userPicture: _ShareReportUserSelectionBloc.arrUser[index]
                    ['display_image'] ??
                '',
            username:
                _ShareReportUserSelectionBloc.arrUser[index]['user_name'] ?? '',
            email: _ShareReportUserSelectionBloc.arrUser[index]['email'] ?? '',
            isSelected: (_ShareReportUserSelectionBloc.arrUser[index]
                        ['is_shared'] ??
                    0) ==
                1,
            onCheckClicked: (value) {
              _ShareReportUserSelectionBloc.arrUser[index]['is_shared'] =
                  (_ShareReportUserSelectionBloc.arrUser[index]['is_shared'] ==
                          0
                      ? 1
                      : 0);
              setState(() {});
            },
          );
        },
      ),
    );
  }

  buttonAdd() {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return UserAddDialog(
                label: _ShareReportUserSelectionBloc.isGuest == 1
                    ? StringConstants.label_add_new_email
                    : StringConstants.label_search_user_by_email,
                onCancel: () {
                  Navigator.pop(context);
                },
                btnText: _ShareReportUserSelectionBloc.isGuest == 1
                    ? "ADD"
                    : "SEARCH",
                onAdd: (value) {
                  print('--$value--');
                  bool isAlready = false;
                  _ShareReportUserSelectionBloc.arrUser.forEach((element) {
                    if (!isAlready &&
                        element['email'].toString().trim() == value.trim()) {
                      isAlready = true;
                    }
                  });
                  if (isAlready) {
                    CommonToast.getInstance().displayToast(
                        message: StringConstants.This_email_is_already_shared);
                  } else {
                    if (_ShareReportUserSelectionBloc.isGuest == 1) {
                      _ShareReportUserSelectionBloc.arrUser.add({
                        "email": value.trim(),
                        "user_name": "",
                        "is_shared": 1,
                        "display_image": ""
                      });
                    } else {
                      _ShareReportUserSelectionBloc.searchUser(
                          context: context, email: value.trim());
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
    );
  }
}
