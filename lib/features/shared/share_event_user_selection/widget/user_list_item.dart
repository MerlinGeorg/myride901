import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/widgets/check_box.dart';
import 'package:myride901/widgets/user_picture.dart';

class UserListItem extends StatelessWidget {
  final String? username;
  final String? email;
  final String? userPicture;
  final Function(bool)? onCheckClicked;

//  final String email;
  final bool? isSelected;

  const UserListItem(
      {Key? key,
      this.username,
      this.userPicture,
      this.isSelected,
      this.onCheckClicked,this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(username == '')
      {
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
                width: 20,
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

              MyRideCheckBox(
                onCheckClick: (value) {onCheckClicked?.call(value);},
                isChecked: isSelected,
                size: Size(25, 25),
              )
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
              text: username!.length > 0
                  ? username!.substring(0, 1).toUpperCase()
                  : username!.toUpperCase()),
          SizedBox(
            width: 20,
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

            MyRideCheckBox(
              onCheckClick: (value) {onCheckClicked?.call(value);},
              isChecked: isSelected,
              size: Size(25, 25),
            )
        ],
      ),
    );
  }
}
