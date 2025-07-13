import 'package:flutter/material.dart';
import 'package:myride901/features/drawer/about_us/about_us_page.dart';
import 'package:myride901/features/drawer/contacts/service_provider_page.dart';
import 'package:myride901/features/qa_tool/qa_tool_page.dart';
import 'package:myride901/features/qa_tool/user_state_page.dart';
import 'package:myride901/features/subscription/subscription_page.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_form_1_page.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_form_2_page.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_form_3_page.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_form_4_page.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_form_5_page.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_form_6_page.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_form_7_page.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_form_closing_page.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_home/accident_report_home_page.dart';
import 'package:myride901/features/toolkit/accident_report/share_report/report_share_option/report_share_option_page.dart';
import 'package:myride901/features/toolkit/accident_report/share_report/share_event_user_selection/share_report_user_selection_page.dart';
import 'package:myride901/features/tabs/service_event/add_service_event/add_service_event_page.dart';
import 'package:myride901/features/tabs/service_event/edit_service_event/edit_service_event_page.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/add_vehicle_manually/add_vehicle_manually_page.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/add_vehicle_option/add_vehicle_option_page.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/base_add_vehicle_page.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/search_from_vin/search_from_vin_page.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/vehicle_spe_page/vehicle_spe_page.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/vin_final_page/vin_final_page.dart';
import 'package:myride901/features/auth/create_new_password/create_new_password_page.dart';
import 'package:myride901/features/auth/forgot_password/forgot_password_page.dart';
import 'package:myride901/features/auth/login/login_page.dart';
import 'package:myride901/features/auth/onboard/onboard_page.dart';
import 'package:myride901/features/auth/otp_verification/otp_verification_page.dart';
import 'package:myride901/features/auth/signup/sign_up_page.dart';
//import 'package:myride901/screens/tabs/home/blog/blog_page.dart';
import 'package:myride901/features/tabs/reminders/add_reminder/add_reminder_page.dart';
import 'package:myride901/features/tabs/reminders/edit_reminder/edit_reminder_page.dart';
import 'package:myride901/features/toolkit/find_shop/shops_page.dart';
import 'package:myride901/features/toolkit/track_mileage/add_track_mileage/add_trip.dart';
import 'package:myride901/features/toolkit/track_mileage/edit_track_mileage/edit_trip.dart';
import 'package:myride901/features/toolkit/track_mileage/track_mileage_screen.dart';
import 'package:myride901/features/drawer/contact_us/contact_us_page.dart';
import 'package:myride901/features/tabs/dashboard_page.dart';
import 'package:myride901/features/tabs/home/onboarding.dart';
import 'package:myride901/features/toolkit/next_service/get_maintenance/get_maintenance_page.dart';
import 'package:myride901/features/toolkit/safety_recalls/get_recalls_page.dart';
import 'package:myride901/features/toolkit/next_service/select_event_add/select_event_add_page.dart';
import 'package:myride901/features/toolkit/next_service/verify_car_detail/verify_car_detail_page.dart';
import 'package:myride901/not_used/timeline/timeline_page.dart';
import 'package:myride901/features/tabs/service_event/service_detail/service_event_detail_page.dart';
import 'package:myride901/features/drawer/contacts/add_contact/add_contact_screen.dart';
import 'package:myride901/features/drawer/contacts/edit_contact/edit_contact_screen.dart';
import 'package:myride901/features/shared/service_share_option/service_share_option_page.dart';
import 'package:myride901/features/drawer/setting/change_password/change_password_page.dart';
import 'package:myride901/features/drawer/setting/edit_profile/edit_profile_page.dart';
import 'package:myride901/features/drawer/setting/setting_page.dart';
import 'package:myride901/features/shared/share_event_user_selection/share_event_user_selection_page.dart';
import 'package:myride901/features/shared/share_service_permission/share_service_permission_page.dart';
import 'package:myride901/features/drawer/shared_event_history/shared_event_page.dart';
import 'package:myride901/features/drawer/support/support_page.dart';
import 'package:myride901/features/shared/webViewDisplay/webViewDisplay_page.dart';
import 'package:myride901/features/toolkit/safety_recalls/output/output_page.dart';

