import 'package:myride901/core/services/AccidentServices.dart';

class AccidentReportImpl extends AccidentReportRepository {
  final _accidentService = AccidentServices();

  // @override
  Future<dynamic> addAccidentReport(dynamic body) async {
    // print("++++ in addAccidentReport");
    return _accidentService.addAccidentReport(body);
  }

  Future<dynamic> addWitness(dynamic body) async {
    // print("++++ in addWitness");
    return _accidentService.addWitness(body);
  }

  Future<dynamic> addAttachments(dynamic body) async {
    print("++++ in addAttachments");
    return _accidentService.addAttachments(body);
  }
}

abstract class AccidentReportRepository {}
