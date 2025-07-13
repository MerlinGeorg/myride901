import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/check_box.dart';

class ServiceListItem extends StatefulWidget {
  final String? date;
  final String? serviceName;
  final String? miles;
  final bool? isLast;
  final Function? onTap;
  final bool? hasCheckBox;
  final bool? isSelected;
  final Function(bool)? onCheckBoxClick;

  const ServiceListItem(
      {Key? key,
      this.date,
      this.serviceName,
      this.miles,
      this.isLast,
      this.onTap,
      this.hasCheckBox,
      this.isSelected,
      this.onCheckBoxClick})
      : super(key: key);

  @override
  _ServiceListItemState createState() => _ServiceListItemState();
}

class _ServiceListItemState extends State<ServiceListItem> {
  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.isSelected ?? false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ServiceListItem oldWidget) {
    if (oldWidget.isSelected != widget.isSelected) {
      isSelected = widget.isSelected ?? false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var _appTheme = AppTheme.of(context);

    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 20,
          height: 20,
          child: Visibility(
            visible: widget.hasCheckBox ?? false,
            child: MyRideCheckBox(
              onCheckClick: (value) {
                setState(() {
                  isSelected = !isSelected;
                  widget.onCheckBoxClick?.call(isSelected);
                });
              },
              isChecked: isSelected,
              size: Size(20, 20),
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Text(
              widget.date ?? '',
              textAlign: TextAlign.end,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xffAAAAAA)),
            )),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          height: 110,
          width: 30,
          child: Stack(
            children: [
              if (widget.isLast ?? false)
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: DottedLine(
                      direction: Axis.vertical,
                      lineLength: double.infinity,
                      lineThickness: 1.0,
                      dashLength: 4.0,
                      dashColor: Color(0xffE5E5E5),
                      dashRadius: 0.0,
                      dashGapLength: 4.0,
                      dashGapColor: Colors.transparent,
                      dashGapRadius: 0.0,
                    ),
                  ),
                ),
              if (!(widget.isLast ?? false))
                Center(
                  child: SizedBox(
                    height: 110,
                    child: DottedLine(
                      direction: Axis.vertical,
                      lineLength: double.infinity,
                      lineThickness: 1.0,
                      dashLength: 4.0,
                      dashColor: Color(0xffE5E5E5),
                      dashRadius: 0.0,
                      dashGapLength: 4.0,
                      dashGapColor: Colors.transparent,
                      dashGapRadius: 0.0,
                    ),
                  ),
                ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                top: 10,
                child: SvgPicture.asset(
                  AssetImages.ellipse_red,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () {
              widget.onTap?.call();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.serviceName ?? '',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: _appTheme.primaryColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    ' ${widget.miles}',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xff121212)),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
