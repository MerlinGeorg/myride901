import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/flavor_config.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';

class VehicleDetailTabView extends StatefulWidget {
  final List<VehicleDetailData>? list;
  final TextEditingController? vinTextEditController;
  final TextEditingController? nameTextEditController;
  final TextEditingController? priceTextEditController;
  final TextEditingController? purchaseTextEditController;
  final TextEditingController? purchaseMileageTextEditController;
  final TextEditingController? currentMileageTextEditController;
  final TextEditingController? purchaseDateTextEditController;
  final TextEditingController? currentDateTextEditController;
  final TextEditingController? currencyTextEditController;
  final bool isEditable;
  final Function? btnSaveClicked;
  final Function? btnEditClicked;
  final Function? btnCDateClicked;
  final Function? btnPDateClicked;
  final Function? btnShareClicked;
  final Function? btnCopyClicked;
  final Function? btnDeleteClicked;
  final String mileUnit;
  final Function(String)? onMileTypePress;

  const VehicleDetailTabView(
      {Key? key,
      this.list,
      this.vinTextEditController,
      this.nameTextEditController,
      this.priceTextEditController,
      this.purchaseTextEditController,
      this.purchaseMileageTextEditController,
      this.currentMileageTextEditController,
      this.currentDateTextEditController,
      this.purchaseDateTextEditController,
      this.currencyTextEditController,
      this.isEditable = false,
      this.btnSaveClicked,
      this.btnShareClicked,
      this.btnCopyClicked,
      this.btnCDateClicked,
      this.btnEditClicked,
      this.btnPDateClicked,
      this.mileUnit = '',
      this.onMileTypePress,
      this.btnDeleteClicked})
      : super(key: key);

  @override
  _VehicleDetailTabViewState createState() => _VehicleDetailTabViewState();
}

