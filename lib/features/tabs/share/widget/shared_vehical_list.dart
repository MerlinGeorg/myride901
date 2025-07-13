import 'package:flutter/material.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/features/tabs/share/widget/shared_list_item.dart';

class SharedVehicleList extends StatelessWidget {
  final List<VehicleProfile>? sharedList;
  final int? selectedIndex;
  final Function(int)? onPress;
  final Function(int)? btnDeleteClicked;

  const SharedVehicleList(
      {Key? key,
      this.sharedList,
      this.selectedIndex,
      this.onPress,
      this.btnDeleteClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (_, index) {
          return Divider();
        },
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        itemCount: (sharedList ?? []).length,
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () {
              onPress?.call(index);
            },
            child: SharedItemList(
              sharedUserNames:
                  getName((sharedList ?? [])[index].displayName ?? ''),
              userPicture: Utils.getProfileImage((sharedList ?? [])[index]),
              text: (sharedList ?? [])[index].Nickname,
              isSelected: selectedIndex == index,
              btnDeleteClicked: () => btnDeleteClicked?.call(index),
            ),
          );
        });
  }

  String getName(String str) {
    String s = '';
    List<String> arr = str.split(' - ');
    if (arr.length > 0) {
      s = arr[0];
    }
    return s;
  }
}
