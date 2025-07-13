import 'package:flutter/material.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/features/tabs/share/widget/vehicle_list_item.dart';

class OwnVehicleList extends StatefulWidget {
  final List<VehicleProfile>? ownList;
  final int? selectedIndex;
  final Function(int)? onPress;

  const OwnVehicleList(
      {Key? key, this.ownList, this.selectedIndex, this.onPress})
      : super(key: key);

  @override
  _OwnVehicleListState createState() => _OwnVehicleListState();
}

class _OwnVehicleListState extends State<OwnVehicleList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (_, index) {
          return Divider();
        },
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        itemCount: (widget.ownList ?? []).length,
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () {
              widget.onPress?.call(index);
            },
            child: VehicleItemList(
              userPicture: Utils.getProfileImage(widget.ownList?[index])
                 ,
              text: widget.ownList?[index].Nickname ?? '',
              isSelected: widget.selectedIndex == index,
            ),
          );
        });
  }
}