class RouteName {
  static final String supportPage = "/supportPage";
  static final String root = "/";
  static final String login = "/login";
  static final String signUp = "/signUp";
  static final String onBoard = "/onBoard";
  static final String forgotPassword = "/forgotPassword";
  static final String otpVerification = "/otpVerification";
  static final String createNewPassword = "/createNewPassword";
  static final String dashboard = "/dashboard";
  static final String serviceDetail = "/serviceDetail";
  static final String serviceShareOption = "/serviceShareOption";
  static final String shareEventUserSelection = "/shareEventUserSelection";
  static final String shareServicePermission = "/shareServicePermission";
  static final String shareReportUserSelection = "/shareReportUserSelection";
  static final String shareReportPermission = "/shareReportPermission";
  static final String reportShareOption = "/reportShareOption";
  static final String sharedEvent = "/sharedEvent";
  static final String serviceProvider = "/serviceProvider";
  static final String addVehicle = "/addVehicle";
  static final String addTrip = "/addTrip";
  static final String editTrip = "/editTrip";
  static final String addVehicleOption = "/addVehicleOption";
  static final String addVehicleManually = "/addVehicleManually";
  static final String setting = "/setting";
  static final String qaTool = "/qaTool";
  static final String userState = "/user-state";
  static final String output = "/output";
  static final String changePassword = "/changePassword";
  static final String editProfile = "/editProfile";
  static final String editProvider = "/editProvider";
  static final String timeline = "/timeline";
  static final String addVINNumber = "/addVINNumber";
  static final String vinFinal = "/vinFinal";
  static final String webViewDisplayPage = "/webViewDisplayPage";
  static final String aboutUsPage = "/aboutUsPage";
  static final String getMaintenance = "/getMaintenance";
  static final String verifyCarDetail = "/verifyCarDetail";
  static final String selectEventAdd = "/selectEventAdd";
  //static final String blogs = "/blogs";
  static final String support = "/support";
  static final String contactUs = "/contactUs";
  static final String onboarding = "/onboarding";
  static final String addVehicleSpe = "/addVehicleSpe";
  static final String vehicleRecall = "/vehicleRecall";
  static final String trip = "/trip";
  static final String reminders = "/reminders";
  static final String accidentReport = "/accidentReport";
  static final String accidentReportForm1 = "/accidentReportForm1";
  static final String accidentReportForm2 = "/accidentReportForm2";
  static final String accidentReportForm3 = "/accidentReportForm3";
  static final String accidentReportForm4 = "/accidentReportForm4";
  static final String accidentReportForm5 = "/accidentReportForm5";
  static final String accidentReportForm6 = "/accidentReportForm6";
  static final String accidentReportForm7 = "/accidentReportForm7";
  static final String addProvider = "/addProvider";
  static final String addProviderService = "/addProviderService";
  static final String addEvent = "/addEvent";
  static final String editEvent = "/editEvent";
  static final String addReminder = "/addReminder";
  static final String editReminder = "/editReminder";
  static final String blogTabView = "/blogTab";
  static final String accidentReportClosingPage =
      "/accidentReportFormClosingPage";
  static final String shops = "/shops";
  static final String subscription = "/subscription";
  static final String vehicleProfile = "/vehicleProfile";
}

