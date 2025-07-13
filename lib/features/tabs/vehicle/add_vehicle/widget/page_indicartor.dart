import 'package:flutter/material.dart';
import 'package:myride901/core/themes/app_theme.dart';

class PageIndication extends StatelessWidget {
  final bool? isSelected;

  const PageIndication({Key? key, this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppTheme.of(context)
            .primaryColor
            .withOpacity((isSelected ?? false) ? 1.0 : 0.2),
      ),
      width: MediaQuery.of(context).size.width * 0.28,
    );
  }
}
