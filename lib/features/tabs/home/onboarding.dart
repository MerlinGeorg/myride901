import 'package:flutter/material.dart';
import 'package:myride901/core/services/analytic_services.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  void initState() {
    super.initState();
    locator<AnalyticsService>().logScreens(name: "Onboarding Page");
  }

  @override
  Widget build(BuildContext context) {
    var _appTheme = AppTheme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              tileMode: TileMode.clamp,
              colors: [
                _appTheme.primaryColor,
                _appTheme.primaryColor,
                Color(0xffD03737)
              ],
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.asset(
                      AssetImages.logo_l,
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.2,
                      ),
                      child: Text(
                        StringConstants.onboarding_desc,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          height: 1.5,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RouteName.addVehicleOption);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.015,
                          horizontal: MediaQuery.of(context).size.width * 0.3,
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        "Add a Vehicle",
                        style: TextStyle(
                          color: _appTheme.primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteName.dashboard);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.015,
                          horizontal: MediaQuery.of(context).size.width * 0.3,
                        ),
                        side: BorderSide(
                          color: Colors.white, // Set the border color
                          width: 1.0, // Set the border width
                        ),
                      ),
                      child: Text(
                        "Skip for now ",
                        style: TextStyle(
                          color: _appTheme.whiteColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
