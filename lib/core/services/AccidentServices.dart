import 'dart:convert';

import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/response_status/response_status.dart';
import 'package:myride901/core/services/api_client/api_client.dart';

class AccidentServices extends ApiClient {
  Future<dynamic> addAccidentReport(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      String body = jsonEncode(data).toString();

      print("++++ in AccidentServices addAccidentReport ${body}");

      var response = await posts(addAccidentReportUrl, token: token, body: body)
          as ResponseStatus;

      return response.result;
    } catch (exception) {
      print("++++ in exception ${exception}");
      throw Exception(exception.toString());
    }
  }

  Future<String> addWitness(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;
      String body = jsonEncode(data).toString();

      print("++++ in AccidentServices addWitness ${body}");

      var response = await posts(addWitnessUrl, token: token, body: body)
          as ResponseStatus;

      return response.message ?? '';
    } catch (exception) {
      print("++++ in exception ${exception}");
      throw Exception(exception.toString());
    }
  }

  Future<String> addAttachments(dynamic data) async {
    try {
      var token = AppComponentBase.getInstance().getLoginData().token;

      print("++++ in AccidentServices addAttachments ");
      var response = await uploadMultipleImages(addARAttacementsUrl,
          body: data, token: token) as ResponseStatus;
      return response.message ?? '';
    } catch (exception) {
      print("++++ in exception ${exception}");
      throw Exception(exception.toString());
    }
  }
}
