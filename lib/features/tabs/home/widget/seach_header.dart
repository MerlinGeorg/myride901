import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';

class SearchHeader extends StatelessWidget {
  final Function()? onFromDateTap;
  final Function()? onToDateTap;
  final String? fromDate;
  final String? toDate;
  final TextEditingController? fromMileage;
  final TextEditingController? toMileage;
  final Function(String)? onFieldSubmittedFromMileage;
  final Function(String)? onFieldSubmittedToMileage;

  const SearchHeader(
      {Key? key,
      this.onFromDateTap,
      this.onToDateTap,
      this.fromDate,
      this.toDate,
      this.fromMileage,
      this.toMileage,
      this.onFieldSubmittedFromMileage,
      this.onFieldSubmittedToMileage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'From',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: DateField(
                    onTap: () {
                      onFromDateTap?.call();
                    },
                    date: fromDate ?? '',
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MileageField(
                    mileage: fromMileage,
                    onFieldSubmitted: (data) {
                      onFieldSubmittedFromMileage?.call(data);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'To',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: DateField(
                    onTap: () {
                      onToDateTap?.call();
                    },
                    date: toDate,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MileageField(
                    onFieldSubmitted: (data) {
                      onFieldSubmittedToMileage?.call(data);
                    },
                    mileage: toMileage,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        ),
      ),
    );
  }
}

class DateField extends StatelessWidget {
  final String? date;
  final Function? onTap;

  const DateField({Key? key, this.date, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _appTheme = AppTheme.of(context);

    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        height: 40,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SvgPicture.asset(AssetImages.calendar_1),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                date ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  color: _appTheme.primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_sharp,
              color: _appTheme.primaryColor,
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _appTheme.primaryColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class MileageField extends StatelessWidget {
  final TextEditingController? mileage;
  final Function(String)? onFieldSubmitted;

  const MileageField({Key? key, this.mileage, this.onFieldSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _appTheme = AppTheme.of(context);

    return Container(
      height: 40,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AssetImages.meter,
            height: 17,
            width: 17,
            color: _appTheme.primaryColor,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 25,
              child: TextFormField(
                cursorColor: _appTheme.primaryColor,
                onChanged: (value) {
                  onFieldSubmitted?.call(value);
                },
                controller: mileage,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                inputFormatters: [
                  CustomTextInputFormatter(),
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  color: _appTheme.primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _appTheme.primaryColor.withOpacity(0.5), // red as border color
        ),
      ),
    );
  }
}
