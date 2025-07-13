import 'dart:convert';
import 'dart:io';
import 'package:myride901/flavor_config.dart';
import 'package:myride901/main.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/login_data/login_data.dart';
import 'package:myride901/models/response_status/response_status.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';

///
/// This class contains all URL which is being called to fetch data from server
///
///

class ApiClient {
  static String baseUrl = FlavorConfig.apiUrl;

  static String version = "";
  //Logins
  String loginUrl = baseUrl + version + "/login";
  String loginWithGoogleUrl = baseUrl + version + "/loginWithGoogle";
  String loginWithAppleUrl = baseUrl + version + "/loginWithApple";
  String logoutUrl = baseUrl + version + "/logout";

  //Registers
  String signupUrl = baseUrl + version + "/register";

  String userUrl = baseUrl + version + "/user";

  //User Account
  String deleteAccountUrl = baseUrl + version + "/delete-account";
  String updateProfileUrl = baseUrl + version + "/update-profile";

  String changePasswordUrl = baseUrl + version + "/change-password";
  String forgotPasswordUrl = baseUrl + version + "/forgot-password";
  String acknowledgeInApp = baseUrl + version + "/google/acknowledge";
  String startTrialUrl = baseUrl + version + "/start-trial";
  
  String resendCodeUrl = baseUrl + version + "/resend-code";
  String verifyCodeUrl = baseUrl + version + "/verify-code";
  String updateDevicetokenUrl = baseUrl + version + "/update-devicetoken";
  String appleVerifyUrl = baseUrl + version + "/apple/verify-receipt";
  String refreshTokenUrl = baseUrl + version + "/refresh-token";
  String contactUsUrl = baseUrl + version + "/contact-us";
  String appVersionUrl = baseUrl + version + "/app-version";

  String searchbyVinNumberUrl = baseUrl + version + "/search-by-vin-number";
  String shareVehicleUrl = baseUrl + version + "/share-vehicle";
  String getShareVehicleUrl = baseUrl + version + "/get-share-vehicle";
  String recallByVinUrl = baseUrl + version + "/recall-by-vin-number";
  String getVehicleCopy = baseUrl + version + "/get-vehicle-pdf";

  String shareServiceEventUrl = baseUrl + version + "/share-service-event";
  String serviceEventsByVinUrl = baseUrl + version + "/service-events-by-vin";
  String checkEmailUrl = baseUrl + version + "/email-check";

  //Permissions
  String getServicePermissionUrl =
      baseUrl + version + "/get-service-permission";
  String addServicePermissionUrl =
      baseUrl + version + "/add-service-permission";
  String userListUrl = baseUrl + version + "/user_list";
  String getVehiclePermissionUrl =
      baseUrl + version + "/get-vehicle-permission";
  String addVehiclePermissionUrl =
      baseUrl + version + "/add-vehicle-permission";

  //Chats
  String getServiceChatUrl = baseUrl + version + "/get-service-chat";
  String addServiceChatUrl = baseUrl + version + "/add-service-chat";
  String chatsUrl = baseUrl + version + "/chats";

  String addNewServicePermissionUrl =
      baseUrl + version + "/add-new-service-permission";
  String editNewServicePermissionUrl =
      baseUrl + version + "/edit-new-service-permission";
  String editVehiclePermissionUrl =
      baseUrl + version + "/edit-vehicle-permission";
  String addNewVehiclePermissionUrl =
      baseUrl + version + "/add-new-vehicle-permission";

  //ARF
  String reportApi = baseUrl + version + "/share-accident-report";
  String addAccidentReportUrl = baseUrl + version + "/add-accident-report";
  String addARAttacementsUrl =
      baseUrl + version + "/add-accident-report-attachments";
  String addWitnessUrl = baseUrl + version + "/add-witness";

  String getSharedServiceUrl = baseUrl + version + "/get-shared-service";
  String revokeServicePermissionUrl =
      baseUrl + version + "/revoke-service-permission";
  String revokeTimelinePermissionUrl =
      baseUrl + version + "/revoke-vehicle-permission";
  String getVehicleInformationUrl =
      baseUrl + version + "/get-vehicle-information";
  String getAdditionalInformationUrl =
      baseUrl + version + "/get-additional-information";
  String contactListUrl = baseUrl + version + "/contact-list";
  String searchUserUrl = baseUrl + version + "/search-user";

  //Wallets
  String addWalletUrl = baseUrl + version + "/add-wallet";
  String updateWalletUrl = baseUrl + version + "/update-wallet";
  String deleteWalletUrl = baseUrl + version + "/delete-wallet";
  String deleteWalletDefaultUrl = baseUrl + version + "/delete-wallet-default";

