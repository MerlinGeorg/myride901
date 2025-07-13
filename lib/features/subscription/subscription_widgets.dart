import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/themes/app_theme.dart';

class SubscriptionCell extends StatelessWidget {
  final bool? isSelected;
  final int? numberOfMonth;
  final double? price;
  final bool isRecommended;
  final Function(bool)? onCheck;

  const SubscriptionCell(
      {Key? key,
      this.isSelected,
      this.numberOfMonth = 1,
      this.price = 2.00,
      this.isRecommended = false,
      this.onCheck})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onCheck?.call(!(isSelected ?? false));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 15.0,
                  offset: Offset(0.0, 0.75))
            ],
            color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset((isSelected ?? false)
                ? AssetImages.checked
                : AssetImages.unChecked),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$numberOfMonth month membership',
                    style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.of(context).primaryColor),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 27,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: RichText(
                    text: TextSpan(
                      text: '\$ ',
                      style: GoogleFonts.roboto(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.of(context).primaryColor),
                      children: <TextSpan>[
                        TextSpan(
                            text: '$price',
                            style: GoogleFonts.roboto(
                                fontSize: 27,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.of(context).primaryColor)),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ORDivider extends StatefulWidget {
  const ORDivider({Key? key}) : super(key: key);

  @override
  _ORDividerState createState() => _ORDividerState();
}

class _ORDividerState extends State<ORDivider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4 - 10,
          height: 1,
          color: AppTheme.of(context).primaryColor,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          'or',
          style: GoogleFonts.roboto(color: AppTheme.of(context).primaryColor),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.4 - 10,
          height: 1,
          color: AppTheme.of(context).primaryColor,
        ),
      ],
    );
  }
}
