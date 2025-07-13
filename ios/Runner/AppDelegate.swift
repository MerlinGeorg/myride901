import UIKit
import Flutter
import Firebase
import FirebaseCore
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
  if #available(iOS 10.0, *) {
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
  }
    GeneratedPluginRegistrant.register(with: self)
    //api key for maps
    GMSServices.provideAPIKey("AIzaSyBUAqUl8yyf-qqyoQ9hzqVn_SyTKhVnMC4")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
