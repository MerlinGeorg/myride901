import 'package:flutter/material.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/car_name_list_item.dart';
import 'package:myride901/features/shared/share_event_user_selection/widget/search_box.dart';

class SelectVehicleMode extends StatefulWidget {
  const SelectVehicleMode(
      {Key? key,
      this.onVehicleName,
      this.arrData,
      this.txtSearch,
      this.onChanged})
      : super(key: key);
  final Function(String)? onVehicleName;
  final List<String>? arrData;

  final TextEditingController? txtSearch;
  final Function(String)? onChanged;
  @override
  _SelectVehicleModeState createState() => _SelectVehicleModeState();
}

class _SelectVehicleModeState extends State<SelectVehicleMode>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          SizedBox(
              height: 40,
              child: SearchBox(
                onChanged: widget.onChanged,
                textEditingController: widget.txtSearch,
                onSubmitted: (str) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              )),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, index) {
                return Divider();
              },
              padding: const EdgeInsets.symmetric(vertical: 0),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    widget.onVehicleName?.call((widget.arrData ?? [])[index]);
                  },
                  child: CarNameListItem(
                    name: widget.arrData?[index],
                  ),
                );
              },
              itemCount: (widget.arrData ?? []).length,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
