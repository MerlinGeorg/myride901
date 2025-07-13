import 'dart:async';

import 'package:myride901/widgets/bloc_provider.dart';

class CreateNewPasswordBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;

  @override
  void dispose() {
    mainStreamController.close();
  }
}
