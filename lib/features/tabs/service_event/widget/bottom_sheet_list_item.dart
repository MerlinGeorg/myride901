import 'package:flutter/material.dart';
import 'package:myride901/core/themes/app_theme.dart';

class BottomListItem extends StatelessWidget {
  final String? name;
  final Function? onTap;

  const BottomListItem({Key? key, this.onTap, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: InkWell(
        onTap: () {
          onTap!();
        },
        child: Text(
          name ?? '',
          style: TextStyle(
              color: AppTheme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
