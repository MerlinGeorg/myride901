import 'dart:io';
// import 'package:flutter/material.dart';
import 'package:myride901/models/reminder/reminder.dart';
import 'package:myride901/models/trip/trip.dart';
import 'package:myride901/models/response_status/response_status.dart';
import 'package:myride901/models/service_chat/service_chat.dart';
import 'package:myride901/models/service_permission/service_permission.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/models/service_provider/service_provider.dart';
import 'package:myride901/core/services/vehicle_service.dart';

class VehicleRepositoryImpl extends VehicleRepository {
  final _vehicleService = VehicleServices();

  Future<String> addTrip(
      {String? vehicleId,
      String? category,
      String? mileageUnit,
      String? startDate,
      String? endDate,
      String? days,
      String? hours,
      String? minutes,
      String? price,
      String? earnings,
      String? totalDistance,
      String? startLocation,
      String? endLocation,
      String? notes}) async {
    return await _vehicleService.addTrip({
      'vehicle_id': vehicleId,
      'category': category,
      'mileageUnit': mileageUnit,
      'start_date': startDate,
      'end_date': endDate,
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'total_distance': totalDistance,
      'price': price,
      'earnings': earnings,
      'start_location': startLocation,
      'end_location': endLocation,
      'notes': notes,
    });
  }

  Future<ResponseStatus> updateTrip(
      {String? vehicleId,
      String? category,
      String? mileageUnit,
      String? startDate,
      String? endDate,
      String? days,
      String? hours,
      String? minutes,
      String? price,
      String? earnings,
      String? totalDistance,
      String? startLocation,
      String? endLocation,
      String? notes,
      int? trip_id}) async {
    return await _vehicleService.updateTrip(trip_id, {
      'vehicle_id': vehicleId,
      'category': category,
      'mileageUnit': mileageUnit,
      'start_date': startDate,
      'end_date': endDate,
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'total_distance': totalDistance,
      'price': price,
      'earnings': earnings,
      'start_location': startLocation,
      'end_location': endLocation,
      'notes': notes,
      'trip_id': trip_id,
    });
  }

  Future<List<dynamic>> scanImage({
    String? base64image,
  }) async {
    return await _vehicleService.scanImage({
      'base64image': base64image,
    });
  }

  Future<List<dynamic>> fetchShops({
    String? latitude,
    String? longitude,
    String? radius,
  }) async {
    return await _vehicleService.fetchShops({
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
    });
  }

  Future<String> deleteTrip(Trip trip) async {
    return await _vehicleService.deleteTrip(trip);
  }

  Future<List<Trip>> getTrip() async {
    return await _vehicleService.getTrip();
  }

  Future<List<Reminder>> getReminder() async {
    return await _vehicleService.getReminder();
  }

  Future<String> deleteReminder(Reminder reminder) async {
    return await _vehicleService.deleteReminder(reminder);
  }

  Future<String> addProvider(
      {String? name,
      String? email,
      String? phone,
      String? address,
      String? city,
      String? postal_code,
      String? province,
      String? country,
      String? street}) async {
    return await _vehicleService.addProvider({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'postal_code': postal_code,
      'province': province,
      'country': country,
      'street': street,
    });
  }

  Future<ResponseStatus> updateProvider(
      {String? name,
      String? email,
      String? phone,
      String? address,
      String? city,
      String? postal_code,
      String? province,
      String? country,
      String? street,
      int? provider_id}) async {
    return await _vehicleService.updateProvider(provider_id, {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'postal_code': postal_code,
      'province': province,
      'country': country,
      'street': street,
      'provider_id': provider_id
    });
  }

  Future<String> deleteProvider(VehicleProvider serviceProvider) async {
    return await _vehicleService.deleteProvider(serviceProvider);
  }

  Future<List<VehicleProvider>> getProvider() async {
    return await _vehicleService.getProvider();
  }

