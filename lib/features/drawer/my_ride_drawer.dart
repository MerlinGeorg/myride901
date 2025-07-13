import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/user_picture.dart';
import 'package:myride901/core/services/analytic_services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MyRideDrawer extends StatefulWidget {
  final BuildContext? context;

  const MyRideDrawer({Key? key, this.context}) : super(key: key);

  @override
  _MyRideDrawerState createState() => _MyRideDrawerState();
}

class _MyRideDrawerState extends State<MyRideDrawer> {
  List<DrawerItemDate> drawerItemList = [];
  PackageInfo? packageInfo;
  var arr = [
    'Home',
    'About',
    'ContactUs',
    'SubscribeNow',
    'FAQ',
    'Support',
    'SharedEventHistory',
    'ServiceProviders',
    'PrivacyPolicy',
    'Manage Subscription',
    'TermsOfUse',
  ];

  @override
  void initState() {
    drawerItemList.add(DrawerItemDate(
        StringConstants.home, AssetImages.home_b, DrawerItem.home));
    drawerItemList
        .add(DrawerItemDate('About', AssetImages.aboutUsNew, DrawerItem.about));
    drawerItemList.add(DrawerItemDate(
        'Contact Us', AssetImages.contactNew, DrawerItem.contactUs));
    drawerItemList
        .add(DrawerItemDate('FAQ', AssetImages.faqNew, DrawerItem.faq));
    drawerItemList.add(
        DrawerItemDate('Support', AssetImages.supportNew, DrawerItem.support));
    drawerItemList.add(DrawerItemDate('Shared Event History',
        AssetImages.sharedEventNew, DrawerItem.sharedEventHistory));
    drawerItemList.add(DrawerItemDate(
        'Contacts', AssetImages.user_bold, DrawerItem.serviceProvider));
    drawerItemList.add(DrawerItemDate(
        'Privacy Policy', AssetImages.privacyNew, DrawerItem.privacyPolicy));
    drawerItemList.add(DrawerItemDate('Manage Subscription',
        AssetImages.subscription, DrawerItem.manageSubscription));
    drawerItemList.add(DrawerItemDate(
        'Terms Of Use', AssetImages.termsNew, DrawerItem.termsOfUse));
    PackageInfo.fromPlatform().then((value) {
      packageInfo = value;
      setState(() {});
    });
    Utils.getDetail();
    super.initState();
  }

  void click(DrawerItem drawerItem) {
    switch (drawerItem) {
      case DrawerItem.edit:
        Navigator.pushNamed(context, RouteName.editProfile);
        break;
      case DrawerItem.setting:
        Navigator.pushNamed(context, RouteName.setting);
        break;
      case DrawerItem.about:
        Navigator.pushNamed(context, RouteName.aboutUsPage);
        break;
      case DrawerItem.sharedEventHistory:
        Navigator.pushNamed(context, RouteName.sharedEvent);
        break;
      case DrawerItem.serviceProvider:
        Navigator.pushNamed(context, RouteName.serviceProvider);
        break;
      case DrawerItem.contactUs:
        Navigator.pushNamed(context, RouteName.contactUs);
        break;
      case DrawerItem.support:
        Navigator.pushNamed(context, RouteName.supportPage);
        break;
      case DrawerItem.logout:
        debugPrint("logout action");
        // LoginData loginData = AppComponentBase().getLoginData();
        logout();

        break;
      case DrawerItem.faq:
        Navigator.pushNamed(context, RouteName.webViewDisplayPage,
            arguments: ItemArgument(data: {
              'url': StringConstants.linkFaq,
              'title': 'FAQ',
              'id': 5
            }));
        break;
      // case DrawerItem.blog:
      //   Navigator.pushNamed(context, RouteName.blogs);
      //   break;
      case DrawerItem.privacyPolicy:
        Navigator.pushNamed(context, RouteName.webViewDisplayPage,
            arguments: ItemArgument(data: {
              'url': StringConstants.linkPrivacy,
              'title': 'Privacy Policy',
              'id': 2
            }));
        break;
      case DrawerItem.termsOfUse:
        Navigator.pushNamed(context, RouteName.webViewDisplayPage,
            arguments: ItemArgument(data: {
              'url': StringConstants.linkTerms,
              'title': 'Terms Of Use',
              'id': 3
            }));
        break;
      case DrawerItem.home:
        // TODO: Handle this case.
        AppComponentBase.getInstance().changeIndex(1);

        break;
      case DrawerItem.manageSubscription:
        Navigator.pushNamed(context, RouteName.subscription,
            arguments: <String, String?>{'routeOrigin': RouteName.dashboard});
        break;
      case DrawerItem.qaTool:
        Navigator.pushNamed(context, RouteName.qaTool);
    }
  }

