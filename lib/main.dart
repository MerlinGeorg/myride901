import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/login_data/login_data.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myride901/core/services/analytic_services.dart';
import 'package:myride901/flavor_config.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:package_info_plus/package_info_plus.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  debugPrint(
      "\n ---> flavor ${FlavorConfig.getFlavor} env ${packageInfo.packageName} baseUrl ${FlavorConfig.apiUrl} \n");

  // Initialize Google AdMob
  await MobileAds.instance.initialize();
  var devices = [''];
  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: devices,
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  await Firebase.initializeApp();
  setupServiceLocator();
  String initialRoute = RouteName.root;

  LoginData? loginData = await AppComponentBase.getInstance()
      .getSharedPreference()
      .getUserDetail();

  if (loginData != null) {
    AppComponentBase.getInstance().setLoginData(loginData);
    await Utils.getDetail();
    loginData = AppComponentBase.getInstance().getLoginData();
    await locator<AnalyticsService>()
        .setUserId((loginData.user!.id).toString());
    initialRoute = loginData.user!.totalVehicles == 0
        ? RouteName.onboarding
        : RouteName.dashboard;
  }
  runApp(MyRide901App(initialRoute));
}

class MyRide901App extends StatefulWidget {
  String initialRoute;

  MyRide901App(this.initialRoute);

  @override
  State<StatefulWidget> createState() {
    return MyRide901AppState();
  }
}

class MyRide901AppState extends State<MyRide901App> {
  bool isInternet = false;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseInAppMessaging fiam = FirebaseInAppMessaging.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Widget app = AppTheme(
      child: MaterialApp(
        navigatorObservers: [
          locator<AnalyticsService>().getAnalyticsObserver(),
        ],
        debugShowCheckedModeBanner: false,
        routes: Routes.baseRoutes,
        initialRoute: widget.initialRoute,
        theme: ThemeData.light().copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent),
        builder: EasyLoading.init(builder: FToastBuilder()),
        navigatorKey: navigatorKey,
      ),
    );

    if (FlavorConfig.instance.values.showBanner) {
      app = Directionality(
        textDirection: TextDirection.ltr,
        child: Banner(
          message: FlavorConfig.getFlavor == Flavor.PRO ? 'PRO' : 'CLASSIC',
          location: BannerLocation.topStart,
          child: app,
        ),
      );
    }

    return app;
  }

  @override
  void dispose() {
    AppComponentBase.getInstance().getNetworkManager().disposeStream();
    AppComponentBase.getInstance().dispose();
    super.dispose();
  }
}
