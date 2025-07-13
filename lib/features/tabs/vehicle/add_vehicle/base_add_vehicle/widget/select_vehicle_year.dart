import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/shared/share_event_user_selection/widget/search_box.dart';

class SelectVehicleYear extends StatefulWidget {
  const SelectVehicleYear(
      {Key? key,
      this.onVehicleTypeSelect,
      this.arrData,
      this.txtSearch,
      this.onChanged})
      : super(key: key);
  final Function(String)? onVehicleTypeSelect;
  final List<String>? arrData;
  final TextEditingController? txtSearch;
  final Function(String)? onChanged;
  @override
  _SelectVehicleYearState createState() => _SelectVehicleYearState();
}

class _SelectVehicleYearState extends State<SelectVehicleYear>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
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
                textInputType: TextInputType.number,
                onSubmitted: (str) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              )),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: (widget.arrData ?? []).length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio:
                      ((MediaQuery.of(context).size.width - 80) / 3) / 50,
                ),
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      widget.onVehicleTypeSelect
                          ?.call((widget.arrData ?? [])[index]);
                    },
                    child: SelectionItem(
                      isSelected: false,
                      text: '${(widget.arrData ?? [])[index]}',
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SelectionItem extends StatelessWidget {
  final bool? isSelected;
  final String? text;

  const SelectionItem({Key? key, this.isSelected, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: (isSelected ?? false)
                    ? AppTheme.of(context).primaryColor
                    : Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: (isSelected ?? false)
                      ? Color(0xffC3D7FF)
                      : Colors.transparent,
                  blurRadius: 5.0,
                  spreadRadius: 0.1,
                  offset: Offset(2, 5)),
            ]),
        child: Center(
          child: Text(
            text ?? '',
            style: GoogleFonts.roboto(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ));
  }
}
