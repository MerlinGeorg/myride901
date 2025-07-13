import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/service_chat/service_chat.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/my_ride_textform_field.dart';
import 'package:myride901/widgets/user_picture.dart';

class CommentTabView extends StatefulWidget {
  final List<ServiceChat>? comments;
  final TextEditingController? txtComment;
  final Function? onSuffixIconClick;
  final Function? onLoad;
  final Function? onDelete;
  final ScrollController? chatScrollController;
  final VehicleProfile? vehicleProfile;

  const CommentTabView(
      {Key? key,
      this.comments,
      this.txtComment,
      this.onSuffixIconClick,
      this.onLoad,
      this.chatScrollController,
      this.vehicleProfile,
      this.onDelete})
      : super(key: key);

  @override
  _CommentTabViewState createState() => _CommentTabViewState();
}

class _CommentTabViewState extends State<CommentTabView> {
  @override
  Widget build(BuildContext context) {
    AppThemeState appTheme = AppTheme.of(context);
    return Column(
      children: [
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                widget.onLoad?.call();
              }
              return true;
            },
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                controller: widget.chatScrollController,
                reverse: true,
                child: Column(
                  children: mapIndexed(
                    widget.comments!.reversed,
                    (index, item) => Container(
                      margin: (((item as ServiceChat).userEmail ?? '') == 'Me')
                          ? EdgeInsets.only(
                              left: 40.0, right: 5.0, bottom: 5.0, top: 5.0)
                          : EdgeInsets.only(
                              left: 5.0, right: 40.0, bottom: 5.0, top: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            ((((item as ServiceChat).userEmail ?? '') == 'Me')
                                ? Colors.blue[50]
                                : Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            (((item as ServiceChat).userEmail ?? '') == 'Me')
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          (((item as ServiceChat).userEmail ?? '') == 'Me')
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        item.userEmail ?? '',
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: AppTheme.of(context)
                                                .primaryColor),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      UserPicture(
                                        userPicture: '',
                                        text: (item as ServiceChat).userEmail ??
                                            '',
                                        size: Size(30, 30),
                                      ),
                                      if (widget.vehicleProfile?.isMyVehicle ==
                                          1)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: InkWell(
                                              onTap: () {
                                                Utils.showAlertDialogCallBack1(
                                                    context: context,
                                                    message:
                                                        'You are about to delete chat. Please click Cancel or Confirm, below.',
                                                    isConfirmationDialog: false,
                                                    isOnlyOK: false,
                                                    navBtnName: 'Cancel',
                                                    posBtnName: 'Confirm',
                                                    onNavClick: () {},
                                                    onPosClick: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                      widget.onDelete
                                                          ?.call(index);
                                                    });
                                              },
                                              child: SvgPicture.asset(
                                                  AssetImages.delete_bg)),
                                        )
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      UserPicture(
                                        userPicture: '',
                                        text: (item as ServiceChat).userEmail ??
                                            '',
                                        size: Size(30, 30),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          item.userEmail ?? '',
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: AppTheme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                      if (widget.vehicleProfile?.isMyVehicle ==
                                          1)
                                        InkWell(
                                            onTap: () {
                                              Utils.showAlertDialogCallBack1(
                                                  context: context,
                                                  message:
                                                      'You are about to delete chat. Please click Cancel or Confirm, below.',
                                                  isConfirmationDialog: false,
                                                  isOnlyOK: false,
                                                  navBtnName: 'Cancel',
                                                  posBtnName: 'Confirm',
                                                  onNavClick: () {},
                                                  onPosClick: () {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                    widget.onDelete
                                                        ?.call(index);
                                                  });
                                            },
                                            child: SvgPicture.asset(
                                                AssetImages.delete_bg))
                                    ],
                                  ),
                                ),
                          ((item.userEmail ?? '') == 'Me')
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 0, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        item.message ?? '',
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Color(0xff121212)),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        DateFormat(
                                                (AppComponentBase.getInstance()
                                                            .getLoginData()
                                                            .user
                                                            ?.date_format ??
                                                        'yyyy-MM-dd') +
                                                    " HH:mm")
                                            .format(DateFormat((AppComponentBase
                                                                .getInstance()
                                                            .getLoginData()
                                                            .user
                                                            ?.date_format ??
                                                        'yyyy-MM-dd') +
                                                    " HH:mm")
                                                .parse(
                                                    item.createdAt ?? '', true)
                                                .toLocal())
                                            .toString(),
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Color(0xff121212)
                                                .withOpacity(0.4)),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 0, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.message ?? '',
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Color(0xff121212)),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        DateFormat(
                                                (AppComponentBase.getInstance()
                                                            .getLoginData()
                                                            .user
                                                            ?.date_format ??
                                                        'yyyy-MM-dd') +
                                                    " HH:mm")
                                            .format(DateFormat((AppComponentBase
                                                                .getInstance()
                                                            .getLoginData()
                                                            .user
                                                            ?.date_format ??
                                                        'yyyy-MM-dd') +
                                                    " HH:mm")
                                                .parse(
                                                    item.createdAt ?? '', true)
                                                .toLocal())
                                            .toString(),
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Color(0xff121212)
                                                .withOpacity(0.4)),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ),
          ),
        ),
        ListView(
          reverse: true,
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MyRideTextFormField(
                textEditingController: widget.txtComment,
                isLabel: false,
                onSuffixIconClick: widget.onSuffixIconClick,
                textInputAction: TextInputAction.done,
                hintText: 'Type message here',
                hasSuffixIcon: true,
                maxText: 300,
                onChanged: (str) {
                  // setState(() {});
                },
                suffixIcon: SvgPicture.asset(
                  AssetImages.send,
                  width: 20,
                  height: 20,
                  color: widget.txtComment?.text.trim() == ''
                      ? Colors.grey
                      : appTheme.primaryColor,
                ),
              ),
            ),
          ].reversed.toList(),
        )
      ],
    );
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }
}