class _VehicleDetailTabViewState extends State<VehicleDetailTabView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffC3D7FF).withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        '',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            letterSpacing: 0.5,
                            color: AppTheme.of(context).primaryColor),
                      ),
                    ),
                    downloadButton(),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        widget.btnShareClicked?.call();
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: AppTheme.of(context)
                                .primaryColor
                                .withOpacity(0.2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.send,
                          color: AppTheme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    if (!widget.isEditable)
                      InkWell(
                        onTap: () {
                          widget.btnEditClicked?.call();
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              color: AppTheme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            AssetImages.edit_b,
                            width: 13,
                            height: 1,
                            color: AppTheme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        widget.btnDeleteClicked?.call();
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.all(6),
                        child: SvgPicture.asset(
                          AssetImages.delete,
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 20),
              VerticalStrip(
                title: 'Nickname',
                textEditingController: widget.nameTextEditController!,
                isEditable: widget.isEditable,
                textCapitalization: TextCapitalization.sentences,
                isPrefix: false,
                prefillIcon: AssetImages.user_bold,
                value: widget.nameTextEditController!.text,
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),
              VerticalStrip(
                title: 'VIN',
                textEditingController: widget.vinTextEditController!,
                isEditable: widget.isEditable,
                textCapitalization: TextCapitalization.sentences,
                isPrefix: false,
                prefillIcon: AssetImages.user_bold,
                value: widget.vinTextEditController!.text,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              VerticalStrip(
                title: 'Vehicle Purchase Price',
                textEditingController: widget.purchaseTextEditController!,
                isEditable: widget.isEditable,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                isPrefix: true,
                prefixText: widget.currencyTextEditController!.text,
                prefillIcon: AssetImages.car,
                value: widget.purchaseTextEditController!.text,
              ),
              SizedBox(height: 20),
              VerticalStrip(
                title: 'Vehicle Cost Summary',
                textEditingController: widget.priceTextEditController!,
                isEditable: false,
                isPrefix: true,
                prefixText: widget.currencyTextEditController!.text,
                prefillIcon: AssetImages.dollar,
                value: widget.priceTextEditController!.text,
              ),
              SizedBox(height: 20),
              GridItem(
                vehicleDetailData1: widget.list![0],
                vehicleDetailData2: widget.list![1],
                isEdit: !widget.isEditable,
              ),
              SizedBox(height: 20),
              GridItem(
                vehicleDetailData1: widget.list![2],
                vehicleDetailData2: widget.list![3],
                isEdit: !widget.isEditable,
              ),
              SizedBox(height: 20),
              GridItem(
                vehicleDetailData1: widget.list![4],
                vehicleDetailData2: widget.list![5],
                isEdit: !widget.isEditable,
              ),
              SizedBox(height: 20),
              PurchaseDetail(
                isEditable: widget.isEditable,
                purchaseMileageTextEditController:
                    widget.purchaseMileageTextEditController!,
                purchaseDateTextEditController:
                    widget.purchaseDateTextEditController!,
                btnPDateClicked: widget.btnPDateClicked!,
                mileUnit: widget.mileUnit == 'mile' ? 'mi' : 'km',
              ),
              SizedBox(height: 20),
              CurrentMileageDetail(
                isEditable: widget.isEditable,
                currentMileageTextEditController:
                    widget.currentMileageTextEditController!,
                currentDateTextEditController:
                    widget.currentDateTextEditController!,
                btnCDateClicked: widget.btnCDateClicked!,
                mileUnit: widget.mileUnit == 'mile' ? 'mi' : 'km',
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Measure Mileage In:',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        letterSpacing: 0.5,
                        color: AppTheme.of(context).primaryColor),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Radio(
                              value: 'mile',
                              groupValue: widget.mileUnit,
                              onChanged: (str) {
                                if (widget.isEditable)
                                  widget.onMileTypePress?.call(str as String);
                              },
                              activeColor: AppThemeState().primaryColor,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Miles',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                                fontSize: 15,
                                letterSpacing: 0.5,
                                color: AppTheme.of(context).primaryColor),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                            child: Radio(
                              value: 'kilometer',
                              groupValue: widget.mileUnit,
                              onChanged: (str) {
                                if (widget.isEditable)
                                  widget.onMileTypePress?.call(str as String);
                              },
                              activeColor: AppThemeState().primaryColor,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Kilometers',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                                fontSize: 15,
                                letterSpacing: 0.5,
                                color: AppTheme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              if (widget.isEditable) SizedBox(height: 20),
              if (widget.isEditable)
                BlueButton(
                  onPress: () => widget.btnSaveClicked?.call(),
                  text: 'SAVE',
                ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget downloadButton() {
    final proActivated = FlavorConfig.features['vehicle_details_pdf_download'];

    return InkWell(
      onTap: () {
        widget.btnCopyClicked?.call();
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppTheme.of(context).primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          /*border: proActivated != true
              ? Border.all(
                  color: Colors.red, // Set border color
                  width: 2, // Set border width
                )
              : null,*/
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(
          Icons.download,
          color: AppTheme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final VehicleDetailData? vehicleDetailData1;
  final VehicleDetailData? vehicleDetailData2;
  final bool isEdit;

  const GridItem(
      {Key? key,
      this.vehicleDetailData1,
      this.vehicleDetailData2,
      this.isEdit = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      vehicleDetailData1?.title ?? '',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: AppTheme.of(context).primaryColor),
                    ),
                    Spacer(),
                    SvgPicture.asset(
                      vehicleDetailData1?.icon ?? '',
                      color: Color(0xffD03737),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: vehicleDetailData1?.textEditingController,
                  keyboardType: vehicleDetailData1?.textInputType,
                  textCapitalization: TextCapitalization.sentences,
                  readOnly: isEdit,
                  inputFormatters: vehicleDetailData1?.title == 'Year'
                      ? [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ]
                      : null,
                  cursorColor: AppThemeState().primaryColor,
                  decoration: InputDecoration(
                      suffix: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          vehicleDetailData1?.suffix ?? '',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: AppTheme.of(context).primaryColor),
                        ),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      //  filled: true,
                      hintStyle: GoogleFonts.roboto(
                          color: Color(0xff121212).withOpacity(0.2)),
                      fillColor: Colors.white70),
                  maxLines: null,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: AppTheme.of(context).primaryColor),
                ),
              ],
            ),
            // height: 20,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      vehicleDetailData2?.title ?? '',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: AppTheme.of(context).primaryColor),
                    ),
                    Spacer(),
                    SvgPicture.asset(
                      vehicleDetailData2?.icon ?? '',
                      color: Color(0xffD03737),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: vehicleDetailData2?.textEditingController,
                  keyboardType: vehicleDetailData2?.textInputType,
                  textCapitalization: TextCapitalization.sentences,
                  readOnly: isEdit,
                  cursorColor: AppThemeState().primaryColor,
                  decoration: InputDecoration(
                      suffix: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          vehicleDetailData2?.suffix ?? '',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: AppTheme.of(context).primaryColor),
                        ),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintStyle: GoogleFonts.roboto(
                          color: Color(0xff121212).withOpacity(0.2)),
                      fillColor: Colors.white70),
                  maxLines: null,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: AppTheme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PurchaseDetail extends StatelessWidget {
  final bool? isEditable;
  final TextEditingController? purchaseMileageTextEditController;
  final TextEditingController? purchaseDateTextEditController;
  final Function? btnPDateClicked;
  final String mileUnit;

  const PurchaseDetail(
      {Key? key,
      this.purchaseMileageTextEditController,
      this.purchaseDateTextEditController,
      this.isEditable,
      this.btnPDateClicked,
      this.mileUnit = 'mi'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Purchase Details',
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                letterSpacing: 0.5,
                color: AppTheme.of(context).primaryColor),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 93,
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 15, bottom: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: InkWell(
                  onTap: () {
                    if (isEditable ?? false) btnPDateClicked?.call();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Date',
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: AppTheme.of(context).primaryColor),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            AssetImages.calendar_1,
                            color: Color(0xffD03737),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            purchaseDateTextEditController?.text ?? '',
                            maxLines: 1,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: AppTheme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // height: 20,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 15, bottom: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Mileage',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: AppTheme.of(context).primaryColor),
                        ),
                        Spacer(),
                        Image.asset(
                          AssetImages.meter,
                          width: 17,
                          height: 17,
                          color: Color(0xffD03737),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: purchaseMileageTextEditController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [CustomTextInputFormatter()],
                            readOnly: !(isEditable ?? false),
                            cursorColor: AppThemeState().primaryColor,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                //  filled: true,
                                hintStyle: GoogleFonts.roboto(
                                    color: Color(0xff121212).withOpacity(0.2)),
                                fillColor: Colors.white70),
                            maxLines: 1,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: AppTheme.of(context).primaryColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Text(
                            mileUnit,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: AppTheme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // height: 20,
              ),
            )
          ],
        )
      ],
    );
  }
}

