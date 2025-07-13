import 'dart:async';

import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class OutputBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  VehicleProfile? vehicle;

  @override
  void dispose() {
    mainStreamController.close();
  }
}