  //Blog & FAQ
  String getBlogUrl = "https://www.myride901.com/wp-json/api/myride-posts";
  String getBlogDetailUrl =
      "https://www.myride901.com/wp-json/api/myride-posts-detail";

  //Contacts
  String providerURL = baseUrl + version + "/service-providers";

  //Vehicles
  String vehiclesUrl = baseUrl + version + "/vehicles";
  //Update currency
  String currencyUrl = baseUrl + version + "/update-currency";

  String changeDateFormatUrl = baseUrl + version + "/change-date-format";

  //Trips
  String remindersUrl = baseUrl + version + "/reminders";

  //Events
  String eventUrl = baseUrl + version + "/vehicle-events";

  //Trips
  String tripUrl = baseUrl + version + "/trips";

  //Maps API
  String getDirectionsUrl = baseUrl + version + "/directions";
  String getAddressAutocompleteUrl =
      baseUrl + version + "/address-autocompletes";
  String getProvidersAddressUrl = baseUrl + version + "/address-providers";

  //Scanner
  String scanUrl = baseUrl + version + "/image-scanner";

  //Shops
  String fetchShopsUrl = baseUrl + version + "/shops";
  String authorizedShopsUrl = baseUrl + version + "/authorizedShops";

  //QA tool
  String updateTrialStatusUrl = baseUrl + version + "/trial-status";
  String resetSubscriptionUrl = baseUrl + version + "/subscriptions/reset";

  final String jsonHeaderName = "Content-Type";
  final String jsonHeaderValue = "application/json; charset=UTF-8";
  final String formHeaderValue =
      "multipart/form-data; boundary=<calculated when request is sent>";
  final int successResponse = 200;

  Map<String, String> getJsonHeader() {
    var header = Map<String, String>();
    header[jsonHeaderName] = jsonHeaderValue;
    return header;
  }

  Map<String, String> getFormHeader() {
    var header = Map<String, String>();
    header[jsonHeaderName] = formHeaderValue;
    return header;
  }

  gets(String url,
      {Map<String, String>? headers,
      String? token,
      bool isProgressBar = true,
      bool isBackground = false}) async {
    if (headers == null) {
      headers = getJsonHeader();
    }
    token != null
        ? headers['Authorization'] = 'Bearer $token'
        : redirectToLoginPage();

    if (await AppComponentBase.getInstance()
        .getNetworkManager()
        .isConnected()) {
      if (isProgressBar) {
        AppComponentBase.getInstance().showProgressDialog(true);
      }
      try {
        var response = await http.get(Uri.parse(url), headers: headers);
        logPrint(response: response);

        if (isProgressBar) {
          AppComponentBase.getInstance().showProgressDialog(false);
        }
        var responseStatus =
            ResponseStatus.fromJson(json.decode(response.body));
        if (response.statusCode == successResponse &&
            responseStatus.status_code == successResponse) {
          return responseStatus;
        } else if (responseStatus.status_code == 456) {
          redirectToLoginPage();
        } else {
          throw responseStatus.message ?? '';
        }
      } catch (exception, stacktrace) {
        if (isProgressBar) {
          AppComponentBase.getInstance().showProgressDialog(false);
        }
        await logError(
            "$url in gets method", exception, stacktrace, isBackground);
        throw Exception(exception);
      }
    } else {
      if (!isBackground) {
        CommonToast.getInstance()
            .displayToast(message: StringConstants.noInternetConnection);
      }
      throw StringConstants.noInternetConnection;
    }
  }

  postWithoutToken(String url,
      {Map<String, String>? headers,
      dynamic body,
      Encoding? encoding,
      bool isProgressBar = true,
      bool isBackground = false}) async {
    if (headers == null) {
      headers = getJsonHeader();
    }
    if (await AppComponentBase.getInstance()
        .getNetworkManager()
        .isConnected()) {
      if (isProgressBar) {
        AppComponentBase.getInstance().showProgressDialog(true);
      }

      try {
        var response = await http.post(Uri.parse(url),
            headers: headers, body: body, encoding: encoding);
        logPrint(requestData: body, response: response);

        if (isProgressBar) {
          AppComponentBase.getInstance().showProgressDialog(false);
        }
        var responseStatus =
            ResponseStatus.fromJson(json.decode(response.body));

        if (response.statusCode == successResponse &&
            responseStatus.status_code == successResponse) {
          return responseStatus;
        } else if (responseStatus.status_code == 456) {
          redirectToLoginPage();
        } else {
          throw responseStatus.message ?? '';
        }
      } catch (exception, stacktrace) {
        if (isProgressBar) {
          AppComponentBase.getInstance().showProgressDialog(false);
        }
        await logError(
            "$url in posts method", exception, stacktrace, isBackground);
        throw Exception(exception);
      }
    } else {
      if (!isBackground) {
        CommonToast.getInstance()
            .displayToast(message: StringConstants.noInternetConnection);
      }
      throw StringConstants.noInternetConnection;
    }
  }

