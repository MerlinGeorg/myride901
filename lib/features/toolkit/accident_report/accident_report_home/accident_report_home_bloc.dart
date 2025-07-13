import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class AccidentReportHomeBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMail = TextEditingController();
  TextEditingController txtSubject = TextEditingController();
  TextEditingController txtMessage = TextEditingController();

  @override
  void dispose() {
    mainStreamController.close();
  }
}
