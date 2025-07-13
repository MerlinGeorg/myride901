import 'dart:io';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/services/shared_preference.dart';
import 'package:myride901/features/subscription/subscription_page.dart';
import 'package:myride901/features/subscription/widgets/subscription_end_popup.dart';
import 'package:myride901/features/subscription/widgets/subscription_info_popup.dart';
import 'package:myride901/models/category_type/category_type.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/core/services/api_client/api_client.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Utils {
  static const animationDuration = Duration(milliseconds: 200);
  static const int androidDeviceTypeId = 2;
  static const int iosDeviceTypeId = 1;

  static List<CategoryType> arrCategoryType = [
    CategoryType.fromJson({"name": "Service", "id": "1"}),
    CategoryType.fromJson({"name": "Parts", "id": "2"})
  ];

  static DateTime convertDateFromString(String strDate) {
    DateTime date = DateTime.parse(strDate);
    return date;
  }

  static String stringJoiner(List<String> list) {
    var result = "";
    if (list.length == 1) {
      return list[0];
    }
    for (int i = 0; i < list.length; i++) {
      if (i == list.length - 2) {
        result += list[i] + " & ";
      } else if (i == list.length - 1) {
        result += list[i];
      } else {
        result += list[i] + ", ";
      }
    }
    return result;
  }

  static showImageDialogCallBack(
      {@required BuildContext? context, dynamic image}) {
    Object ip = (image is String) ? NetworkImage(image) : FileImage(image);
    showDialog(
        context: context!,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.black.withOpacity(0.3),
              alignment: Alignment.center,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width - 40,
                child: PhotoView(
                  imageProvider: ip as ImageProvider,
                  backgroundDecoration:
                      BoxDecoration(color: Colors.transparent),
                  // minScale: minScale,
                  // maxScale: maxScale,
                  heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
                ),
              ),
            ),
          );
        });
  }

  static Future<void> displaySubscriptionPopup(
      BuildContext context,
      SubscriptionFeature feature,
      Map<String, dynamic> subscriptionState,
      String? routeOrigin) {
    final isTrialStarted = subscriptionState['isTrialStarted'] ?? false;

    if (isTrialStarted == false) {
      return showSubscriptionInfoDialog(context, feature, routeOrigin);
    } else {
      return showSubscriptionEndDialog(context, true, routeOrigin);
    }
  }

  static Future<void> displayReminderTrialEndPopup(
    BuildContext context,
    Map<String, dynamic> subscriptionState,
  ) async {
    final isDisplay = subscriptionState['shouldReminderTrialEnd'];

    if (isDisplay == true) {
      return showSubscriptionEndDialog(context, false, null);
    } else {
      return Future.value();
    }
  }

  static Future<void> showSubscriptionInfoDialog(
      BuildContext context, SubscriptionFeature feature, String? routeOrigin) {
    String description = "";
    switch (feature) {
      case SubscriptionFeature.vehicleHistory:
        description = StringConstants.subscription_vehicleHistory_desc;
      case SubscriptionFeature.trackMileage:
        description = StringConstants.subscription_trackMileage_desc;
      case SubscriptionFeature.serviceReceipt:
        description = StringConstants.subscription_serviceReceipt_desc;
      case SubscriptionFeature.accidentReport:
        description = StringConstants.subscription_accidentReport_desc;
      case SubscriptionFeature.nextServiceLookup:
        description = StringConstants.subscription_nextServiceLookup_desc;
      case SubscriptionFeature.safetyServiceLookup:
        description = StringConstants.subscription_safetyServiceLookup_desc;
        break;
      default:
    }

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          child: SubscriptionInfoPopup(
            description: description,
            onPress: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SubscriptionPage(routeOrigin: routeOrigin),
              ));
            },
          ),
        );
      },
    );
  }

  static Future<void> showSubscriptionEndDialog(
      BuildContext context, bool isSubscriptionExpired, String? routeOrigin) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            child: SubscriptionEndPopup(
              isSubscriptionExpired: isSubscriptionExpired,
              onPress: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      SubscriptionPage(routeOrigin: routeOrigin),
                ));
              },
            ));
      },
    );
  }

  static String formatDate(DateTime date) =>
      new DateFormat("d MMMM yyyy").format(date);

  static showAlertDialogCallBack1(
      {@required BuildContext? context,
      onPosClick,
      onNavClick,
      onOkClick,
      var message = StringConstants.errorOccured,
      String title = StringConstants.app_name,
      String posBtnName = 'YES',
      String navBtnName = 'NO',
      String okBtnName = 'OK',
      bool isConfirmationDialog = true,
      bool isOnlyOK = false}) {
    AppThemeState _appTheme;
    _appTheme = AppTheme.of(context!);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.only(left: 16, right: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title: Center(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 20,
                    color: _appTheme.primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            content: Text(
              message,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            actions: isConfirmationDialog
                ? isOnlyOK
                    ? <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onOkClick();
                          },
                          child: Text(okBtnName,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: _appTheme.primaryColor,
                                  fontWeight: FontWeight.bold)),
                        )
                      ]
                    : <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(okBtnName,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: _appTheme.primaryColor,
                                  fontWeight: FontWeight.bold)),
                        )
                      ]
                : <Widget>[
                    Container(
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              onNavClick();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: _appTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.only(
                                  left: 18, right: 18, top: 8, bottom: 8),
                              child: Text(navBtnName,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              onPosClick();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: _appTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.only(
                                  left: 18, right: 18, top: 8, bottom: 8),
                              child: Text(posBtnName,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
          );
        });
  }

  static String getYear(VehicleProfile vehicleProfile) {
    String pDate = vehicleProfile.PDate ?? '';
    String cDate = vehicleProfile.CDate ?? '';

    if (pDate == "" || cDate == "") {
      return '0';
    } else {
      var formatter = new DateFormat(
          AppComponentBase.getInstance().getLoginData().user?.date_format);
      var diffDt = formatter
          .parse(cDate)
          .difference(formatter.parse(pDate)); // 249:59:59.999000
      print((diffDt.inDays / 365).toStringAsFixed(0));
      print(((diffDt.inDays % 365) / 30).toStringAsFixed(0));
      return (diffDt.inDays / 365).toStringAsFixed(0) +
          '.' +
          ((diffDt.inDays % 365) / 30).toStringAsFixed(0);
    }
  }

  static String removeLast3(String str) {
    return str.substring(0, str.length - 3);
  }

  static launchURL(url, {bool isForce = true}) async {
    if (isForce) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false, forceWebView: false);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  static String checkEmailOrUserName(dynamic value) {
    String userName = value['user_name'] ?? '';
    if (userName == '') {
      userName = value['email'] ?? '';
    }
    return userName;
  }

  static String checkEmailOrUserName2(dynamic value) {
    String userName = value['user_name'] ?? '';
    if (userName == '') {
      userName = value['user_email'] ?? '';
    }
    return userName;
  }

  //new
  static Widget socialButton(
      {BuildContext? context,
      String? key,
      Function? onPress,
      Color? bgColor,
      Color? titleColor,
      String? icon,
      String title = ''}) {
    return InkWell(
      key: key != null ? Key(key) : null,
      onTap: () {
        onPress!.call();
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Image.asset(
                icon!,
                width: 20,
                height: 20,
              ),
              SizedBox(
                width: 35,
              ),
              FittedBox(
                child: Text(
                  title,
                  style: GoogleFonts.roboto(
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static String getProfileImage(VehicleProfile? vehicleProfile) {
    var str = '';
    for (var a in vehicleProfile?.images ?? []) {
      if ((a['is_profile'] ?? '0') == '1') {
        str = a['image_url'] ?? '';
      }
    }
    return str;
  }

  static Future<File?> imgFromCamera() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 30);
    if (image == null) return null;

    // int bytes = await image.length();
    // if(bytes/1000000 > 20)
    // {
    //   CommonToast.getInstance().displayToast(message: StringConstants.File_size_must_not_be_more_than_20_MB);
    //   return null;
    // }
    return File(image.path);
  }

  static Future<File?> imgFromGallery() async {
    var _paths = (await FilePicker.platform
            .pickFiles(type: FileType.image, allowMultiple: false))
        ?.files;
    if (_paths == null || _paths.length == 0) {
      return null;
    }
    return File(_paths[0].path ?? '');
    // File image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 30);
    // if(image == null)return null;
    //
    // // int bytes = await image.length();
    // // if(bytes/1000000 > 20)
    // // {
    // //   CommonToast.getInstance().displayToast(message: StringConstants.File_size_must_not_be_more_than_20_MB);
    // //   return null;
    // // }
    // return image;
  }

  static Future<File?> videoFromGallery() async {
    var _paths = (await FilePicker.platform
            .pickFiles(type: FileType.video, allowMultiple: false))
        ?.files;
    if (_paths == null || _paths.length == 0) {
      return null;
    }
    return File(_paths[0].path ?? '');
    // File image = await ImagePicker.pickVideo(source: ImageSource.gallery);
    // if(image == null)return null;
    //
    // // int bytes = await image.length();
    // // if(bytes/1000000 > 20)
    // // {
    // //   CommonToast.getInstance().displayToast(message: StringConstants.File_size_must_not_be_more_than_20_MB);
    // //   return null;
    // // }
    // return image;
  }

  static Future<File?> docFromGallery() async {
    var _paths = (await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowMultiple: false,
            allowedExtensions: StringConstants.arrType))
        ?.files;
    if (_paths == null || _paths.length == 0) {
      return null;
    }
    // int bytes = await File(_paths[0].path).length();
    // if(bytes/1000000 > 20)
    // {
    //   CommonToast.getInstance().displayToast(message: StringConstants.File_size_must_not_be_more_than_20_MB);
    //   return null;
    // }
    return File(_paths[0].path ?? '');
  }

  static Future<File?> openGallery() async {
    final picker = ImagePicker();
    var file = await picker.pickImage(source: ImageSource.gallery);
    return file == null ? null : File(file.path);
  }

  static Future<File?> openCamera() async {
    final picker = ImagePicker();
    var file = await picker.pickImage(source: ImageSource.camera);
    return file == null ? null : File(file.path);
  }

  static btnSelectImageClicked(
      {BuildContext? context, Function? getFile}) async {
    selectImagePopup(
        context: context!,
        onCameraClick: () {
          openCamera().then((value) {
            getFile!(value);
          });
        },
        onGalleryClick: () {
          openGallery().then((value) {
            getFile!(value);
          });
        });
  }

  static selectImagePopup(
      {BuildContext? context,
      Function? onGalleryClick,
      Function? onCameraClick}) {
    AppThemeState _appTheme = AppTheme.of(context!);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(3))),
            titlePadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            contentPadding:
                EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
            content: Container(
              height: 130,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set Profile image',
                    style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      onCameraClick!();
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Take a picture',
                        style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onGalleryClick!();
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Choose from gallery',
                        style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static String addComma(String newValue) {
    List<String> chars =
        (newValue.split('').reversed.join().replaceAll(',', '').split('.'))[0]
            .split('');
    String newString = '';
    for (int i = chars.length - 1; i >= 0; i--) {
      if ((i + 1) % 3 == 0 && i != 0) newString += ',';
      newString += chars[i];
    }
    if (newString.length > 0 && newString[0] == ',') {
      newString = newString.replaceFirst(',', '');
    }
    return newString;
  }

  static Future<void> getDetail() async {
    await AppComponentBase.getInstance()
        .getApiInterface()
        .getUserRepository()
        .loginDetail()
        .then((value) {
      SharedPreference pref =
          AppComponentBase.getInstance().getSharedPreference();
      pref.setUserDetail(value);
      pref.setUserName(value);
      AppComponentBase.getInstance().setLoginData(value);
      return;
    }).catchError((onError) {
      print(onError);
    });
  }

  static List<VehicleProfile> arrangeVehicle(List<VehicleProfile> v, int id) {
    List<VehicleProfile> ownList = [];

    List<VehicleProfile> sharedVehicle = [];
    List<VehicleProfile> v1 = [];
    v.forEach((element) {
      if (element.isMyVehicle == 0) {
        sharedVehicle.add(element);
      } else {
        ownList.add(element);
      }
    });
    ownList.sort((a, b) => a.id!.compareTo(id));
    sharedVehicle.sort((a, b) => a.id!.compareTo(id));

    v1 = [...ownList, ...sharedVehicle];
    return v1;
  }
  // static String k_m_b_generator(num) {
  //   if (num > 999999 && num < 999999999) {
  //     return "${(num / 1000000).toStringAsFixed(1)} M";
  //   } else if (num > 999999999) {
  //     return "${(num / 1000000000).toStringAsFixed(1)} B";
  //   } else {
  //     return num.toString();
  //   }
  // }

  static sendErrorOnSlack(
      String origin, String? exception, String? stacktrace) async {
    var model = "";
    var brand = "";
    var osVersion = "";
    var environment = dotenv.env['IS_RELEASE'] == false ? "Dev" : "Prod";

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      model = iosInfo.model;
      osVersion = iosInfo.systemVersion;
    } else if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      model = androidInfo.model;
      brand = androidInfo.brand;
      osVersion = androidInfo.version.release;
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    var appVersion = packageInfo.version + '(' + packageInfo.buildNumber + ')';

    var loginData = AppComponentBase.getInstance().getLoginData();
    var token = loginData.token;
    var userId = loginData.user?.id;

    //Slack's Webhook URL
    var url =
        'https://hooks.slack.com/services/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';

    //Makes request headers
    Map<String, String> requestHeader = {
      'Content-type': 'application/json',
    };

    var request = {
      'text':
          "\n +++ Environment: $environment \n userId: $userId \n userToken: $token \n Origin of error: $origin \n device model: $model \n device brand: $brand, \n OS Version: $osVersion \n App version: $appVersion \n ----------- \n exception: $exception \n stacktrace: $stacktrace \n",
    };

    var result = http
        .post(Uri.parse(url),
            body: json.encode(request), headers: requestHeader)
        .then((response) {
      print(response.body);
    });
    print(result);
  }
}

class CurrencyPtBrFormatter extends TextInputFormatter {
  CurrencyPtBrFormatter({this.maxDigits, this.uMaskValue});
  final int? maxDigits;
  double? uMaskValue;
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    if (maxDigits != null && newValue.selection.baseOffset > maxDigits!) {
      return oldValue;
    }
    double value = double.parse(newValue.text);
    final formatter = new NumberFormat("#,##0.00", "pt_BR");
    String newText = "R\$ " + formatter.format(value / 100);
    //setting the umasked value
    uMaskValue = value / 100;
    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }

  //here the method
  double getUnmaskedDouble() {
    return uMaskValue ?? 0;
  }
}

class CustomTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;
      List<String> chars = (newValue.text
              .split('')
              .reversed
              .join()
              .replaceAll(',', '')
              .split('.'))[0]
          .split('');
      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((i + 1) % 3 == 0 && i != 0) newString += ',';
        newString += chars[i];
      }
      if (newString.length > 0 && newString[0] == ',') {
        newString = newString.replaceFirst(',', '');
      }
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}

class DecimalFormatter extends TextInputFormatter {
  final int decimalDigits;

  DecimalFormatter({this.decimalDigits = 200}) : assert(decimalDigits >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText;

    if (decimalDigits == 0) {
      newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    } else {
      newText = newValue.text.replaceAll(RegExp('[^0-9\.]'), '');
    }

    if (newText.contains('.')) {
      //in case if user's first input is "."
      if (newText.trim() == '.') {
        return newValue.copyWith(
          text: '0.',
          selection: TextSelection.collapsed(offset: 2),
        );
      }
      //in case if user tries to input multiple "."s or tries to input
      //more than the decimal place
      else if ((newText.split(".").length > 2) ||
          (newText.split(".")[1].length > this.decimalDigits)) {
        return oldValue;
      } else
        return newValue;
    }

    //in case if input is empty or zero
    if (newText.trim() == '' || newText.trim() == '0') {
      return newValue.copyWith(text: '');
    } else if (int.parse(newText) < 1) {
      return newValue.copyWith(text: '');
    }

    double newDouble = double.parse(newText);
    var selectionIndexFromTheRight =
        newValue.text.length - newValue.selection.end;

    String newString = NumberFormat("#,##0.##").format(newDouble);

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(
        offset: newString.length - selectionIndexFromTheRight,
      ),
    );
  }
}
