import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///
/// This class contains all UI related styles
///
class AppTheme extends StatefulWidget {
  final Widget? child;

  AppTheme({
    @required this.child,
  });

  @override
  State<StatefulWidget> createState() {
    return AppThemeState();
  }

  static AppThemeState of(BuildContext context) {
    final _InheritedStateContainer? inheritedStateContainer =
        context.dependOnInheritedWidgetOfExactType();
    if (inheritedStateContainer == null) {
      return AppThemeState();
    } else {
      return inheritedStateContainer.data!;
    }
  }
}

class AppThemeState extends State<AppTheme> {
  double getResponsiveFont(double value) => ScreenUtil().setSp(value);

  double getResponsiveWidth(double value) => ScreenUtil().setWidth(value);

  double getResponsiveHeight(double value) => ScreenUtil().setHeight(value);

  ///
  /// Define All your colors here which are used in whole application
  ///
  Color get whiteColor => Color(0xFFFFFFFF);
  Color get primaryColor => Color(0xff0C1248);

  Color get primaryOpactiyColor => Color(0xff0C1248).withOpacity(0.2);
  Color get blueColor => Color(0xFF0085f9);
  Color get greenColor => Color(0xFF00B600);

  Color get noInternetColor => Color(0xFFD9534F);

  Color get redColor => Color(0xFFF52525);

  Color get dividerColor => Color(0xFFE6E7E8);

  Color get blackColor => Color(0xFF000000);

  Color get lightGrey => Color(0xFF76787A);

  Color get disabledIndicatorColor => Color(0xFF76787A);

  Color get shimmerBackgroundColor => Color(0xff484848).withOpacity(0.3);

  Color? get shimmerBaseColor => Colors.grey[300];

  Color? get shimmerHighlightColor => Colors.grey[100];

  Color get greyBackground => Color(0xFFF3F3F3);

  Color get sliderColor => Color(0xFFE4E4E4);

  Color get switchShadowColor => Color(0x40000029);

  ///
  /// Mention height and width which are mentioned in your design file(i.e XD)
  /// to maintain ratio for all other devices
  ///
  double get expectedDeviceWidth => 1080;

  double get expectedDeviceHeight => 1920;

  ///
  /// List of your Text Styles which are used through this app.
  ///
  TextStyle get noInternetTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w500,
      fontSize: getResponsiveFont(35),
      color: primaryColor);

  TextStyle get appBarTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.bold,
      fontSize: getResponsiveFont(40),
      color: whiteColor);

  TextStyle get postTitleTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.bold,
      fontSize: getResponsiveFont(35),
      color: blackColor);

  TextStyle get postBodyTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(30),
      color: blackColor.withOpacity(0.5));

  TextStyle get informationTitleTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(80),
      color: blackColor);

  TextStyle get getStartedTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(42),
      color: whiteColor);

  TextStyle get informationDescriptionTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(40),
      color: lightGrey);

  TextStyle get welcomeTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(68),
      color: blackColor);

  TextStyle get tabSelectedTextStyle => TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(46),
      color: primaryColor,
      fontFamily: "mavenPro");

  TextStyle get tsLiteTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(37),
      color: whiteColor);

  TextStyle get trialEndTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(38),
      color: lightGrey);

  TextStyle get navigationTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(44),
      color: blackColor);

  TextStyle get amountTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(70),
      color: blackColor);

  TextStyle get perMonthTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(30),
      color: lightGrey);

  TextStyle get featureTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(46),
      color: blackColor);

  TextStyle get dropDownTitleTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(42),
      color: primaryColor);

  TextStyle get subscriptionDetailTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(34),
      color: lightGrey);

  TextStyle get customerReferenceTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(40),
      color: lightGrey);

  TextStyle get searchTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(40),
      color: blackColor);

  TextStyle get customerReferenceHintTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(42),
      color: blackColor.withOpacity(0.2));

  TextStyle get customerReferenceTextFieldTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(42),
      color: blackColor);

  TextStyle get getStartedDisabledTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(42),
      color: whiteColor.withOpacity(0.5));

  TextStyle get lightGreyTitleTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(40),
      color: lightGrey);

  TextStyle get blackTitleTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(50),
      color: blackColor);

  TextStyle get tyreConditionTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(30),
      color: whiteColor);

  TextStyle get tyreTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(40),
      color: blackColor);

  TextStyle get dialogTitleTextStyle => TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(60),
      color: blackColor,
      fontFamily: "mavenPro");

  TextStyle get dialogSubTitleTextStyle => TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(40),
      color: lightGrey,
      fontFamily: "mavenPro");

  TextStyle get pageTitleTextStyle => TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(70),
      color: blackColor,
      fontFamily: "mavenPro");

  TextStyle get conditionTitleTextStyle => TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(54),
      color: blackColor,
      fontFamily: "mavenPro");

  TextStyle get conditionDescTextStyle => TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(34),
      color: lightGrey,
      fontFamily: "mavenPro");

  TextStyle get activeTextStyle => TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(25),
      color: whiteColor,
      fontFamily: "mavenPro");

  TextStyle get disabledTextStyle => TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: getResponsiveFont(42),
      color: sliderColor,
      fontFamily: "mavenPro");

  TextStyle get errorFieldTextStyle => TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: getResponsiveFont(32),
      color: redColor,
      fontFamily: "mavenPro");

  TextStyle get uploadPhotoTextStyle => TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(36),
      color: blackColor,
      fontFamily: "mavenPro");

  TextStyle get tyreCountTextStyle => TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(36),
      color: lightGrey,
      fontFamily: "mavenPro");

  TextStyle get tyrePositionTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(38),
      color: primaryColor);

  TextStyle get depthIndexTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveFont(42),
      color: blackColor);

  TextStyle get depthCurrentIndexTextStyle => TextStyle(
      fontFamily: "mavenPro",
      fontWeight: FontWeight.bold,
      fontSize: getResponsiveFont(42),
      color: primaryColor);

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final AppThemeState? data;

  _InheritedStateContainer({
    Key? key,
    @required this.data,
    @required Widget? child,
  }) : super(key: key, child: child!);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