  posts(String url,
      {Map<String, String>? headers,
      dynamic body,
      String? token,
      Encoding? encoding,
      bool isProgressBar = true,
      bool isBackground = false}) async {
    if (headers == null) {
      headers = getJsonHeader();
    }
    token != null
        ? headers['Authorization'] = 'Bearer $token'
        : redirectToLoginPage();
    if (await AppComponentBase.getInstance()
        .getNetworkManager()
        .isConnected()) {
      if (isProgressBar) {
        AppComponentBase.getInstance().showProgressDialog(true);
      }

      try {
        var response = await http.post(Uri.parse(url),
            headers: headers, body: body, encoding: encoding);
        logPrint(requestData: body, response: response);

        if (isProgressBar) {
          AppComponentBase.getInstance().showProgressDialog(false);
        }
        var responseStatus =
            ResponseStatus.fromJson(json.decode(response.body));

        if (response.statusCode == successResponse &&
            responseStatus.status_code == successResponse) {
          return responseStatus;
        } else if (responseStatus.status_code == 456) {
          redirectToLoginPage();
        } else {
          throw responseStatus.message ?? '';
        }
      } catch (exception, stacktrace) {
        if (isProgressBar) {
          AppComponentBase.getInstance().showProgressDialog(false);
        }
        await logError(
            "$url in posts method", exception, stacktrace, isBackground);
        throw Exception(exception);
      }
    } else {
      if (!isBackground) {
        CommonToast.getInstance()
            .displayToast(message: StringConstants.noInternetConnection);
      }
      throw StringConstants.noInternetConnection;
    }
  }

  puts(String url,
      {Map<String, String>? headers,
      dynamic body,
      String? token,
      Encoding? encoding,
      bool isProgressBar = true,
      bool isBackground = false}) async {
    if (headers == null) {
      headers = getJsonHeader();
    }
    token != null
        ? headers['Authorization'] = 'Bearer $token'
        : redirectToLoginPage();
    if (await AppComponentBase.getInstance()
        .getNetworkManager()
        .isConnected()) {
      if (isProgressBar) {
        AppComponentBase.getInstance().showProgressDialog(true);
      }
      try {
        var response = await http.put(Uri.parse(url),
            headers: headers, body: body, encoding: encoding);
        logPrint(requestData: body, response: response);

        if (isProgressBar) {
          AppComponentBase.getInstance().showProgressDialog(false);
        }
        var responseStatus =
            ResponseStatus.fromJson(json.decode(response.body));
        if (response.statusCode == successResponse &&
            responseStatus.status_code == successResponse) {
          return responseStatus;
        } else if (responseStatus.status_code == 456) {
          redirectToLoginPage();
        } else {
          throw responseStatus.message ?? '';
        }
      } catch (exception, stacktrace) {
        if (isProgressBar) {
          AppComponentBase.getInstance().showProgressDialog(false);
        }
        await logError(
            "$url in puts method", exception, stacktrace, isBackground);
        throw Exception(exception);
      }
    } else {
      if (!isBackground) {
        CommonToast.getInstance()
            .displayToast(message: StringConstants.noInternetConnection);
      }
      throw StringConstants.noInternetConnection;
    }
  }

