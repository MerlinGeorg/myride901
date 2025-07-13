import 'package:flutter/material.dart';
import 'package:myride901/core/themes/app_theme.dart';

Widget buildStarRating(double rating, BuildContext context) {
  int numberOfStars = rating.round();
  List<Widget> stars = [];
  for (int i = 0; i < 5; i++) {
    IconData iconData = Icons.star_border;
    if (i < numberOfStars) {
      iconData = Icons.star;
    } else if (i == numberOfStars && rating % 1 != 0) {
      iconData = Icons.star_half;
    }
    stars.add(Icon(
      iconData,
      color: AppTheme.of(context).primaryColor,
    ));
  }
  return Row(
    children: stars,
  );
}
