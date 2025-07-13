import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';

class CustomToast extends StatefulWidget {
  final Widget? child;
  final GlobalKey<CustomToastState>? key;

  CustomToast({@required this.child, @required this.key})
      : assert(child != null),
        assert(key != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomToastState();
  }
}

class CustomToastState extends State<CustomToast> {
  StreamController<bool> _showToastController = StreamController();
  AppThemeState _appTheme = AppThemeState();
  String message = "";

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        widget.child!,
        StreamBuilder<bool>(
          initialData: false,
          stream: _showToastController.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return AnimatedOpacity(
              opacity: snapshot.data ? 1 : 0,
              duration: Utils.animationDuration,
              child: Container(
                height: _appTheme.getResponsiveHeight(80),
                padding: EdgeInsets.symmetric(
                    horizontal: _appTheme.getResponsiveWidth(30)),
                decoration: BoxDecoration(
                    color: _appTheme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                    child: Text(message, style: _appTheme.tsLiteTextStyle)),
              ),
            );
          },
        ),
      ],
    );
  }

  showToast(String message) {
    this.message = message;
    _showToastController.sink.add(true);
    Future.delayed(Duration(milliseconds: 800), () {
      _showToastController.sink.add(false);
      this.message = "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    _showToastController.close();
  }
}
