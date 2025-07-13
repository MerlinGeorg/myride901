import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/features/subscription/widgets/subscription_widgets.dart';

class SubscriptionEndPopup extends StatelessWidget {
  final bool isSubscriptionExpired;
  final VoidCallback? onPress;

  const SubscriptionEndPopup({
    Key? key,
    required this.isSubscriptionExpired,
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
                  isSubscriptionExpired
                      ? StringConstants.subscriptionEndPopup_title_end
                      : StringConstants.subscriptionEndPopup_title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  isSubscriptionExpired
                      ? StringConstants.subscriptionEndPopup_desc_end
                      : StringConstants.subscriptionEndPopup_desc,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24),
                SubscriptionFeatureRow(
                    StringConstants.subscription_serviceReceipt_desc, true),
                SubscriptionFeatureRow(
                    StringConstants.subscription_vehicleHistory_desc, true),
                SubscriptionFeatureRow(
                    StringConstants.subscription_trackMileage_desc, true),
                SubscriptionFeatureRow(
                    StringConstants.subscription_nextServiceLookup_desc, true),
                SubscriptionFeatureRow(
                    StringConstants.subscription_safetyServiceLookup_desc,
                    true),
                SubscriptionFeatureRow(
                    StringConstants.subscription_accidentReport_desc, true),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: BlueButton(
                    text: StringConstants.subscriptionEndPopup_button,
                    onPress: onPress ??
                        () {
                          Navigator.pop(context);
                        },
                  ),
                ),
                SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.webViewDisplayPage,
                        arguments: ItemArgument(data: {
                          'url': StringConstants.linkSubscriptionFeatures,
                          'title': StringConstants.premiumFeatureTitle,
                        }));
                  },
                  child: Text(
                    StringConstants.subscription_premiumFeature_hyperlink,
                    style: TextStyle(
                        fontSize: 17,
                        color: AppTheme.of(context).blueColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline),
                  ),
                ),
                if (isSubscriptionExpired == false) ...[
                  SizedBox(height: 24),
                  InkWell(
                    onTap: () async {
                      debugPrint("---> showReminderPopupWithDelay false ");
                      final pref =
                          AppComponentBase.getInstance().getSharedPreference();
                      await pref.setShouldReminderTrialEnd(false);
                      Navigator.pop(context);
                    },
                    child: Text(
                      StringConstants.subscriptionEndPopup_doNotShowAgain,
                      style: TextStyle(
                          fontSize: 17,
                          color: AppTheme.of(context).redColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
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