  Future<List<dynamic>> getAuthShops({
    String? latitude,
    String? longitude,
  }) async {
    return await _vehicleService.getAuthShops({
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  Future<dynamic> addVehicle(
      {String nick_name = '',
      String vin_number = '',
      String license_plate = '',
      String make_company = '',
      String drive = '',
      String model = '',
      String body_trim = '',
      String year = '',
      String engine = '',
      String previous_date = '',
      String current_date = '',
      String previous_mileage = '',
      String current_mileage = '',
      String mileage_unit = '',
      String price = '',
      String selling_price = '',
      String notes = '',
      int type = 0,
      List<File>? feature_image,
      List<String>? image_dates,
      List<String>? image_type,
      String set_profile_index = ''}) async {
    return await _vehicleService.addVehicle({
      'nick_name': nick_name,
      'vin_number': vin_number,
      'license_plate': license_plate,
      'make_company': make_company,
      'drive': drive,
      'model': model,
      'body_trim': body_trim,
      'year': year,
      'engine': engine,
      'previous_date': previous_date,
      'current_date': current_date,
      'previous_mileage': previous_mileage,
      'current_mileage': current_mileage,
      'mileage_unit': mileage_unit,
      'price': price,
      'notes': notes,
      'set_profile_index': set_profile_index,
      'feature_image[]': feature_image ?? [],
      'image_dates': image_dates ?? [],
      'image_type': image_type ?? [],
    });
  }

  Future<dynamic> addVehicle2(
      {String nick_name = '',
      String vin_number = '',
      String license_plate = '',
      String make_company = '',
      String drive = '',
      String model = '',
      String body_trim = '',
      String year = '',
      String engine = '',
      String previous_date = '',
      String current_date = '',
      String previous_mileage = '',
      String current_mileage = '',
      String mileage_unit = '',
      String selling_price = '',
      String price = '',
      String notes = '',
      int type = 0,
      List<File>? feature_image,
      List<String>? image_dates,
      List<String>? image_type,
      String set_profile_index = ''}) async {
    return await _vehicleService.addVehicle({
      'nick_name': nick_name,
      'vin_number': vin_number,
      'license_plate': license_plate,
      'make_company': make_company,
      'drive': drive,
      'model': model,
      'body_trim': body_trim,
      'year': year,
      'engine': engine,
      'previous_date': previous_date,
      'current_date': current_date,
      'previous_mileage': previous_mileage,
      'current_mileage': current_mileage,
      'mileage_unit': mileage_unit,
      'price': price,
      'selling_price': selling_price,
      'notes': notes,
      'set_profile_index': set_profile_index,
      'feature_image[]': feature_image ?? [],
      'image_dates': image_dates ?? [],
      'image_type': image_type ?? [],
      'type': type
    });
  }

  Future<dynamic> searchbyVinNumber({String vin_number = ''}) async {
    return await _vehicleService.searchbyVinNumber({'vin_number': vin_number});
  }

  Future<ResponseStatus> updateVehicle({
    String nick_name = '',
    String vin_number = '',
    String license_plate = '',
    String make_company = '',
    String drive = '',
    String model = '',
    String body_trim = '',
    String year = '',
    String engine = '',
    String previous_date = '',
    String current_date = '',
    String previous_mileage = '',
    String current_mileage = '',
    String mileage_unit = '',
    String selling_price = '',
    String currency = '',
    String price = '',
    String notes = '',
    List<File>? feature_image,
    List<String>? image_dates,
    List<String>? image_type,
    String set_profile_index = '',
    String reset_as_profile_image = '',
    String delete_image = '',
    int? vehicle_id,
  }) async {
    return await _vehicleService.updateVehicle(vehicle_id, {
      'nick_name': nick_name,
      'vin_number': vin_number,
      'license_plate': license_plate,
      'make_company': make_company,
      'drive': drive,
      'model': model,
      'body_trim': body_trim,
      'year': year,
      'engine': engine,
      'previous_date': previous_date,
      'current_date': current_date,
      'previous_mileage': previous_mileage,
      'current_mileage': current_mileage,
      'mileage_unit': mileage_unit,
      'price': price,
      'currency': currency,
      'selling_price': selling_price,
      'notes': notes,
      'set_profile_index': set_profile_index,
      'feature_image[]': feature_image ?? [],
      'image_dates': image_dates ?? [],
      'image_type': image_type ?? [],
      'vehicle_id': vehicle_id,
      'delete_image': delete_image,
      'reset_as_profile_image': reset_as_profile_image
    });
  }

  Future<ResponseStatus> updateCurrency({
    String currency = '',
  }) async {
    return await _vehicleService.updateCurrency({
      'currency': currency,
    });
  }

  Future<ResponseStatus> shareVehicle({
    String email = '',
    String vehicle_id = '',
  }) async {
    return await _vehicleService.shareVehicle({
      'vehicle_id': vehicle_id,
      'email': email,
    });
  }

  Future<ResponseStatus> vehiclePdf({
    String email = '',
    String vehicle_id = '',
  }) async {
    return await _vehicleService.vehiclePdf({
      'vehicle_id': vehicle_id,
      'email': email,
    });
  }

  Future<ResponseStatus> checkEmail({
    String email = '',
  }) async {
    return await _vehicleService.checkEmail({
      'email': email,
    });
  }

  Future<List<VehicleProfile>> getVehicle() async {
    return await _vehicleService.getVehicle();
  }

  Future<List<VehicleProfile>> getShareVehicle(
      {bool isProgressBar = true}) async {
    return await _vehicleService.getShareVehicle(isProgressBar);
  }

  Future<String> deleteVehicle(VehicleProfile vehicleProfile) async {
    return await _vehicleService.deleteVehicle(vehicleProfile);
  }

  Future<List<VehicleService>> getVehicleService(
      {String? id, String? vehicleId, bool isProgressBar = true}) async {
    return await _vehicleService.getVehicleService(
        getVehicleService: {'vehicle_id': vehicleId},
        isProgressBar: isProgressBar,
        id: id);
  }

  Future<List<VehicleService>> getVehicleServiceByServiceId(
      {String? serviceId, String? vehicle_id, String? id}) async {
    return await _vehicleService.getVehicleServiceByServiceId(
        serviceId, vehicle_id, id);
  }

  Future<List<VehicleProfile>> getVehicleProfileById(
      {String? vehicleId, String? id}) async {
    return await _vehicleService.getVehicleProfileById(vehicleId, id);
  }

  Future<List<VehicleProvider>> getVehicleProviderByProviderId(
      {String? providerId, String? id}) async {
    return await _vehicleService.getVehicleProviderByProviderId(providerId, id);
  }

  Future<List<Trip>> getTripById({String? tripId, String? id}) async {
    return await _vehicleService.getTripById({'trip_id': tripId}, id);
  }

  Future<List<Reminder>> getReminderById(
      {String? reminderId, String? id}) async {
    return await _vehicleService
        .getReminderById({'reminder_id': reminderId}, id);
  }

  Future<String> addReminder({
    String? serviceId,
    String? userId,
    String? vehicleId,
    String? reminderName,
    String? reminderDate,
    String? timezone,
    String? notes,
  }) async {
    return await _vehicleService.addReminder({
      'service_id': serviceId,
      'user_id': userId,
      'vehicle_id': vehicleId,
      'reminder_name': reminderName,
      'reminder_date': reminderDate,
      'timezone': timezone,
      'notes': notes,
    });
  }

  Future<String> updateReminder(
      {String? serviceId,
      String? userId,
      String? vehicleId,
      String? reminderName,
      String? timezone,
      String? reminderDate,
      String? notes,
      int? reminderId}) async {
    return await _vehicleService.updateReminder(reminderId, {
      'service_id': serviceId,
      'user_id': userId,
      'vehicle_id': vehicleId,
      'reminder_name': reminderName,
      'reminder_date': reminderDate,
      'timezone': timezone,
      'notes': notes,
    });
  }

  Future<String> addServiceEvent(
      {String? vehicle_id,
      String? serviceProviderId,
      String? title,
      String? service_date,
      String? mileage,
      String? detail_1,
      String? detail_2,
      String? detail_3,
      List<File>? service_attachment,
      List<String>? category,
      List<String>? description,
      List<String>? price,
      List<String>? attachment_dates,
      List<String>? attachment_type,
      String? notes,
      String? avatar}) async {
    return await _vehicleService.addServiceEvent({
      'vehicle_id': vehicle_id,
      'title': title,
      'service_date': service_date,
      'service_provider_id': serviceProviderId,
      'mileage': mileage,
      'detail_1': detail_1,
      'detail_2': detail_2,
      'detail_3': detail_3,
      'service_attachment[]': service_attachment ?? [],
      'attachment_dates': attachment_dates ?? [],
      'attachment_type': attachment_type ?? [],
      'price': price ?? [],
      'category': category ?? [],
      'description': description ?? [],
      'notes': notes,
      'category_count': category == null ? '0' : '${category.length}',
      'avatar': avatar
    });
  }

  Future<String> updateServiceEvent(
      {String? vehicle_id,
      String? serviceProviderId,
      String? title,
      String? service_date,
      String? mileage,
      String? detail_1,
      String? detail_2,
      String? detail_3,
      String? delete_attachment,
      List<File>? service_attachment,
      List<String>? price,
      List<String>? category,
      List<String>? description,
      List<String>? attachment_dates,
      List<String>? attachment_type,
      String? notes,
      String? avatar,
      int? eventId}) async {
    return await _vehicleService.updateServiceEvent(eventId, {
      'vehicle_id': vehicle_id,
      'service_provider_id': serviceProviderId,
      'title': title,
      'service_date': service_date,
      'mileage': mileage,
      'detail_1': detail_1,
      'detail_2': detail_2,
      'detail_3': detail_3,
      'service_attachment[]': service_attachment ?? [],
      'attachment_dates': attachment_dates ?? [],
      'attachment_type': attachment_type ?? [],
      'price': price ?? [],
      'category': category ?? [],
      'description': description ?? [],
      'notes': notes,
      'delete_attachment': delete_attachment,
      'category_count': category == null ? '0' : '${category.length}',
      'avatar': avatar
    });
  }

  Future<dynamic> addWallet(
      {String wallet_key = '',
      String value = '',
      String vehicle_id = ''}) async {
    return await _vehicleService.addWallet(
        {'wallet_key': wallet_key, 'value': value, 'vehicle_id': vehicle_id});
  }

  Future<dynamic> updateWallet(
      {String wallet_key = '',
      String value = '',
      String wallet_id = '',
      int is_default = 0}) async {
    return await _vehicleService.updateWallet({
      'wallet_key': wallet_key,
      'value': value,
      'wallet_id': wallet_id,
      'is_default': is_default
    });
  }

  Future<dynamic> deleteWallet({String wallet_id = ''}) async {
    return await _vehicleService.deleteWallet({'wallet_id': wallet_id});
  }

  Future<dynamic> deleteWalletDefault({String id = ''}) async {
    return await _vehicleService.deleteWalletDefault({'id': id});
  }

  Future<String> deleteServiceEvent(VehicleService vehicleService) async {
    return await _vehicleService.deleteServiceEvent(vehicleService);
  }

  Future<List<ServicePermission>> getServicePermissionByServiceId(
      {String? serviceId}) async {
    return await _vehicleService
        .getServicePermissionByServiceId({'service_id': serviceId});
  }

  Future<dynamic> getServiceChatByServiceId(
      {String? serviceId, int? page}) async {
    return await _vehicleService.getServiceChatByServiceId(
        {'service_id': serviceId, 'per_page': 10, 'page': page});
  }

  Future<String> deleteServiceChat(String? id) async {
    return await _vehicleService.deleteServiceChat(id);
  }

  Future<ServiceChat> addServiceChat(
      {String? serviceId, String? message}) async {
    return await _vehicleService
        .addServiceChat({'service_id': serviceId, 'message': message});
  }

  Future<String> updateServicePermission(
      {String? service_id,
      String? vehicle_id,
      List<String>? email,
      List<String>? is_view,
      List<String>? is_edit,
      List<String>? is_check,
      String? is_guest,
      String? delete_email}) async {
    return await _vehicleService.updateServicePermission({
      'service_id': service_id,
      'vehicle_id': vehicle_id,
      'email': email ?? [],
      'is_view': is_view ?? [],
      'is_edit': is_edit ?? [],
      'email_count': email == null ? '0' : '${email.length}',
      'is_guest': is_guest,
      'is_check': is_check ?? [],
      'delete_email': delete_email
    });
  }

  Future<dynamic> getVehiclePermissionByVehicleId({String? vehicleId}) async {
    return await _vehicleService
        .getVehiclePermissionByVehicleId({'vehicle_id': vehicleId});
  }

  Future<String> updateVehiclePermission(
      {String? service_id,
      String? vehicle_id,
      List<String>? email,
      List<String>? is_view,
      List<String>? is_edit,
      List<String>? is_check,
      String? is_guest,
      String? delete_service_id,
      String is_one_mail = '0',
      List<String>? delete_email}) async {
    return await _vehicleService.updateVehiclePermission({
      'service_id': service_id,
      'vehicle_id': vehicle_id,
      'email': email ?? [],
      'is_view': is_view ?? [],
      'is_edit': is_edit ?? [],
      'email_count': email == null ? '0' : '${email.length}',
      'delete_email_count':
          delete_email == null ? '0' : '${delete_email.length}',
      'is_guest': is_guest,
      'is_check': is_check ?? [],
      'delete_service_id': delete_service_id,
      'delete_email': delete_email ?? [],
      'is_one_mail': is_one_mail
    });
  }

  Future<String> shareServiceEvent({
    String? service_id,
    List<String>? email,
    List<String>? is_check,
  }) async {
    return await _vehicleService.shareServiceEvent({
      'service_id': service_id,
      'email': email ?? [],
      'is_check': is_check ?? [],
      'email_count': email == null ? '0' : '${email.length}'
    });
  }

  Future<String> contactUs(
      {String? name, String? email, String? subject, String? message}) async {
    return await _vehicleService.contactUs(
        {"name": name, "email": email, "summary": subject, "message": message});
  }

  Future<dynamic> appVersion() async {
    return await _vehicleService.appVersion();
  }

  Future<dynamic> contactList({int? is_guest}) async {
    return await _vehicleService.contactList({'is_guest': is_guest});
  }

  Future<dynamic> searchUser({String? email}) async {
    return await _vehicleService.searchUser({'email': email});
  }

  Future<dynamic> addNewServicePermission(
      {String? service_id,
      String? vehicle_id,
      List<String>? email,
      List<String>? is_edit,
      String is_guest = '0',
      bool? isShareVehicle}) async {
    return await _vehicleService.addNewServicePermission({
      'service_id': service_id,
      'vehicle_id': vehicle_id,
      'email': email ?? [],
      'is_guest': is_guest,
      'email_count': email == null ? '0' : '${(email).length}',
      'is_edit': is_edit ?? []
    }, isShareVehicle ?? false);
  }

  Future<dynamic> shareAccidentReportPermission(
      {String? report_id,
      String? vehicle_id,
      List<String>? email,
      List<String>? is_edit,
      String is_guest = '1',
      bool? isShareVehicle}) async {
    return await _vehicleService.shareReportData({
      'report_id': report_id,
      'vehicle_id': vehicle_id,
      'email': email ?? [],
      'is_guest': is_guest,
      'email_count': email == null ? '0' : '${(email).length}',
      'is_edit': is_edit ?? []
    }, isShareVehicle ?? false);
  }

  Future<String> editNewServicePermission(
      {String? service_id,
      String? vehicle_id,
      List<String>? email,
      List<String>? is_edit,
      String? delete_email}) async {
    return await _vehicleService.editNewServicePermission({
      'service_id': service_id,
      'vehicle_id': vehicle_id,
      'email': email ?? [],
      'email_count': email == null ? '0' : '${(email).length}',
      'is_edit': is_edit ?? [],
      'delete_email': delete_email
    });
  }

  Future<String> editVehiclePermission(
      {String? vehicle_id,
      List<String>? email,
      List<String>? is_edit,
      String? delete_email}) async {
    return await _vehicleService.editVehiclePermission({
      'vehicle_id': vehicle_id,
      'email': email ?? [],
      'email_count': email == null ? '0' : '${(email).length}',
      'is_edit': is_edit ?? [],
      'delete_email': delete_email
    });
  }

  Future<dynamic> getSharedService() async {
    return await _vehicleService.getSharedService();
  }

  Future<String> revokeServicePermission({
    int? service_id,
  }) async {
    return await _vehicleService
        .revokeServicePermission({'service_id': service_id});
  }

  Future<String> revokeTimelinePermission({
    int? vehicle_id,
  }) async {
    return await _vehicleService
        .revokeTimelinePermission({'vehicle_id': vehicle_id});
  }

  Future<dynamic> getVehicleInformation({
    String? type,
    String? screen,
    String? model,
    String? year,
    String? make,
  }) async {
    return await _vehicleService.getVehicleInformation({
      'type': type,
      'screen': screen,
      'year': year,
      'model': model,
      'make': make
    });
  }

  Future<dynamic> getAdditionalInformation({
    String? year,
    String? makes,
    String? models,
    String? trim,
    String? transmissions,
    String? screen,
  }) async {
    return await _vehicleService.getAdditionalInformation(
        {'year': year, 'makes': makes, 'models': models, 'screen': screen});
  }

  Future<dynamic> getBlog({int? offset}) async {
    return await _vehicleService.getBlog({'offset': offset, 'per_page': 10});
  }

  Future<dynamic> serviceEventsByVin(
      {String? current_mileage, String? vin_number}) async {
    return await _vehicleService.serviceEventsByVin(
        {'vin_number': vin_number, 'current_mileage': current_mileage});
  }

  Future<dynamic> recallByVin({String vin_number = ''}) async {
    return await _vehicleService.recallByVin({'vin_number': vin_number});
  }

  Future<dynamic> getAutocomplete({String params = ''}) async {
    return await _vehicleService.getAutocomplete(params);
  }

  Future<dynamic> getProviderAddress({String params = ''}) async {
    return await _vehicleService.getProviderAddress(params);
  }

  Future<dynamic> getDirections(
      {String start_location = '',
      String end_location = '',
      String unit = ''}) async {
    return await _vehicleService.getDirections(
        start_location, end_location, unit);
  }

  Future<dynamic> getBlogDetail({int? id}) async {
    return await _vehicleService.getBlogDetail({'id': id});
  }

  Future<dynamic> appleVerify(
      {String? receiptData,
      bool? isUpgrade,
      String? planDuration,
      String? transactionId}) async {
    return await _vehicleService.appleVerify({
      'receiptData': receiptData,
      'isUpgrade': isUpgrade,
      'planDuration': planDuration,
      'transactionId': transactionId
    });
  }
}

abstract class VehicleRepository {
  // Future<LoginData> login();
  // Future<String> signUp();
  // Future<String> changePassword();
}
