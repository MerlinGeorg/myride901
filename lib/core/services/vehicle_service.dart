import 'dart:convert';

import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/reminder/reminder.dart';
import 'package:myride901/models/response_status/response_status.dart';
import 'package:myride901/models/service_chat/service_chat.dart';
import 'package:myride901/models/service_permission/service_permission.dart';
import 'package:myride901/models/trip/trip.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/models/service_provider/service_provider.dart';
import 'package:myride901/core/services/api_client/api_client.dart';

class VehicleServices extends ApiClient {
  Future<String> addProvider(dynamic addProviderRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(providerURL,
          body: addProviderRequest, token: token) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> addTrip(dynamic addTripRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(tripUrl,
          body: addTripRequest, token: token) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<Trip>> getTrip() async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await gets(tripUrl, token: token) as ResponseStatus;
      List<Trip> vp = [];
      for (var a in response.result) {
        vp.add(Trip.fromJson(a));
      }
      return vp;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<ResponseStatus> updateTrip(int? tripId, dynamic addTripRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages('$tripUrl/$tripId',
          body: addTripRequest, token: token) as ResponseStatus;
      return response;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> deleteTrip(Trip trip) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response =
          await deletes('$tripUrl/${trip.id}', token: token) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<String>> getAutocomplete(String params) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await gets(getAddressAutocompleteUrl + '?input=${params}',
          token: token) as ResponseStatus;

      List<dynamic> predictions = response.result['predictions'];

      List<String> suggestions = predictions.map<String>((prediction) {
        return prediction['description'] as String;
      }).toList();

      return suggestions;
    } catch (exception) {
      print('Exception: $exception');
      throw Exception('Error occurred while getting autocomplete');
    }
  }

  Future<List<dynamic>> scanImage(dynamic base64image) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response =
          await uploadMultipleImages(scanUrl, body: base64image, token: token)
              as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<dynamic>> fetchShops(dynamic coordinates) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(fetchShopsUrl,
          body: coordinates, token: token) as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<dynamic>> getAuthShops(dynamic coordinates) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(authorizedShopsUrl,
          body: coordinates, token: token) as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<Map<String, List<String>>> getProviderAddress(String params) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response =
          await gets(getProvidersAddressUrl + '?input=${params}', token: token)
              as ResponseStatus;

      List<dynamic> predictions = response.result['predictions'];

      Map<String, List<String>> suggestions = {
        'description': [],
        'street': [],
        'city': [],
        'postal_code': [],
        'province': [],
        'country': [],
      };

      predictions.forEach((prediction) {
        suggestions['description']?.add(prediction['description'] as String);
        suggestions['street']?.add(prediction['street'] as String);
        suggestions['city']?.add(prediction['city'] as String);
        suggestions['postal_code']?.add(prediction['postal_code'] as String);
        suggestions['province']?.add(prediction['province'] as String);
        suggestions['country']?.add(prediction['country'] as String);
      });

      return suggestions;
    } catch (exception) {
      print('Exception: $exception');
      throw Exception('Error occurred while getting autocomplete');
    }
  }

  Future<Map<String, List<String>>> getDirections(
      String start_location, String end_location, String unit) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await gets(
          getDirectionsUrl +
              '?start_location=$start_location&end_location=$end_location&unit=$unit',
          token: token) as ResponseStatus;

      List<dynamic> routes = response.result['routes'];

      List<String> distances = routes.map<String>((route) {
        return route['distance'].toString();
      }).toList();

      List<String> durations = routes.map<String>((route) {
        return route['duration'].toString();
      }).toList();

      List<String> screenshotUrls = routes.map<String>((route) {
        return route['screenshot_url'].toString();
      }).toList();

      List<String> linkUrl = routes.map<String>((route) {
        return route['google_maps_url'].toString();
      }).toList();

      return {
        'distances': distances,
        'durations': durations,
        'screenshotUrls': screenshotUrls,
        'linkUrl': linkUrl
      };
    } catch (exception) {
      print('Exception: $exception');
      throw Exception('Error occurred while getting directions');
    }
  }

  Future<dynamic> recallByVin(dynamic addVehicleRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(recallByVinUrl,
          body: addVehicleRequest, token: token) as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<VehicleProvider>> getProvider() async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await gets(providerURL, token: token) as ResponseStatus;
      List<VehicleProvider> vp = [];
      for (var a in response.result) {
        vp.add(VehicleProvider.fromJson(a));
      }
      return vp;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> addVehicle(dynamic addVehicleRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(vehiclesUrl,
          body: addVehicleRequest, token: token) as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> searchbyVinNumber(dynamic addVehicleRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(searchbyVinNumberUrl,
          body: addVehicleRequest, token: token) as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<ResponseStatus> updateVehicle(
      int? vehicelId, dynamic addVehicleRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages('$vehiclesUrl/$vehicelId',
          body: addVehicleRequest, token: token) as ResponseStatus;
      return response;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<ResponseStatus> updateCurrency(dynamic addVehicleRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(currencyUrl,
          body: addVehicleRequest, token: token) as ResponseStatus;
      return response;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<ResponseStatus> updateProvider(
      int? providerId, dynamic updateProviderRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages('$providerURL/$providerId',
          body: updateProviderRequest, token: token) as ResponseStatus;
      return response;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> deleteProvider(VehicleProvider serviceProvider) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response =
          await deletes('$providerURL/${serviceProvider.id}', token: token)
              as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<ResponseStatus> shareVehicle(dynamic addVehicleRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(shareVehicleUrl,
          body: addVehicleRequest, token: token) as ResponseStatus;
      return response;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<ResponseStatus> checkEmail(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response =
          await uploadMultipleImages(checkEmailUrl, body: data, token: token)
              as ResponseStatus;
      return response;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<ResponseStatus> vehiclePdf(dynamic addVehicleRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(getVehicleCopy,
          body: addVehicleRequest, token: token) as ResponseStatus;
      return response;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<VehicleProfile>> getVehicle() async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await gets(vehiclesUrl, token: token) as ResponseStatus;
      List<VehicleProfile> vp = [];
      for (var a in response.result) {
        vp.add(VehicleProfile.fromJson(a));
      }
      return vp;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> addWallet(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      String body = jsonEncode(data).toString();

      var response =
          await posts(addWalletUrl, token: token, body: body) as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> updateWallet(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      String body = jsonEncode(data).toString();
      var response = await posts(updateWalletUrl, token: token, body: body)
          as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> deleteWallet(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      String body = jsonEncode(data).toString();
      var response = await posts(deleteWalletUrl, token: token, body: body)
          as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> deleteWalletDefault(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      String body = jsonEncode(data).toString();
      var response =
          await posts(deleteWalletDefaultUrl, token: token, body: body)
              as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<VehicleProfile>> getShareVehicle(bool isProgressBar) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await gets(getShareVehicleUrl,
          token: token,
          isProgressBar: isProgressBar,
          isBackground: !isProgressBar) as ResponseStatus;
      List<VehicleProfile> vp = [];

      for (var a in response.result) {
        vp.add(VehicleProfile.fromJson(a));
      }
      return vp;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> deleteVehicle(VehicleProfile vehicleProfile) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response =
          await deletes('$vehiclesUrl/${vehicleProfile.id}', token: token)
              as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<VehicleService>> getVehicleService(
      {dynamic getVehicleService,
      bool isProgressBar = true,
      String? id}) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      var response = await gets('$eventUrl?vehicle_id=$id',
          token: token,
          isProgressBar: isProgressBar,
          isBackground: !isProgressBar) as ResponseStatus;
      List<VehicleService> vp = [];
      for (var a in response.result) {
        vp.add(VehicleService.fromJson(a));
      }
      return vp;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<VehicleService>> getVehicleServiceByServiceId(
      dynamic getVehicleService, String? vehicle_id, String? id) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      var response =
          await gets('$eventUrl?vehicle_id=$vehicle_id', token: token)
              as ResponseStatus;
      List<VehicleService> vp = [];
      for (var a in response.result) {
        vp.add(VehicleService.fromJson(a));
      }
      if (id != null) {
        vp = vp.where((event) => event.id == int.parse(id)).toList();
      }
      return vp;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<VehicleProfile>> getVehicleProfileById(
      dynamic getVehicleProfile, String? id) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      var response = await gets(vehiclesUrl, token: token) as ResponseStatus;
      List<VehicleProfile> vp = [];
      for (var a in response.result) {
        vp.add(VehicleProfile.fromJson(a));
      }
      if (id != null) {
        vp = vp.where((vehicle) => vehicle.id == int.parse(id)).toList();
      }
      return vp;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<Trip>> getTripById(dynamic getVehicleService, String? id) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      var response = await gets(tripUrl, token: token) as ResponseStatus;
      List<Trip> vp = [];
      for (var a in response.result) {
        vp.add(Trip.fromJson(a));
      }

      if (id != null) {
        vp = vp.where((trip) => trip.id == int.parse(id)).toList();
      }
      return vp;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<VehicleProvider>> getVehicleProviderByProviderId(
      dynamic getVehicleService, String? id) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      var response = await gets(providerURL, token: token) as ResponseStatus;
      List<VehicleProvider> vp = [];
      for (var a in response.result) {
        vp.add(VehicleProvider.fromJson(a));
      }
      if (id != null) {
        vp = vp.where((provider) => provider.id == int.parse(id)).toList();
      }
      return vp;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> addServiceEvent(dynamic addVehicleRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(eventUrl,
          body: addVehicleRequest, token: token) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> updateServiceEvent(
      int? eventId, dynamic addVehicleRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages('$eventUrl/$eventId',
          body: addVehicleRequest, token: token) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> deleteServiceEvent(VehicleService vehicleService) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response =
          await deletes('$eventUrl/${vehicleService.id}', token: token)
              as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<ServicePermission>> getServicePermissionByServiceId(
      dynamic getVehicleService) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      String body = jsonEncode(getVehicleService).toString();

      var response =
          await posts(getServicePermissionUrl, token: token, body: body)
              as ResponseStatus;
      List<ServicePermission> vp = [];
      for (var a in (response.result ?? {})['service_permission'] ?? []) {
        vp.add(ServicePermission.fromJson(a));
      }
      return vp;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> getServiceChatByServiceId(dynamic getVehicleService) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      String body = jsonEncode(getVehicleService).toString();

      var response = await posts(getServiceChatUrl,
          token: token,
          body: body,
          isProgressBar: false,
          isBackground: true) as ResponseStatus;
      return (response.result ?? []);
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> deleteServiceChat(String? id) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response =
          await deletes('$chatsUrl/$id', token: token) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<ServiceChat> addServiceChat(dynamic serviceChat) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      String body = jsonEncode(serviceChat).toString();

      var response = await posts(addServiceChatUrl, body: body, token: token)
          as ResponseStatus;
      print(response.result);
      return ServiceChat.fromJson(response.result);
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> updateServicePermission(dynamic servicePermission) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(addServicePermissionUrl,
          body: servicePermission, token: token) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> getVehiclePermissionByVehicleId(
      dynamic getVehicleProfile) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      String body = jsonEncode(getVehicleProfile).toString();

      var response =
          await posts(getVehiclePermissionUrl, token: token, body: body)
              as ResponseStatus;

      return response.result ?? {};
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> updateVehiclePermission(dynamic servicePermission) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(addVehiclePermissionUrl,
          body: servicePermission, token: token) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> shareServiceEvent(dynamic servicePermission) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(shareServiceEventUrl,
          body: servicePermission, token: token) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> contactUs(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      String body = jsonEncode(data).toString();

      var response =
          await posts(contactUsUrl, token: token, body: body) as ResponseStatus;

      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> appVersion() async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      var response = await gets(appVersionUrl, token: token) as ResponseStatus;

      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> contactList(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      String body = jsonEncode(data).toString();

      var response = await posts(contactListUrl, token: token, body: body)
          as ResponseStatus;

      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> searchUser(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      String body = jsonEncode(data).toString();

      var response = await posts(searchUserUrl, token: token, body: body)
          as ResponseStatus;

      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> addNewServicePermission(
      dynamic data, bool isShareVehicle) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(
          isShareVehicle
              ? addNewVehiclePermissionUrl
              : addNewServicePermissionUrl,
          token: token,
          body: data) as ResponseStatus;

      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> shareReportData(dynamic data, bool isShareVehicle) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await shareReports(reportApi, token: token, body: data)
          as ResponseStatus;

      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> editNewServicePermission(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(editNewServicePermissionUrl,
          token: token, body: data) as ResponseStatus;

      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> editVehiclePermission(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(editVehiclePermissionUrl,
          token: token, body: data) as ResponseStatus;

      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> getSharedService() async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response =
          await gets(getSharedServiceUrl, token: token) as ResponseStatus;

      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> revokeServicePermission(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      String body = jsonEncode(data).toString();

      var response =
          await posts(revokeServicePermissionUrl, token: token, body: body)
              as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> revokeTimelinePermission(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      String body = jsonEncode(data).toString();

      var response =
          await posts(revokeTimelinePermissionUrl, token: token, body: body)
              as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> getVehicleInformation(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      String body = jsonEncode(data).toString();

      var response =
          await posts(getVehicleInformationUrl, token: token, body: body)
              as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> getAdditionalInformation(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      String body = jsonEncode(data).toString();

      var response =
          await posts(getAdditionalInformationUrl, token: token, body: body)
              as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> getBlog(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      String body = jsonEncode(data).toString();

      var response =
          await posts(getBlogUrl, token: token, body: body) as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> serviceEventsByVin(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      String body = jsonEncode(data).toString();

      var response =
          await posts(serviceEventsByVinUrl, token: token, body: body)
              as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> getBlogDetail(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      String body = jsonEncode(data).toString();

      var response = await posts(getBlogDetailUrl, token: token, body: body)
          as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<dynamic> appleVerify(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      String body = jsonEncode(data).toString();

      var response = await posts(appleVerifyUrl, token: token, body: body)
          as ResponseStatus;
      return response.result;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> addReminder(dynamic addVehicleRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages(remindersUrl,
          body: addVehicleRequest, token: token) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> updateReminder(
      int? reminderId, dynamic addVehicleRequest) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await uploadMultipleImages('$remindersUrl/$reminderId',
          body: addVehicleRequest, token: token) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<String> deleteReminder(Reminder reminder) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await deletes('$remindersUrl/${reminder.id}', token: token)
          as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<Reminder>> getReminder() async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      var response = await gets(remindersUrl, token: token) as ResponseStatus;
      List<Reminder> vp = [];
      for (var a in response.result) {
        vp.add(Reminder.fromJson(a));
      }
      return vp;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<Reminder>> getReminderById(
      dynamic getVehicleService, String? id) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      var response = await gets(remindersUrl, token: token) as ResponseStatus;
      List<Reminder> vp = [];
      for (var a in response.result) {
        vp.add(Reminder.fromJson(a));
      }

      if (id != null) {
        vp = vp.where((reminder) => reminder.id == int.parse(id)).toList();
      }
      return vp;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }
}
