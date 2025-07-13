import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/widgets/check_box.dart';
import 'package:myride901/widgets/user_picture.dart';

class RevokePermissionListItem extends StatelessWidget {
  final String? email;
  final String? username;
  final String? userPicture;
  final bool? isSelected;
  final Function()? onDeleteClick;
  final Function()? onCheckClick;

  const RevokePermissionListItem(
      {Key? key,
      this.email,this.username,
      this.userPicture,
      this.isSelected,
      this.onDeleteClick,this.onCheckClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(username == '') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            UserPicture(
                userPicture: userPicture ?? '',
                fontSize: 15,
                size: Size(40, 40),
                text: email!.length > 0
                    ? email!.substring(0, 1).toUpperCase()
                    : email!.toUpperCase()),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                email ?? '',
                maxLines: 1,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xff121212)),
              ),
            ),
            SizedBox(width: 5,),
            MyRideCheckBox(
              isChecked: isSelected,
              size: Size(25, 25),
              onCheckClick: (value) {
                onCheckClick!.call();
              },
            ),
            SizedBox(
              width: 40,
            ),
            InkWell(onTap: (){
              onDeleteClick!.call();
            },child: SvgPicture.asset(AssetImages.delete_bg)),
            SizedBox(width: 5,)
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          UserPicture(
              userPicture: userPicture ?? '',
              fontSize: 15,
              size: Size(40, 40),
              text: email!.length > 0
                  ? email!.substring(0, 1).toUpperCase()
                  : email!.toUpperCase()),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username ?? '',
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xff121212)),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  email ?? '',
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 9,
                      color: Color(0xff121212).withOpacity(0.5)),
                ),
              ],
            ),
          ),

          SizedBox(width: 5,),
          MyRideCheckBox(
            isChecked: isSelected,
            size: Size(25, 25),
            onCheckClick: (value) {
              onCheckClick!.call();
            },
          ),
          SizedBox(
            width: 40,
          ),
          InkWell(onTap: (){
            onDeleteClick!.call();
          },child: SvgPicture.asset(AssetImages.delete_bg)),
          SizedBox(width: 5,)
        ],
      ),
    );
  }
}