class Routes {
  static final baseRoutes = <String, WidgetBuilder>{
    RouteName.supportPage: (context) => SupportPage(),
    RouteName.root: (context) => OnBoardPage(),
    RouteName.login: (context) => LoginPage(),
    RouteName.onBoard: (context) => OnBoardPage(),
    RouteName.signUp: (context) => SignUpPage(),
    RouteName.forgotPassword: (context) => ForgotPasswordPage(),
    RouteName.otpVerification: (context) => OTPVerificationPage(),
    RouteName.createNewPassword: (context) => CreateNewPasswordPage(),
    RouteName.serviceDetail: (context) => ServiceEventDetailPage(),
    RouteName.serviceShareOption: (context) => ServiceShareOptionPage(),
    RouteName.trip: (context) => TripPage(),
    RouteName.shareServicePermission: (context) => ShareServicePermissionPage(),
    RouteName.shareEventUserSelection: (context) =>
        ShareEventUserSelectionPage(),
    RouteName.shareReportUserSelection: (context) =>
        ShareReportUserSelectionPage(),
    RouteName.reportShareOption: (context) => ReportShareOptionPage(),
    RouteName.dashboard: (context) => DashboardPage(tabview: 0, selectedTab: 1),
    RouteName.sharedEvent: (context) => SharedEventPage(),
    RouteName.onboarding: (context) => Onboarding(),
    RouteName.addVehicle: (context) => BaseAddVehiclePage(),
    RouteName.addTrip: (context) => AddTripPage(),
    RouteName.editTrip: (context) => EditTripPage(),
    RouteName.addVehicleOption: (context) => AddVehicleOptionPage(),
    RouteName.addVehicleManually: (context) => AddVehicleManuallyPage(),
    RouteName.changePassword: (context) => ChangePasswordPage(),
    RouteName.setting: (context) => SettingPage(),
    RouteName.qaTool: (context) => QAToolPage(),
    RouteName.userState: (context) => UserStatePage(),
    RouteName.editProfile: (context) => EditProfilePage(),
    RouteName.timeline: (context) => TimelinePage(),
    RouteName.addVINNumber: (context) => SearchFromVINPage(),
    RouteName.vinFinal: (context) => VINFinalPage(),
    RouteName.webViewDisplayPage: (context) => WebViewDisplayPage(),
    RouteName.aboutUsPage: (context) => AboutUsPage(),
    RouteName.getMaintenance: (context) => GetMaintenancePage(),
    RouteName.verifyCarDetail: (context) => VerifyCarDetailPage(),
    RouteName.selectEventAdd: (context) => SelectEventAddPage(),
    //RouteName.blogs: (context) => BlogsPage(),
    RouteName.output: (context) => OutputPage(),
    RouteName.support: (context) => SupportPage(),
    RouteName.contactUs: (context) => ContactUsPage(),
    RouteName.addVehicleSpe: (context) => VehicleSpePage(),
    RouteName.vehicleRecall: (context) => GetRecallPage(),
    RouteName.accidentReport: (context) => AccidentReportHomePage(),
    RouteName.accidentReportForm1: (context) => AccidentReportForm1Page(),
    RouteName.accidentReportForm2: (context) => AccidentReportForm2Page(),
    RouteName.accidentReportForm3: (context) => AccidentReportForm3Page(),
    RouteName.accidentReportForm4: (context) => AccidentReportForm4Page(),
    RouteName.accidentReportForm5: (context) => AccidentReportForm5Page(),
    RouteName.accidentReportForm6: (context) => AccidentReportForm6Page(),
    RouteName.accidentReportForm7: (context) => AccidentReportForm7Page(),
    RouteName.addProvider: (context) => AddProviderPage(),
    RouteName.serviceProvider: (context) => ServiceProviderPage(),
    RouteName.editProvider: (context) => EditProviderPage(),
    RouteName.addEvent: (context) => AddServiceEventPage(),
    RouteName.editEvent: (context) => EditServiceEventPage(),
    RouteName.addReminder: (context) => AddReminderPage(),
    RouteName.editReminder: (context) => EditReminderPage(),
    RouteName.reminders: (context) => DashboardPage(
          selectedTab: 2,
        ),
    RouteName.blogTabView: (context) =>
        DashboardPage(tabview: 1, selectedTab: 1),
    RouteName.accidentReportClosingPage: (context) =>
        AccidentReportFormClosingPage(),
    RouteName.shops: (context) => Shops(),
    RouteName.subscription: (context) => SubscriptionPage(
        routeOrigin: (ModalRoute.of(context)?.settings.arguments
            as Map<String, String?>)['routeOrigin']),
    RouteName.vehicleProfile: (context) => DashboardPage(
          selectedTab: 4,
        ),
  };
}
