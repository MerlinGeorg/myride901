import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectVehicleType extends StatefulWidget {
  const SelectVehicleType({Key? key, this.onVehicleTypeSelect, this.arrData})
      : super(key: key);
  final Function(String)? onVehicleTypeSelect;
  final List<Map<String, dynamic>>? arrData;
  @override
  _SelectVehicleTypeState createState() => _SelectVehicleTypeState();
}

class _SelectVehicleTypeState extends State<SelectVehicleType>
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
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: (widget.arrData ?? []).length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                if ((widget.arrData ?? [])[index]['value'] != 'moto') {
                  widget.onVehicleTypeSelect
                      ?.call((widget.arrData ?? [])[index]['value']);
                }
              },
              child: SelectionItem(
                data: (widget.arrData ?? [])[index],
              ),
            );
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SelectionItem extends StatelessWidget {
  final Map<String, dynamic>? data;

  const SelectionItem({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data?['value'] == 'moto') {
      return SizedBox.shrink();
    }
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 5.0,
                  spreadRadius: 0.1,
                  offset: Offset(2, 5)),
            ]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Image.asset(
                  data?['img'],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                data?['title'] ?? '',
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
            ],
          ),
        ));
  }
}
