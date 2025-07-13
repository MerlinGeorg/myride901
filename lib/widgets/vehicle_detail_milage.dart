import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';

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
