import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/check_box.dart';

class TimelineListItem extends StatefulWidget {
  final String? date;
  final String? serviceName;
  final String? currency;
  final String? miles;
  final Function? onTap;
  final bool? hasCheckBox;
  final bool? isSelected;
  final String? price;
  final bool? isLast;
  final String avatar;
  final Function(bool)? onCheckBoxClick;

  const TimelineListItem(
      {Key? key,
      this.date,
      this.serviceName,
      this.currency,
      this.miles,
      this.onTap,
      this.hasCheckBox,
      this.isSelected,
      this.onCheckBoxClick,
      this.price,
      this.avatar = '1',
      this.isLast = false})
      : super(key: key);

  @override
  _ServiceListItemState createState() => _ServiceListItemState();
}

class _ServiceListItemState extends State<TimelineListItem> {
  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.isSelected ?? false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TimelineListItem oldWidget) {
    if (oldWidget.isSelected != widget.isSelected) {
      isSelected = widget.isSelected ?? false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var _appTheme = AppTheme.of(context);

    return (widget.isLast ?? false)
        ? Row(
            children: [
              SizedBox(
                width: 40,
                height: 20,
              ),
              SizedBox(
                height: 90,
                width: 60,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 29),
                        child: DottedLine(
                          direction: Axis.vertical,
                          lineLength: double.infinity,
                          lineThickness: 2.0,
                          dashLength: 4.0,
                          dashColor: Colors.grey,
                          dashRadius: 0.0,
                          dashGapLength: 4.0,
                          dashGapColor: Colors.transparent,
                          dashGapRadius: 0.0,
                        ),
                      ),
                    ),
                    Positioned(
                        left: 0,
                        right: 5,
                        bottom: 5,
                        top: 5,
                        child: CircleAvatar(
                          minRadius: 20,
                          child: SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/new/avatar_type/' +
                                    widget.avatar +
                                    '.svg',
                                // color: AppTheme.of(context).primaryColor,
                              )),
                          backgroundColor: Color(0xffE1EBFF),
                        )),
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
                    height: 90,
                    margin:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.serviceName ?? '',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: _appTheme.primaryColor),
                                  ),
                                  Spacer(),
                                  Text(
                                    ' ${widget.date}',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xffAAAAAA)),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    AssetImages.meter,
                                    width: 17,
                                    height: 17,
                                    color: Color(0xff121212).withOpacity(0.7),
                                  ),
                                  Expanded(
                                    child: Text(
                                      ' ${widget.miles}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color(0xff121212)
                                              .withOpacity(0.7)),
                                    ),
                                  ),
                                  if (widget.price != '')
                                    Text(
                                      '${widget.currency} ${widget.price}',
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Color(0xff121212)),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        : Row(
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
              SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 90,
                width: 60,
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        height: 110,
                        child: DottedLine(
                          direction: Axis.vertical,
                          lineLength: double.infinity,
                          lineThickness: 2.0,
                          dashLength: 4.0,
                          dashColor: Colors.grey,
                          dashRadius: 0.0,
                          dashGapLength: 4.0,
                          dashGapColor: Colors.transparent,
                          dashGapRadius: 0.0,
                        ),
                      ),
                    ),
                    Positioned(
                        left: 5,
                        right: 5,
                        bottom: 5,
                        top: 5,
                        child: CircleAvatar(
                          minRadius: 20,
                          child: SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/new/avatar_type/' +
                                    widget.avatar +
                                    '.svg',
                                // color: AppTheme.of(context).primaryColor,
                              )),
                          backgroundColor: Color(0xffE1EBFF),
                        )),
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
                    height: 90,
                    margin:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.serviceName ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: _appTheme.primaryColor),
                                    ),
                                  ),
                                  Text(
                                    ' ${widget.date}',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xffAAAAAA)),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    AssetImages.meter,
                                    width: 17,
                                    height: 17,
                                    color: Color(0xff121212).withOpacity(0.7),
                                  ),
                                  Expanded(
                                    child: Text(
                                      ' ${widget.miles}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color(0xff121212)
                                              .withOpacity(0.7)),
                                    ),
                                  ),
                                  if (widget.price != '')
                                    Text(
                                      '${widget.currency} ${widget.price}',
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Color(0xff121212)),
                                    )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
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

class PurchasedItem extends StatelessWidget {
  const PurchasedItem({Key? key, this.date, this.purchaseDate, this.onPress})
      : super(key: key);
  final String? date;
  final String? purchaseDate;
  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    var _appTheme = AppTheme.of(context);

    return Row(
      children: [
        SizedBox(
          width: 40,
          height: 20,
        ),
        SizedBox(
          height: 90,
          width: 60,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 50,
                  child: DottedLine(
                    direction: Axis.vertical,
                    lineLength: double.infinity,
                    lineThickness: 2.0,
                    dashLength: 4.0,
                    dashColor: Colors.grey,
                    dashRadius: 0.0,
                    dashGapLength: 4.0,
                    dashGapColor: Colors.transparent,
                    dashGapRadius: 0.0,
                  ),
                ),
              ),
              Positioned(
                  left: 5,
                  right: 5,
                  bottom: 5,
                  top: 5,
                  child: CircleAvatar(
                    minRadius: 20,
                    child: SizedBox(
                        height: 17,
                        width: 17,
                        child: SvgPicture.asset(
                          AssetImages.star,
                        )),
                    backgroundColor: _appTheme.primaryColor,
                  )),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            height: 90,
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            child: InkWell(
              onTap: () {
                onPress?.call();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (purchaseDate == '') ...[
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(AssetImages.circle_add),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              StringConstants.label_add_purchase_date,
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: _appTheme.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                  if (purchaseDate != '') ...[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  StringConstants.label_purchased_on,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: _appTheme.primaryColor),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            purchaseDate ?? '',
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: _appTheme.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Divider(
                    height: 1,
                    thickness: 1,
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

class WelcomeMyRide extends StatelessWidget {
  const WelcomeMyRide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _appTheme = AppTheme.of(context);

    return Row(
      children: [
        SizedBox(
          width: 40,
          height: 20,
        ),
        SizedBox(
          height: 90,
          width: 65,
          child: Stack(
            children: [
              SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(left: 29),
                  child: DottedLine(
                    direction: Axis.vertical,
                    lineLength: double.infinity,
                    lineThickness: 2.0,
                    dashLength: 4.0,
                    dashColor: Colors.grey,
                    dashRadius: 0.0,
                    dashGapLength: 4.0,
                    dashGapColor: Colors.transparent,
                    dashGapRadius: 0.0,
                  ),
                ),
              ),
              Positioned(
                  left: 0,
                  right: 5,
                  bottom: 5,
                  top: 5,
                  child: CircleAvatar(
                    minRadius: 23,
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Image.asset(
                        AssetImages.ride_app_logo,
                      ),
                    ),
                    backgroundColor: _appTheme.primaryColor,
                  )),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () {},
            child: Container(
                height: 90,
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                child: Align(
                  alignment: Alignment(-1, 0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Welcome to ',
                      style: GoogleFonts.roboto(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: _appTheme.primaryColor),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'MyRide901',
                          style: GoogleFonts.roboto(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        )
      ],
    );
  }
}
