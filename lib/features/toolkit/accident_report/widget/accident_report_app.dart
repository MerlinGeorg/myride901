import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';

class AccidentReportAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final Future<void> Function()? onPress;
  const AccidentReportAppBar({Key? key, this.onPress}) : super(key: key);

  @override
  _AccidentReportAppBarState createState() => _AccidentReportAppBarState();

  @override
  Size get preferredSize => Size(double.infinity, 50);
}

class _AccidentReportAppBarState extends State<AccidentReportAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppTheme.of(context).primaryColor,
      leadingWidth: 200,
      centerTitle: true,
      titleSpacing: 0,
      leading: Row(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(AssetImages.avatar_1),
        ),
        // Text('Go back to dashboard'),
        InkWell(
          child: Text(
            StringConstants.accidentReport_button_reset,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Color(0xffD03737)),
          ),
          onTap: () {
            Utils.showAlertDialogCallBack1(
              context: context,
              message: StringConstants.accidentReport_popup_reset,
              isConfirmationDialog: false,
              isOnlyOK: false,
              navBtnName: StringConstants.cancel,
              posBtnName:
                  StringConstants.accidentReport_button_reset.toUpperCase(),
              onNavClick: () => {},
              onPosClick: () async {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(RouteName.accidentReport));
                AppComponentBase.getInstance()
                    .getSharedPreference()
                    .clearAccidentReport();
                print(
                    "+++++++++++++ sharedPreferences clear in _AccidentReportAppBarState");
              },
            );
          },
        ),
      ]),
      title: InkWell(
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            StringConstants.accidentReport_button_save,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Color(0xffD03737)),
          ),
        ),
        onTap: () async {
          if (widget.onPress != null) {
            await widget.onPress!();
          }
          CommonToast.getInstance()
              .displayToast(message: 'Previous steps saved.');
          Navigator.of(context)
              .popUntil(ModalRoute.withName(RouteName.dashboard));
          // display toast saved
        },
      ),
      actions: [
        SizedBox(width: 20),
        InkWell(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                StringConstants.cancelSmall,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Color(0xffD03737)),
              ),
            ),
          ),
          onTap: () {
            Utils.showAlertDialogCallBack1(
              context: context,
              message: StringConstants.accidentReport_popup_leave_message,
              isConfirmationDialog: false,
              isOnlyOK: false,
              navBtnName: StringConstants.return_label.toUpperCase(),
              posBtnName: StringConstants.label_continue.toUpperCase(),
              onNavClick: () => {},
              onPosClick: () {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(RouteName.dashboard));
              },
            );
          },
        )
      ],
    );
  }
}
