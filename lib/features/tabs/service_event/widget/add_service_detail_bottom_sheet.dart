import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/my_ride_dropdown.dart';
import 'package:myride901/widgets/my_ride_textform_field.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';

class AddServiceBottomSheet extends StatefulWidget {
  final List<String>? type;
  final Details? details;
  final Function(Details?)? onSave;
  final bool? isHidePrice;

  const AddServiceBottomSheet(
      {Key? key, this.type, this.details, this.onSave, this.isHidePrice})
      : super(key: key);

  @override
  _AddServiceBottomSheetState createState() => _AddServiceBottomSheetState();
}

class _AddServiceBottomSheetState extends State<AddServiceBottomSheet> {
  String _selectedItem = '';
  List<DropdownMenuItem<String>> _dropdownList = [];
  TextEditingController textEditingController = TextEditingController();
  TextEditingController txtPrice = TextEditingController();
  final categoryMap = {
    StringConstants.service: '1',
    StringConstants.parts: '2',
    StringConstants.engine: '3',
    StringConstants.fuel: '4',
    StringConstants.ignition: '5',
    StringConstants.transmission: '6',
    StringConstants.suspension: '7',
    StringConstants.steering: '8',
    StringConstants.brakingSys: '9',
    StringConstants.electricSys: '10',
    StringConstants.bodywork: '11',
    StringConstants.computing: '12',
  };
  List<DropdownMenuItem<String>> _buildFavouriteFoodModelDropdown(
      List itemList) {
    List<DropdownMenuItem<String>> items = [];
    for (String item in itemList) {
      items.add(DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff121212)),
        ),
      ));
    }
    return items;
  }

  _onChangeItem(value) {
    //  widget.onVehicleSelect.call(value);
    setState(() {
      _selectedItem = value;
    });
  }

  @override
  void initState() {
    _dropdownList = _buildFavouriteFoodModelDropdown(widget.type ?? []);
    if (widget.details != null) {
      _selectedItem = widget.details?.categoryName ?? '';
      textEditingController =
          TextEditingController(text: widget.details?.description ?? '');
      txtPrice = TextEditingController(text: widget.details?.price);
    } else {
      _selectedItem = StringConstants.service;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 500,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: [
              SizedBox(height: 20),
              Align(
                  alignment: Alignment(0, 0),
                  child: SvgPicture.asset(AssetImages.rounderLine)),
              SizedBox(height: 40),
              Text(
                'Add Service List',
                style: GoogleFonts.roboto(
                    color: AppTheme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 17),
              ),
              SizedBox(height: 20),
              MyRideDropdown(
                dropdownMenuItemList: _dropdownList,
                onChanged: _onChangeItem,
                value: _selectedItem,
                isEnabled: true,
              ),
              SizedBox(height: 20),
              TextFormField(
                maxLines: 7,
                cursorColor: Colors.black,
                controller: textEditingController,
                textCapitalization: TextCapitalization.sentences,
                onFieldSubmitted: (str) {},
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppTheme.of(context).primaryColor, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(208, 208, 208, 1), width: 1.0),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(208, 208, 208, 1), width: 1.0),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    hintStyle: GoogleFonts.roboto(
                        color: Color(0xff121212).withOpacity(0.2),
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                    hintText: StringConstants.add_description,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 10.0),
                    fillColor: Colors.white70),
              ),
              if (!(widget.isHidePrice ?? false)) SizedBox(height: 20),
              if (!(widget.isHidePrice ?? false))
                MyRideTextFormField(
                  textInputType: TextInputType.numberWithOptions(decimal: true),
                  textEditingController: txtPrice,
                  ifs: [
                    DecimalFormatter(),
                  ],
                  hintText: 'Price',
                ),
              SizedBox(height: 40),
              BlueButton(
                text: StringConstants.save,
                onPress: () {
                  if (txtPrice.text != '' &&
                      Validation.isNotValidPrice(
                          textEditingController: txtPrice,
                          msg: StringConstants.pleaseEnterValidPrice)) {
                    return false;
                  } else {
                    Details? details =
                        widget.details == null ? Details() : widget.details;
                    details?.description = textEditingController.text;
                    details?.categoryName = _selectedItem;
                    details?.price = txtPrice.text;
                    details?.category = categoryMap[_selectedItem] ?? '13';
                    widget.onSave?.call(details);
                    Navigator.pop(context);
                  }
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ));
  }
}
