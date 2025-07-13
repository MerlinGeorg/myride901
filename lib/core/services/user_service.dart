import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/services/shared_preference.dart';
import 'package:myride901/models/request/changePasswordRequest/changePasswordRequest.dart';
import 'package:myride901/models/request/forgotPasswordRequest/forgotPasswordRequest.dart';
import 'package:myride901/models/request/loginRequest/loginRequest.dart';
import 'package:myride901/models/request/signupRequest/signupRequest.dart';
import 'package:myride901/models/response_status/response_status.dart';
import 'package:myride901/models/login_data/login_data.dart';
import 'package:myride901/core/services/api_client/api_client.dart';
import 'package:android_id/android_id.dart';

class UserServices extends ApiClient {
  Future<LoginData> login(LoginRequest loginRequest) async {
    try {
      String body = jsonEncode(loginRequest.toJson()).toString();
      var response =
          await postWithoutToken(loginUrl, body: body) as ResponseStatus;
      return LoginData.fromJson(response.result);
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<LoginData> loginDetail() async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await gets(
          userUrl +
              '/${AppComponentBase.getInstance().getLoginData().user?.id.toString()}',
          isProgressBar: false,
          isBackground: true,
          token: token) as ResponseStatus;

      return LoginData.fromJson({'user': response.result, 'token': token});
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> deleteAccount() async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      var response = await posts(deleteAccountUrl,
          token: token,
          isProgressBar: false,
          isBackground: true) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<LoginData> loginWithGoogle(dynamic data) async {
    try {
      String body = jsonEncode(data).toString();
      var response = await postWithoutToken(loginWithGoogleUrl, body: body)
          as ResponseStatus;
      return LoginData.fromJson(response.result);
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<LoginData> loginWithApple(dynamic data) async {
    try {
      String body = jsonEncode(data).toString();
      var response = await postWithoutToken(loginWithAppleUrl, body: body)
          as ResponseStatus;
      return LoginData.fromJson(response.result);
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<ResponseStatus> signup(SignupRequest signupRequest) async {
    try {
      String body = jsonEncode(signupRequest.toJson()).toString();
      var response =
          await postWithoutToken(signupUrl, body: body) as ResponseStatus;
      return response;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> changePassword(
      ChangePasswordRequest changePasswordRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      String body = jsonEncode(changePasswordRequest.toJson()).toString();
      var response = await posts(changePasswordUrl, body: body, token: token)
          as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  /*Future<String> userUpdate(UserUpdateRequest userUpdateRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      String body = jsonEncode(userUpdateRequest.toJson());
      var id =
          AppComponentBase.getInstance().getLoginData().user!.id.toString();
      var response = await puts('$userUrl/$id', body: body, token: token)
          as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }*/

  Future<String> forgotPassword(
      ForgotPasswordRequest forgotPasswordRequest) async {
    try {
      String body = jsonEncode(forgotPasswordRequest.toJson()).toString();
      var response = await postWithoutToken(forgotPasswordUrl, body: body)
          as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> acknowledgementInApp(
      String productId,
      String token,
      String orderId,
      String freeTrialPeriodAndroid,
      String transactionId) async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};
      final msg = jsonEncode({
        "item_id": productId,
        "purchase_token": token,
        "order_id": orderId,
        'free_trial_period': freeTrialPeriodAndroid,
        'transactionId': transactionId
      });
      var userAppToken = AppComponentBase.getInstance().getLoginData().token;
      var response = await posts(acknowledgeInApp,
          token: userAppToken, body: msg, headers: headers) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> startTrialPeriod() async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      var response = await posts(startTrialUrl,
          token: token,
          isProgressBar: false,
          isBackground: true) as ResponseStatus;

      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> updateTrialStatus(bool isActivated) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      var response = await posts(
        updateTrialStatusUrl,
        token: token,
        isProgressBar: false,
        isBackground: true,
        body: jsonEncode({'isActivated': isActivated}),
      ) as ResponseStatus;

      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> resetUserSubscriptionInfos() async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      var response = await posts(resetSubscriptionUrl,
          token: token,
          isProgressBar: false,
          isBackground: true) as ResponseStatus;

      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> resendCodePassword(
      ForgotPasswordRequest forgotPasswordRequest) async {
    try {
      String body = jsonEncode(forgotPasswordRequest.toJson()).toString();
      var response =
          await postWithoutToken(resendCodeUrl, body: body) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> verifyCodePassword(
      ForgotPasswordRequest forgotPasswordRequest) async {
    try {
      String body = jsonEncode(forgotPasswordRequest.toJson()).toString();
      var response =
          await postWithoutToken(verifyCodeUrl, body: body) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> updateToken(String deviceToken, int device_type) async {
    try {
      var device_id = await _getId();
      var token = AppComponentBase.getInstance().getLoginData().token;

      String body = jsonEncode({
        'device_token': deviceToken,
        'device_id': device_id,
        'device_type': device_type
      }).toString();
      var response = await posts(updateDevicetokenUrl, body: body, token: token)
          as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return AndroidId().getId(); // unique ID on Android
    }
  }

  Future<String> logout(int device_type) async {
    try {
      var device_id = await _getId();
      var token = AppComponentBase.getInstance().getLoginData().token;

      String body =
          jsonEncode({'device_id': device_id, 'device_type': device_type})
              .toString();
      var response = await posts(logoutUrl,
          body: body,
          token: token,
          isProgressBar: false,
          isBackground: true) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<dynamic>> userList() async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await gets(userListUrl, token: token) as ResponseStatus;
      return List<dynamic>.from(response.result.where((i) => true));
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> updateProfile(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      var response =
          await uploadMultipleImages(updateProfileUrl, token: token, body: data)
              as ResponseStatus;
      var value = LoginData.fromJson({'user': response.result, 'token': token});
      SharedPreference pref =
          AppComponentBase.getInstance().getSharedPreference();
      pref.setUserDetail(value);
      pref.setUserName(value);
      AppComponentBase.getInstance().setLoginData(value);
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<ResponseStatus> changeDateFormat(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(changeDateFormatUrl,
          body: data, token: token) as ResponseStatus;
      return response;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }
}
