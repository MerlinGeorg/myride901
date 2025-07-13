import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/subscription/widgets/subscription_widgets.dart';

class SubscriptionInfoPopup extends StatelessWidget {
  final String description;
  final VoidCallback? onPress;

  const SubscriptionInfoPopup({
    Key? key,
    required this.description,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/new/subscription_myride.png'),
                SizedBox(height: 20),
                SvgPicture.asset(
                  'assets/new/subscription_diamond.svg',
                  height: 114,
                ),
                SizedBox(height: 20),
                Text(
                  StringConstants.subscriptionInfoPopup_title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),
                SubscriptionFeatureRow(description, true),
                SizedBox(height: 40),
                Row(
                  children: [
                    Column(
                      children: [
                        SvgPicture.asset(
                          'assets/new/subscription_trial_icons.svg',
                          width: 40,
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        SubscriptionStep(
                          title:
                              StringConstants.subscriptionInfoPopup_step1_title,
                          description: StringConstants
                              .subscriptionInfoPopup_step1_description,
                        ),
                        SubscriptionStep(
                          title:
                              StringConstants.subscriptionInfoPopup_step2_title,
                          description: StringConstants
                              .subscriptionInfoPopup_step2_description,
                        ),
                        SubscriptionStep(
                          title:
                              StringConstants.subscriptionInfoPopup_step3_title,
                          description: StringConstants
                              .subscriptionInfoPopup_step3_description,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: BlueButton(
                    text: StringConstants.subscriptionInfoPopup_start_trial,
                    onPress: onPress ??
                        () {
                          Navigator.pop(context);
                        },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

enum SubscriptionFeature {
  vehicleHistory,
  trackMileage,
  serviceReceipt,
  accidentReport,
  nextServiceLookup,
  safetyServiceLookup,
}
