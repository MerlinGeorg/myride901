import 'package:flutter/material.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/car_name_list_item.dart';
import 'package:myride901/widgets/azlistview/azlistview.dart';
import 'package:myride901/features/shared/share_event_user_selection/widget/search_box.dart';

class SelectVehicleMake extends StatefulWidget {
  final Function(String)? onVehicleSelect;
  final List<VehicleName>? arrData;

  final TextEditingController? txtSearch;
  final Function(String)? onChanged;
  const SelectVehicleMake(
      {Key? key,
      this.onVehicleSelect,
      this.arrData,
      this.txtSearch,
      this.onChanged})
      : super(key: key);

  @override
  _SelectVehicleMakeState createState() => _SelectVehicleMakeState();
}

class _SelectVehicleMakeState extends State<SelectVehicleMake>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    SuspensionUtil.setShowSuspensionStatus(widget.arrData ?? []);
    _handleList(widget.arrData ?? []);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          if ((widget.arrData ?? []).length != 0)
            Expanded(
              child: AzListView(
                itemCount: (widget.arrData ?? []).length,
                data: widget.arrData ?? [],
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: InkWell(
                      onTap: () {
                        widget.onVehicleSelect
                            ?.call((widget.arrData ?? [])[index].name);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          CarNameListItem(
                            hasRightIcon: false,
                            name: (widget.arrData ?? [])[index].name,
                          ),
                          Divider()
                        ],
                      ),
                    ),
                  );
                },
                // susItemBuilder: (BuildContext context, int index) {
                //   return Align(
                //     alignment: Alignment.centerLeft,
                //     child: Container(
                //       color: Colors.white,
                //       width: MediaQuery.of(context).size.width - 20,
                //       padding: const EdgeInsets.only(top: 20, bottom: 10),
                //       child: Text(
                //         widget.arrData[index].tagIndex,
                //         style: GoogleFonts.roboto(
                //             backgroundColor: Colors.white,
                //             color: Color(0xffD03737),
                //             fontSize: 15,
                //             fontWeight: FontWeight.w700),
                //       ),
                //     ),
                //   );
                // },
              ),
            ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void _handleList(List<VehicleName> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String tag = list[i].name.substring(0, 1).toUpperCase();
      //list[i].namePinyin = pinyin;
      if (RegExp('[A-Z]').hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = '#';
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(list);

    // add hotCityList.
    // widget.arrData.insertAll(0, _hotCityList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(widget.arrData);

    setState(() {});
  }
}

class VehicleName extends ISuspensionBean {
  String name;
  String tagIndex;

  VehicleName(this.name, this.tagIndex);

  @override
  String getSuspensionTag() {
    // TODO: implement getSuspensionTag
    return tagIndex;
  }
}
