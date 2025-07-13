import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myride901/core/themes/app_theme.dart';

class MyRideCheckBox extends StatefulWidget {
  final bool? isChecked;
  final Size? size;
  final Function(bool)? onCheckClick;

  const MyRideCheckBox(
      {Key? key, this.isChecked = true, this.size, this.onCheckClick})
      : super(key: key);

  @override
  _MyRideCheckBoxState createState() => _MyRideCheckBoxState();
}

class _MyRideCheckBoxState extends State<MyRideCheckBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: InkWell(
      onTap: () {
        setState(() {
          widget.onCheckClick!.call(!widget.isChecked!);
        });
      },
      child: Container(
          height: widget.size!.height,
          width: widget.size!.width,
          decoration: BoxDecoration(
            color: widget.isChecked!
                ? AppTheme.of(context).primaryColor
                : Colors.white,
            border: Border.all(
                color: widget.isChecked!
                    ? AppTheme.of(context).primaryColor
                    : Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: widget.isChecked!
              ? Icon(
                  Icons.check,
                  size: widget.size!.width / 2,
                  color: Colors.white,
                )
              : Offstage()),
    ));
  }
}
