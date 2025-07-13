import 'package:myride901/repository/accident_repository.dart';
import 'package:myride901/repository/user_repository.dart';
import 'package:myride901/repository/vehicle_repository.dart';

///
/// This class provides all API related repositories
///
class ApiInterface implements ApiInterfaceService {
  @override
  UserRepositoryImpl getUserRepository() {
    return UserRepositoryImpl();
  }

  @override
  VehicleRepositoryImpl getVehicleRepository() {
    return VehicleRepositoryImpl();
  }

  @override
  AccidentReportImpl getAccidentReportRepository() {
    return AccidentReportImpl();
  }
}

abstract class ApiInterfaceService {
  UserRepositoryImpl getUserRepository();
  VehicleRepositoryImpl getVehicleRepository();
  AccidentReportImpl getAccidentReportRepository();
}
