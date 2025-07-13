import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndPolicyDialog extends StatefulWidget {
  const TermsAndPolicyDialog({Key? key, this.onCancel, this.onAgree})
      : super(key: key);
  final Function? onCancel;
  final Function? onAgree;

  @override
  _TermsAndPolicyDialogState createState() => _TermsAndPolicyDialogState();
}

class _TermsAndPolicyDialogState extends State<TermsAndPolicyDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      elevation: 0,
      backgroundColor: Colors.black.withOpacity(0.5),
      child: Container(
        padding: const EdgeInsets.all(25),
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringConstants.termsAndConditions,
              style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.of(context).primaryColor),
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                text: StringConstants.i_agree_to,
                style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.of(context).primaryColor.withOpacity(0.6)),
                children: <TextSpan>[
                  TextSpan(
                    text: StringConstants.privacy_policy,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchURL(StringConstants.linkPrivacy);
                      },
                    style: GoogleFonts.roboto(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.of(context).primaryColor),
                  ),
                  TextSpan(
                    text: ' and ',
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color:
                            AppTheme.of(context).primaryColor.withOpacity(0.6)),
                  ),
                  TextSpan(
                    text: StringConstants.terms_of_service,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchURL(StringConstants.linkTerms);
                      },
                    style: GoogleFonts.roboto(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: BlueButton(
                      text: StringConstants.cancel,
                      onPress: () {
                        widget.onCancel!.call();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: BlueButton(
                      text: StringConstants.agree.toUpperCase(),
                      onPress: () {
                        widget.onAgree!.call();
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
