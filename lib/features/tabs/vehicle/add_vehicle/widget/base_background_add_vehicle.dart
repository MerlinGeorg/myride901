import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/core/themes/app_theme.dart';

class BassBGAdfVehicle extends StatelessWidget {
  final Widget? child;
  final bool? hasBackButton;
  final Function? onBackPress;

  const BassBGAdfVehicle(
      {Key? key, this.child, this.hasBackButton = false, this.onBackPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              AppTheme.of(context).primaryColor,
              AppTheme.of(context).primaryColor.withOpacity(0.4),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            height: MediaQuery.of(context).size.height * 0.25,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: SvgPicture.asset(AssetImages.add_vehicle_car),
              ),
            ),
          ),
        ),
        if (hasBackButton ?? false)
          Positioned(
              top: 40,
              left: 20,
              child: InkWell(
                onTap: () {
                  if (hasBackButton ?? false) onBackPress?.call();
                },
                child: SvgPicture.asset(AssetImages.back_icon_1),
              )),
        Positioned(
            top: 40,
            right: 20,
            child: InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteName.dashboard, (route) => false);
              },
              child: SvgPicture.asset(
                AssetImages.vehicle_home,
                width: 34,
                height: 34,
              ),
            )),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.25 - 30,
          left: 0,
          bottom: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
            child: child,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
          ),
        )
      ],
    );
  }
}