  deletes(String url,
      {Map<String, String>? headers,
      dynamic body,
      String? token,
      Encoding? encoding,
      bool isProgressBar = true,
      bool isBackground = false}) async {
    if (headers == null) {
      headers = getJsonHeader();
    }
    token != null
        ? headers['Authorization'] = 'Bearer $token'
        : redirectToLoginPage();
    if (await AppComponentBase.getInstance()
        .getNetworkManager()
        .isConnected()) {
      if (isProgressBar) {
        AppComponentBase.getInstance().showProgressDialog(true);
      }
      try {
        var response = await http.delete(Uri.parse(url),
            headers: headers, body: body, encoding: encoding);
        logPrint(requestData: body, response: response);

        if (isProgressBar) {
          AppComponentBase.getInstance().showProgressDialog(false);
        }
        var responseStatus =
            ResponseStatus.fromJson(json.decode(response.body));
        if (response.statusCode == successResponse &&
            responseStatus.status_code == successResponse) {
          return responseStatus;
        } else if (responseStatus.status_code == 456) {
          redirectToLoginPage();
        } else {
          throw responseStatus.message ?? '';
        }
      } catch (exception, stacktrace) {
        if (isProgressBar) {
          AppComponentBase.getInstance().showProgressDialog(false);
        }
        await logError(
            "$url in deletes method", exception, stacktrace, isBackground);
        throw Exception(exception);
      }
    } else {
      if (!isBackground) {
        CommonToast.getInstance()
            .displayToast(message: StringConstants.noInternetConnection);
      }
      throw StringConstants.noInternetConnection;
    }
  }

