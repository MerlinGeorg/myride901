import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  @override
  AboutUsPageState createState() => AboutUsPageState();
}

class AboutUsPageState extends State<AboutUsPage> {
  AppThemeState _appTheme = AppThemeState();
  PackageInfo? packageInfo;
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      packageInfo = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
        initialData: null,
        stream: null,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppTheme.of(context).primaryColor,
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(AssetImages.left_arrow),
                  )),
              title: Text(
                StringConstants.app_about_us,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Image.asset(
                    AssetImages.about_us_bg,
                    height: 250,
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 200,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 15),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 120,
                                child: Text(
                                  StringConstants.version_number,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  '${packageInfo?.version ?? ''} (${packageInfo?.buildNumber ?? ''})',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            StringConstants.myride901_question,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17,
                                color: _appTheme.primaryColor,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            StringConstants.myride901_that,
                            style: TextStyle(
                                fontSize: 17,
                                color: _appTheme.primaryColor,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RichText(
                            text: TextSpan(
                              text: StringConstants.captures,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: _appTheme.primaryColor,
                                  fontWeight: FontWeight.w700),
                              children: <TextSpan>[
                                TextSpan(
                                  text: StringConstants.captres_info,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: _appTheme.primaryColor,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RichText(
                            text: TextSpan(
                              text: StringConstants.organizes,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: _appTheme.primaryColor,
                                  fontWeight: FontWeight.w700),
                              children: <TextSpan>[
                                TextSpan(
                                  text: StringConstants.organizes_info,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: _appTheme.primaryColor,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RichText(
                            text: TextSpan(
                              text: StringConstants.shares,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: _appTheme.primaryColor,
                                  fontWeight: FontWeight.w700),
                              children: <TextSpan>[
                                TextSpan(
                                  text: StringConstants.shares_info,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: _appTheme.primaryColor,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  _launchURL(StringConstants.linkFacebook);
                                },
                                child: Image.asset(
                                  AssetImages.facebookOld,
                                  width: 30,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _launchURL(StringConstants.linkInstagram);
                                },
                                child: Image.asset(
                                  AssetImages.instagram,
                                  width: 30,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(RouteName.supportPage);
                                },
                                child: Text(
                                  StringConstants.support,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: _appTheme.blueColor,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteName.webViewDisplayPage,
                                      arguments: ItemArgument(data: {
                                        'url': StringConstants.linkTerms,
                                        'title':
                                            StringConstants.terms_of_services,
                                        'id': 3
                                      }));
                                },
                                child: Text(
                                  StringConstants.terms,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: _appTheme.blueColor,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteName.webViewDisplayPage,
                                      arguments: ItemArgument(data: {
                                        'url': StringConstants.linkPrivacy,
                                        'title': StringConstants.privacy_policy,
                                        'id': 2
                                      }));
                                },
                                child: Text(
                                  StringConstants.privacy,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: _appTheme.blueColor,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              _launchURL(StringConstants.linkSite);
                            },
                            child: Text(
                              StringConstants.linkSite,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: _appTheme.blueColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _launchURL(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw StringConstants.launchUrlError;
    }
  }
}
