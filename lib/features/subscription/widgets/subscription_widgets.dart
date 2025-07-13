import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/string_constanst.dart';

class SubscriptionPlanWidget extends StatelessWidget {
  final String plan;
  final String price;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  SubscriptionPlanWidget({
    required this.plan,
    required this.price,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFFBFE4FF) : Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: isSelected
                  ? Border.all(color: Color(0xFF0A7ACC), width: 2.0)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8.0),
                Text(description,
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    price,
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: 0,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Color(0xFF0D99FF),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  StringConstants.subscriptionPage_bestValue,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget SubscriptionFeatureRow(String featureText, bool isEnabled) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        isEnabled
            ? SvgPicture.asset(
                'assets/new/subscription_valid.svg',
                width: 24,
                height: 24,
              )
            : SvgPicture.asset(
                'assets/new/subscription_not_valid.svg',
                width: 24,
                height: 24,
              ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            featureText,
            style:
                GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    ),
  );
}

class SubscriptionStep extends StatelessWidget {
  final String title;
  final String description;

  const SubscriptionStep({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4),
        Text(
          description,
          style: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 28),
      ],
    );
  }
}