  Future uploadMultipleImages(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    String? token,
    Encoding? encoding,
    bool isProgressBar = true,
    bool isBackground = false,
  }) async {
    if (headers == null) {
      headers = getFormHeader();
    }
    token != null
        ? headers['Authorization'] = 'Bearer $token'
        : redirectToLoginPage();
    if (await AppComponentBase.getInstance()
        .getNetworkManager()
        .isConnected()) {
      print(body);
      if (isProgressBar) {
        AppComponentBase.getInstance().showProgressDialog(true);
      }

      try {
        var uri = Uri.parse(url);
        http.MultipartRequest request = new http.MultipartRequest('POST', uri);
        request.headers.addAll(headers);
        var arrkey =
            body!.entries.map((MapEntry mapEntry) => mapEntry.key).toList();
        var arrvalue =
            body.entries.map((MapEntry mapEntry) => mapEntry.value).toList();

        for (int i = 0; i < arrkey.length; i++) {
          if (arrvalue[i] != null && arrvalue[i] is List<File>) {
            arrvalue[i].forEach((value) async {
              final multipartFile =
                  await http.MultipartFile.fromPath(arrkey[i], value?.path);
              request.files.add(multipartFile);
            });
          } else if (arrvalue[i] != null && arrvalue[i] is File) {
            final multipartFile =
                await http.MultipartFile.fromPath(arrkey[i], arrvalue[i].path);
            request.files.add(multipartFile);
          } else if (arrvalue[i] != null && arrvalue[i] is List) {
            for (int j = 0; j < arrvalue[i].length; j++) {
              request.fields['${arrkey[i]}_${j + 1}'] = arrvalue[i][j] ?? '';
            }
          } else {
            request.fields[arrkey[i]] = arrvalue[i].toString();
          }
        }

        final response = await http.Response.fromStream(await request.send());
        logPrint(requestData: '', response: response);

        if (response.statusCode == 413) {
          // file too big
          throw response.statusCode;
        }

        if (isProgressBar) {
          AppComponentBase.getInstance().showProgressDialog(false);
        }
        print("isProgressBar 1 -----> stopLoader");
        var responseStatus =
            ResponseStatus.fromJson(json.decode(response.body));

        if (response.statusCode == successResponse &&
            responseStatus.status_code == successResponse) {
          return responseStatus;
        } else if (responseStatus.status_code == 456) {
          redirectToLoginPage();
        } else {
          throw responseStatus.message ?? '';
        }
      } catch (exception, stacktrace) {
        if (isProgressBar) {
          print("isProgressBar 2 -----> stopLoader");
          AppComponentBase.getInstance().showProgressDialog(false);
        }
        await logError("$url in uploadMultipleImages method", exception,
            stacktrace, isBackground);
        throw Exception(exception);
      }
    } else {
      if (!isBackground) {
        CommonToast.getInstance()
            .displayToast(message: StringConstants.noInternetConnection);
      }
      throw StringConstants.noInternetConnection;
    }
  }

  Future shareReports(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? body,
      String? token,
      Encoding? encoding,
      bool isProgressBar = true,
      bool isBackground = false}) async {
    if (headers == null) {
      headers = getFormHeader();
    }
    token != null
        ? headers['Authorization'] = 'Bearer $token'
        : redirectToLoginPage();
    if (await AppComponentBase.getInstance()
        .getNetworkManager()
        .isConnected()) {
      AppComponentBase.getInstance().showProgressDialog(false);
      if (isProgressBar) {
        AppComponentBase.getInstance().showProgressDialog(true);
      }
      try {
        var uri = Uri.parse(url);

        var arrkey =
            body!.entries.map((MapEntry mapEntry) => mapEntry.key).toList();
        var arrvalue =
            body.entries.map((MapEntry mapEntry) => mapEntry.value).toList();
        Map<String, String> map = {};

        for (int ab = 0; ab < arrkey.length; ab++) {
          if (arrvalue[ab] != null && arrvalue[ab] is List) {
            for (int j = 0; j < arrvalue[ab].length; j++) {
              map['${arrkey[ab]}_${j + 1}'] = arrvalue[ab][j] ?? '';
              //  request.fields['${arrkey[ab]}_${j + 1}'] = arrvalue[ab][j] ?? '';
            }
          } else {
            map[arrkey[ab]] = arrvalue[ab];
            // request.fields[arrkey[i]] = arrvalue[i].toString();
          }
        }

        Response response = (await http.post(uri,
            headers: {'Authorization': 'Bearer $token'}, body: map));

        print("0-------------------- ${token}");
        print("0-------------------- ${response.body}");
        print("0-------------------- ${map}");

        if (isProgressBar) {
          AppComponentBase.getInstance().showProgressDialog(false);
        }
        var responseStatus =
            ResponseStatus.fromJson(json.decode(response.body));
        print("0-------------------- ${json.decode(response.body)}");
        if (response.statusCode == successResponse) {
          return responseStatus;
        } else if (responseStatus.status_code == 456) {
          redirectToLoginPage();
        } else {
          print(
              "--------------error 1-----------${responseStatus.message ?? ''}");
          // throw responseStatus.message ?? '';
        }

        //  final response = await http.Response.fromStream(await request.send());
      } catch (exception, stacktrace) {
        if (isProgressBar) {
          AppComponentBase.getInstance().showProgressDialog(false);
        }
        await logError(
            "$url in shareReports method", exception, stacktrace, isBackground);

        throw Exception(exception);
      }
    } else {
      if (!isBackground) {
        CommonToast.getInstance()
            .displayToast(message: StringConstants.noInternetConnection);
      }
      throw StringConstants.noInternetConnection;
    }
  }

  logError(String origin, Object exception, StackTrace stacktrace,
      bool isBackground) async {
    if (exception is String) {
      if (!isBackground) {
        CommonToast.getInstance().displayToast(message: exception);
      }
    } else {
      await Utils.sendErrorOnSlack(origin, "$exception", "$stacktrace");
      if (!isBackground) {
        CommonToast.getInstance()
            .displayToast(message: StringConstants.someThingWentWrong);
      }
    }
  }

  void logPrint({String? requestData, Response? response}) {
    if (response != null) {
      debugPrint(
          '--------------------------------------------------------------');
      debugPrint(
          'request url :${response.request?.method}  ${response.request?.url}');
      debugPrint('request header : ${response.request?.headers}');
      if (requestData != null) {
        debugPrint('request body : ${requestData.toString()}');
      }
      debugPrint(
          '--------------------------------------------------------------');
      debugPrint('response header : ${response.headers}');
      debugPrint('response statusCode : ${response.statusCode}');
      debugPrint('response body : ${response.body}');
    }
  }

  void redirectToLoginPage() {
    debugPrint("---- redirectToLoginPage");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppComponentBase.getInstance().clearData();
      AppComponentBase.getInstance().getSharedPreference().setUserDetail(null);
      AppComponentBase.getInstance()
          .getSharedPreference()
          .setSelectedVehicle(null);

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        RouteName.root,
        (route) => false,
        arguments: ItemArgument(data: {}),
      );
      CommonToast.getInstance().displayToast(message: StringConstants.noToken);
    });
  }

  void logout11() {
    debugPrint("---- logout11");
    LoginData loginData = AppComponentBase().getLoginData();
    logout12();
    AppComponentBase.getInstance().clearData();
    AppComponentBase.getInstance().getSharedPreference().setUserDetail(null);
    AppComponentBase.getInstance()
        .getSharedPreference()
        .setSelectedVehicle(null);
    AppComponentBase.getInstance().getSharedPreference().setUserName(loginData);
    Navigator.of(AppComponentBase.getInstance().currentContext,
            rootNavigator: true)
        .pushNamedAndRemoveUntil(RouteName.root, (route) => false,
            arguments: ItemArgument(data: {}));
  }

  void logout12() {
    debugPrint("---- logout12");
    AppComponentBase.getInstance()
        .getApiInterface()
        .getUserRepository()
        .logout()
        .then((value) {})
        .catchError((onError) {
      print(onError);
    });
  }
}
