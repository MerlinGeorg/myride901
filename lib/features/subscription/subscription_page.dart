import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/features/subscription/subscription_bloc.dart';
import 'package:myride901/features/subscription/widgets/subscription_widgets.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionPage extends StatefulWidget {
  String? routeOrigin;
  SubscriptionPage({Key? key, this.routeOrigin}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  late SubscriptionBloc _subscriptionBloc;

  late dynamic _purchaseUpdatedSubscription;
  late dynamic _purchaseErrorSubscription;
  late dynamic _connectionSubscription;

  @override
  void initState() {
    _subscriptionBloc = SubscriptionBloc();
    _subscriptionBloc.initPurchase();

    // Streams listen
    _connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((productItem) {});

    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated
        .listen((productItem) async => await _subscrptionUpdated(productItem));

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError
        .listen((purchaseError) => _subscrptionError(purchaseError));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _subscriptionBloc.getUserStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (_subscriptionBloc.subscriptionState["isPurchasedRestored"] ==
              true) {
            // Schedule the dialog to show after the build is complete
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Utils.showAlertDialogCallBack1(
                context: context,
                message: 'Your subscription has been successfully verified.',
                isOnlyOK: true,
                okBtnName: "OK",
                onOkClick: () {
                  _subscriptionBloc.subscriptionState["isPurchasedRestored"] =
                      false;
                  debugPrint(
                      "---> verifId  ${_subscriptionBloc.subscriptionState["isPurchasedRestored"]}");

                  Navigator.pop(context);
                },
              );
            });
          }

          return StreamBuilder<bool>(
            initialData: null,
            stream: _subscriptionBloc.mainStream,
            builder: (context, snapshot) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppTheme.of(context).primaryColor,
                  title: Text(
                    StringConstants.subscriptionPage_navigationTitle,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  leading: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.dashboard);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AssetImages.left_arrow),
                    ),
                  ),
                ),
                body: BlocProvider<SubscriptionBloc>(
                  bloc: _subscriptionBloc,
                  child: _body(),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _body() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                StringConstants.subscriptionPage_title,
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              SubscriptionFeatureRow(
                  StringConstants.subscription_serviceReceipt_desc, true),
              SubscriptionFeatureRow(
                  StringConstants.subscription_vehicleHistory_desc, true),
              SubscriptionFeatureRow(
                  StringConstants.subscription_trackMileage_desc, true),
              SubscriptionFeatureRow(
                  StringConstants.subscription_nextServiceLookup_desc, true),
              SubscriptionFeatureRow(
                  StringConstants.subscription_safetyServiceLookup_desc, true),
              SubscriptionFeatureRow(
                  StringConstants.subscription_accidentReport_desc, true),
              SizedBox(height: 24),
              if (_subscriptionBloc.subscriptionState["isTrialStarted"] ==
                      false &&
                  _subscriptionBloc.subscriptionState["isSecondTime"] == false)
                SizedBox(
                  width: double.infinity,
                  child: BlueButton(
                    text: StringConstants.subscriptionInfoPopup_start_trial,
                    onPress: () {
                      _subscriptionBloc.startTrialPeriod();
                      Navigator.pop(context);
                    },
                  ),
                ),
              SizedBox(height: 16),
              SubscriptionPlanWidget(
                plan: StringConstants.subscriptionPage_yearlyPlan_title,
                description: StringConstants.subscriptionPage_yearlyPlan_desc,
                price: _subscriptionBloc.getYearlyPrice(),
                isSelected: true,
                onTap: () async {
                  _subscriptionBloc.selected = 2;
                  await _subscriptionBloc.purchaseOn();
                },
              ),
              SubscriptionPlanWidget(
                plan: StringConstants.subscriptionPage_monthlyPlan_title,
                description: StringConstants.subscriptionPage_monthlyPlan_desc,
                price: _subscriptionBloc.getMonthlyPrice(),
                isSelected: false,
                onTap: () async {
                  _subscriptionBloc.selected = 1;
                  await _subscriptionBloc.purchaseOn();
                },
              ),
              SizedBox(height: 24),
              InkWell(
                onTap: () {
                  if (Platform.isIOS) {
                    _launchURL(StringConstants.linkSubscriptionFeatures);
                  } else {
                    Navigator.pushNamed(context, RouteName.webViewDisplayPage,
                        arguments: ItemArgument(data: {
                          'url': StringConstants.linkSubscriptionFeatures,
                          'title': StringConstants.premiumFeatureTitle,
                        }));
                  }
                },
                child: Text(
                  StringConstants.subscription_premiumFeature_hyperlink,
                  style: TextStyle(
                      fontSize: 17,
                      color: AppTheme.of(context).blueColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_connectionSubscription != null) {
      _connectionSubscription?.cancel();
      _connectionSubscription = null;
    }
    //await FlutterInappPurchase.instance.endConnection;
    if (_purchaseUpdatedSubscription != null) {
      _purchaseUpdatedSubscription?.cancel();
      _purchaseUpdatedSubscription = null;
    }
    if (_purchaseErrorSubscription != null) {
      _purchaseErrorSubscription?.cancel();
      _purchaseErrorSubscription = null;
    }

    EasyLoading.dismiss();
    super.dispose();
  }

  _subscrptionError(PurchaseResult? purchaseError) {
    EasyLoading.dismiss();

    _subscriptionBloc.callVerify = false;

    // We don't want to display twice error msg from GP ;
    if (purchaseError?.message?.contains("own this item") == false) {
      CommonToast.getInstance()
          .displayToast(message: purchaseError?.message ?? '');
    }
  }

  _subscrptionUpdated(PurchasedItem? productItem) async {
    if ((Platform.isIOS &&
            productItem?.transactionStateIOS == TransactionState.purchased) ||
        productItem?.purchaseStateAndroid == PurchaseState.purchased) {
      if (_subscriptionBloc.callVerify) {
        _subscriptionBloc.callVerify = false;
        bool valid;

        if (Platform.isIOS) {
          debugPrint(
              "----> verify productItem ${productItem?.transactionStateIOS} transactionDate ${productItem?.transactionDate}");
          valid = await _subscriptionBloc.verifyPurchase(productItem);
          setState(() {});
        } else {
          valid = await _subscriptionBloc.acknowledgeAPI(productItem);
          setState(() {});
          debugPrint("----> valid Android subscription $valid");
        }

        if (valid) {
          widget.routeOrigin != null
              ? Navigator.of(context).pushNamedAndRemoveUntil(
                  widget.routeOrigin!, (Route<dynamic> route) => false)
              : Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteName.dashboard, (Route<dynamic> route) => false);
        } else {
          _subscriptionBloc.callVerify = false;

          CommonToast.getInstance()
              .displayToast(message: 'Handle Invalid Purchase ');
          return;
        }
        FlutterInappPurchase.instance.finishTransaction(productItem!);
      }
    } else if (productItem?.purchaseStateAndroid == PurchaseState.unspecified) {
      CommonToast.getInstance()
          .displayToast(message: 'PurchaseStatus.unspecified');
    } else {
      EasyLoading.dismiss();
    }
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