class CurrentMileageDetail extends StatelessWidget {
  final bool? isEditable;
  final TextEditingController? currentMileageTextEditController;
  final TextEditingController? currentDateTextEditController;
  final String mileUnit;

  final Function? btnCDateClicked;

  const CurrentMileageDetail(
      {Key? key,
      this.currentMileageTextEditController,
      this.currentDateTextEditController,
      this.isEditable,
      this.btnCDateClicked,
      this.mileUnit = 'mi'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Current Mileage',
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                letterSpacing: 0.5,
                color: AppTheme.of(context).primaryColor),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 93,
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 15, bottom: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: InkWell(
                  onTap: () {
                    if (isEditable ?? false) btnCDateClicked?.call();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Date',
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: AppTheme.of(context).primaryColor),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            AssetImages.calendar_1,
                            color: Color(0xffD03737),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            currentDateTextEditController?.text ?? '',
                            maxLines: 1,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: AppTheme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // height: 20,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 15, bottom: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Mileage',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: AppTheme.of(context).primaryColor),
                        ),
                        Spacer(),
                        Image.asset(
                          AssetImages.meter,
                          width: 17,
                          height: 17,
                          color: Color(0xffD03737),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: currentMileageTextEditController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [CustomTextInputFormatter()],
                            readOnly: !(isEditable ?? false),
                            cursorColor: AppThemeState().primaryColor,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                //  filled: true,
                                hintStyle: GoogleFonts.roboto(
                                    color: Color(0xff121212).withOpacity(0.2)),
                                fillColor: Colors.white70),
                            maxLines: 1,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: AppTheme.of(context).primaryColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Text(
                            mileUnit,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: AppTheme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // height: 20,
              ),
            )
          ],
        )
      ],
    );
  }
}

class VerticalStrip extends StatelessWidget {
  final String title;
  final String prefillIcon;
  final String value;
  final TextEditingController? textEditingController;
  final bool isEditable;
  final bool isPrefix;
  final String prefixText;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;

  const VerticalStrip({
    Key? key,
    this.title = '',
    this.prefillIcon = '',
    this.value = '',
    this.textEditingController,
    this.isEditable = false,
    this.isPrefix = false,
    this.prefixText = '',
    this.keyboardType,
    this.textCapitalization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Row(
        children: [
          SvgPicture.asset(
            prefillIcon,
            width: 20,
            height: 20,
            color: Color(0xffD03737),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: GoogleFonts.roboto(
                color: AppTheme.of(context).primaryColor,
                fontWeight: FontWeight.w400,
                fontSize: 13),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              controller: textEditingController,
              keyboardType:
                  keyboardType == null ? TextInputType.number : keyboardType,
              inputFormatters:
                  keyboardType == null ? [CustomTextInputFormatter()] : [],
              readOnly: !isEditable,
              textCapitalization: TextCapitalization.sentences,
              cursorColor: AppThemeState().primaryColor,
              decoration: InputDecoration(
                  prefix: isPrefix
                      ? Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Text(
                            prefixText,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: AppTheme.of(context).primaryColor),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  //  filled: true,
                  hintStyle: GoogleFonts.roboto(
                      color: Color(0xff121212).withOpacity(0.2)),
                  fillColor: Colors.white70),
              maxLines: 1,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: AppTheme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class VehicleDetailData {
  final String title;
  final String suffix;
  final String icon;
  final TextEditingController textEditingController;
  final TextInputType textInputType;

  VehicleDetailData(
      this.title, this.suffix, this.icon, this.textEditingController,
      {this.textInputType = TextInputType.number});
}
