import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/drawer/shared_event_history/widget/revoke_permission_list_item.dart';

class VehiclePermissionBottomSheet extends StatefulWidget {
  final List<String>? userList;
  final List<String>? editList;
  final Function(List<String>, List<String>, String)? onDone;
  const VehiclePermissionBottomSheet(
      {Key? key, this.userList, this.editList, this.onDone})
      : super(key: key);
  @override
  _VehiclePermissionBottomSheetState createState() =>
      _VehiclePermissionBottomSheetState();
}

class _VehiclePermissionBottomSheetState
    extends State<VehiclePermissionBottomSheet> {
  List<String> arr = [];
  List<String> arrIsEdit = [];
  String deletedId = '';
  @override
  void initState() {
    super.initState();
    arr = [...widget.userList ?? []];
    arrIsEdit = [...widget.editList ?? []];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            SvgPicture.asset(AssetImages.rounderLine),
            SizedBox(height: 20),
            Text(
              StringConstants.vehiclePermissionBottomSheetTitle,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xff121212)),
            ),
            SizedBox(height: 40),
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
                        color: Color(0xff121212).withOpacity(0.5)),
                  ),
                ),
                Text(
                  StringConstants.edit,
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                      color: Color(0xff121212).withOpacity(0.5)),
                ),
                SizedBox(width: 20),
                Text(
                  StringConstants.delete,
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                      color: Color(0xff121212).withOpacity(0.5)),
                )
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                itemBuilder: (_, index) {
                  return RevokePermissionListItem(
                    userPicture: '',
                    email: arr[index],
                    username: '',
                    isSelected: arrIsEdit[index] == '1',
                    onDeleteClick: () {
                      deletedId = deletedId + arr[index].toString() + ',';
                      arr.removeAt(index);
                      arrIsEdit.removeAt(index);
                      setState(() {});
                    },
                    onCheckClick: () {
                      arrIsEdit[index] = (arrIsEdit[index] == '1') ? '0' : '1';
                      setState(() {});
                    },
                  );
                },
                itemCount: arr.length,
              ),
            ),
            SizedBox(height: 10),
            BlueButton(
              text: StringConstants.done,
              onPress: () {
                Utils.showAlertDialogCallBack1(
                  context: context,
                  message:
                      'All timeline permission for these users will be overwrited by your selection, please verify before submit',
                  isConfirmationDialog: false,
                  isOnlyOK: false,
                  navBtnName: 'Cancel',
                  posBtnName: 'Confirm',
                  onNavClick: () {},
                  onPosClick: () {
                    widget.onDone!(arr, arrIsEdit, deletedId);
                    Navigator.pop(context);
                  },
                );
              },
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
