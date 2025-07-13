import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future sendAnalyticsEvent({String? eventName, String? clickevent}) async {
    await _analytics.logEvent(
      name: eventName ?? '',
      parameters: <String, Object>{
        'clickEvent': clickevent ?? '',
      },
    );
  }

  Future logScreens({@required String? name}) async {
    await _analytics.logScreenView(screenName: name);
  }

  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }
}

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
}
