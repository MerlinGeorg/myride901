import 'dart:io';

import 'package:myride901/models/request/changePasswordRequest/changePasswordRequest.dart';
import 'package:myride901/models/request/forgotPasswordRequest/forgotPasswordRequest.dart';
import 'package:myride901/models/request/loginRequest/loginRequest.dart';
import 'package:myride901/models/request/signupRequest/signupRequest.dart';
import 'package:myride901/models/login_data/login_data.dart';
import 'package:myride901/models/response_status/response_status.dart';
import 'package:myride901/core/services/user_service.dart';

class UserRepositoryImpl extends UserRepository {
  final _userService = UserServices();

  Future<LoginData> login({String? email, String? password}) async {
    LoginRequest loginRequest =
        LoginRequest.fromJson({'email': email, 'password': password});
    return _userService.login(loginRequest);
  }

  Future<LoginData> loginDetail() async {
    return _userService.loginDetail();
  }

  Future<LoginData> loginWithGoogle(
      {String? email,
      String? google_profile_id,
      String? first_name,
      String? last_name}) async {
    return _userService.loginWithGoogle({
      "email": email,
      "google_profile_id": google_profile_id,
      "first_name": first_name,
      "last_name": last_name
    });
  }

  Future<LoginData> loginWithApple(
      {String? email,
      String? apple_profile_id,
      String? first_name,
      String? last_name}) async {
    return _userService.loginWithApple({
      "email": email,
      "apple_profile_id": apple_profile_id,
      "first_name": first_name,
      "last_name": last_name
    });
  }

  Future<ResponseStatus> signUp(
      {String? email,
      String? password,
      String? first_name,
      String? last_name}) async {
    SignupRequest signupRequest = SignupRequest.fromJson({
      'email': email,
      'password': password,
      'last_name': last_name,
      'first_name': first_name
    });
    return _userService.signup(signupRequest);
  }

  Future<String> changePassword(
      {String? old_password,
      String? password,
      String? password_confirm}) async {
    ChangePasswordRequest changePasswordRequest =
        ChangePasswordRequest.fromJson({
      'old_password': old_password,
      'password': password,
      'password_confirm': password_confirm
    });
    return _userService.changePassword(changePasswordRequest);
  }

  /*Future<String> userUpdate({String? first_name, String? last_name}) async {
    UserUpdateRequest userUpdateRequest = UserUpdateRequest.fromJson(
        {'last_name': last_name, 'first_name': first_name});
    return _userService.userUpdate(userUpdateRequest);
  }*/

  Future<String> forgotPassword({String? email}) async {
    ForgotPasswordRequest forgotPasswordRequest =
        ForgotPasswordRequest.fromJson({'email': email});
    return _userService.forgotPassword(forgotPasswordRequest);
  }

  Future<String> acknowledgeAPI(
      {String? id,
      String? token,
      String? orderId,
      String? freeTrialPeriodAndroid,
      String? transactionId}) async {
    return _userService.acknowledgementInApp(id ?? '', token ?? '',
        orderId ?? '', freeTrialPeriodAndroid ?? '', transactionId ?? '');
  }

  Future<String> startTrialPeriod() async {
    return _userService.startTrialPeriod();
  }

  Future<String> updateTrialStatus(bool isActivated) async {
    return _userService.updateTrialStatus(isActivated);
  }

  Future<String> resetUserSubscriptionInfos() async {
    return _userService.resetUserSubscriptionInfos();
  }

  Future<String> resendCodePassword({String? email}) async {
    ForgotPasswordRequest forgotPasswordRequest =
        ForgotPasswordRequest.fromJson({'email': email});
    return _userService.resendCodePassword(forgotPasswordRequest);
  }

  Future<String> verifyCodePassword({String? email, String? code}) async {
    ForgotPasswordRequest forgotPasswordRequest =
        ForgotPasswordRequest.fromJson({'email': email, 'code': code});
    return _userService.verifyCodePassword(forgotPasswordRequest);
  }

  Future<String> updateToken({String? deviceToken}) async {
    return _userService.updateToken(
        deviceToken ?? '', Platform.isAndroid ? 1 : 2);
  }

  Future<String> logout() async {
    return _userService.logout(Platform.isAndroid ? 1 : 2);
  }

  Future<String> deleteAccount() async {
    return _userService.deleteAccount();
  }

  Future<List<dynamic>> userList() async {
    return _userService.userList();
  }

  Future<String> updateProfile(
      {String? first_name,
      String? last_name,
      String? email,
      File? profile_image}) async {
    return _userService.updateProfile({
      'last_name': last_name,
      'first_name': first_name,
      'profile_image': profile_image ?? '',
      'email': email
    });
  }

  Future<ResponseStatus> changeDateFormat({
    String date_format = '',
  }) async {
    return await _userService.changeDateFormat({
      'date_format': date_format,
    });
  }
}

abstract class UserRepository {}