  void logout() {
    debugPrint("-----logout method");
    AppComponentBase.getInstance()
        .getApiInterface()
        .getUserRepository()
        .logout()
        .then((value) {
      AppComponentBase.getInstance().clearData();
      AppComponentBase.getInstance().getSharedPreference().setUserDetail(null);
      AppComponentBase.getInstance()
          .getSharedPreference()
          .setSelectedVehicle(null);
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          RouteName.root, (route) => false,
          arguments: ItemArgument(data: {}));
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 284,
      child: ListView(
        children: [
          DrawerHeader(
            userPicture: (AppComponentBase.getInstance()
                    .getLoginData()
                    .user!
                    .displayImage ??
                ''),
            onEdit: () {
              Navigator.pop(context);
              click(DrawerItem.edit);
            },
            phoneNum:
                (AppComponentBase.getInstance().getLoginData().user!.phone ??
                    ''),
            userName: (AppComponentBase.getInstance()
                        .getLoginData()
                        .user!
                        .firstName ??
                    '') +
                ' ' +
                (AppComponentBase.getInstance().getLoginData().user!.lastName ??
                    ''),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HeaderLabel(
                  label: 'Vehicles',
                  value:
                      '${AppComponentBase.getInstance().getLoginData().user?.totalVehicles ?? 0}',
                ),
                HeaderLabel(
                  label: 'Events',
                  value:
                      '${AppComponentBase.getInstance().getLoginData().user?.totalEvents ?? 0}',
                ),
              ],
            ),
          ),
          Divider(),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: drawerItemList.length,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () {
                    locator<AnalyticsService>().sendAnalyticsEvent(
                        eventName: arr[index], clickevent: arr[index]);
                    Navigator.pop(context);
                    click(drawerItemList[index].drawerItem);
                  },
                  child: DrawerSelectedItem(
                    isSelected: 0 == drawerItemList[index].drawerItem.index,
                    title: drawerItemList[index].title,
                    icon: drawerItemList[index].icon,
                    color: drawerItemList[index].color,
                  ),
                );
              }),
          Divider(),
          if (dotenv.env['IS_RELEASE'] == 'false')
            InkWell(
              onTap: () {
                Navigator.pop(context);
                click(DrawerItem.qaTool);
              },
              child: DrawerSelectedItem(
                title: StringConstants.qatool,
                icon: AssetImages.settings,
                isSelected: true,
                color: Colors.red,
              ),
            ),
          InkWell(
            onTap: () {
              locator<AnalyticsService>().sendAnalyticsEvent(
                  eventName: "Settings", clickevent: "User tap on settings.");
              Navigator.pop(context);
              click(DrawerItem.setting);
            },
            child: DrawerSelectedItem(
              title: StringConstants.setting,
              icon: AssetImages.settings,
              isSelected: false,
            ),
          ),
          InkWell(
            onTap: () {
              locator<AnalyticsService>().sendAnalyticsEvent(
                  eventName: "Logout", clickevent: "User logout");
              click(DrawerItem.logout);
            },
            child: DrawerSelectedItem(
                title: StringConstants.logout,
                icon: AssetImages.logout,
                isSelected: false),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              packageInfo == null
                  ? ''
                  : 'v. ' +
                      (packageInfo?.version ?? '') +
                      '(' +
                      (packageInfo?.buildNumber ?? '') +
                      ')',
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xff121212).withOpacity(0.3)),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

class HeaderLabel extends StatelessWidget {
  final String label;
  final String value;

  const HeaderLabel({Key? key, this.label = '', this.value = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppTheme.of(context).primaryColor),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          label,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color(0xff121212).withOpacity(0.4)),
        ),
      ],
    );
  }
}

class DrawerHeader extends StatelessWidget {
  const DrawerHeader(
      {Key? key, this.userPicture, this.userName, this.phoneNum, this.onEdit})
      : super(key: key);
  final String? userPicture;
  final String? userName;
  final String? phoneNum;
  final Function? onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 19, right: 19, top: 30, bottom: 20),
      child: Row(
        children: [
          UserPicture(
            userPicture: userPicture ?? '',
            size: Size(60, 60),
            text: userName!.substring(0, 1).toUpperCase(),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName ?? '',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Color(0xff121212)),
                ),
                if (phoneNum != null && phoneNum!.trim() != '')
                  SizedBox(
                    height: 5,
                  ),
                if (phoneNum != null && phoneNum!.trim() != '')
                  Text(
                    phoneNum ?? '',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Color(0xff121212).withOpacity(0.5)),
                  ),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    onEdit?.call();
                  },
                  child: Text(
                    StringConstants.edit_profile,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Color(0xffD03737)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DrawerSelectedItem extends StatelessWidget {
  const DrawerSelectedItem(
      {Key? key,
      this.icon = '',
      this.title = '',
      this.isSelected = false,
      this.color = Colors.black})
      : super(key: key);
  final String icon;
  final String title;
  final bool isSelected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
          color: Color(0xffC3D7FF).withOpacity(isSelected ? 0.2 : 0),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50), bottomRight: Radius.circular(50))),
      child: Row(
        children: [
          icon.contains('.png')
              ? Image.asset(
                  icon,
                  width: 22,
                  height: 22,
                )
              : SvgPicture.asset(
                  icon,
                  width: 22,
                  height: 22,
                  color: AppTheme.of(context).primaryColor,
                ),
          SizedBox(
            width: 15,
          ),
          Text(
            title,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: color ?? AppTheme.of(context).primaryColor),
          )
        ],
      ),
    );
  }
}

enum DrawerItem {
  home,
  about,
  contactUs,
  faq,
  support,
  //blog,
  sharedEventHistory,
  serviceProvider,
  manageSubscription,
  privacyPolicy,
  termsOfUse,
  setting,
  logout,
  edit,
  qaTool,
}

class DrawerItemDate {
  final String title;
  final String icon;
  final DrawerItem drawerItem;
  final Color? color;

  DrawerItemDate(this.title, this.icon, this.drawerItem, {this.color});
}
