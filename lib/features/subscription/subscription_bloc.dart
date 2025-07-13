import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/services/shared_preference.dart';
import 'package:myride901/models/login_data/login_data.dart';
import 'dart:async';
import 'dart:io';

import 'package:myride901/widgets/bloc_provider.dart';

class SubscriptionBloc extends BlocBase {
  // Private static variable to hold the single instance
  static final SubscriptionBloc _instance = SubscriptionBloc._internal();

  SubscriptionBloc._internal();

  // Public factory method to provide access to the instance
  factory SubscriptionBloc() {
    return _instance;
  }

  // Maps to store localized pricing information
  Map<String, String> _localizedPrices = {};

  StreamController<bool> mainStreamController = StreamController.broadcast();
  bool isUpgrade = false;
  bool callVerify = false;
  Map<String, dynamic> subscriptionState = {
    'isSubscribed': null,
    'hasProAccess': null,
    'isTrialStarted': null,
    'trialEndDate': null,
    'isTrial': null,
    'shouldReminderTrialEnd': null,
    'subscriptionName': null,
    'isPurchasedRestored': null,
  };

  List<IAPItem> products = [];
  List<PurchasedItem> productsPurchased = [];

  Stream<bool> get mainStream => mainStreamController.stream;
  SubscriptionDetail? subscriptionDetail;
  int selected = 1;

  List<String> kiOSIds = dotenv.env['IS_RELEASE'] == 'true'
      ? ['MyRide901_2025_monthly_plan', 'MyRide901_2025_yearly_plan']
      : ['MyRide901mth_dev', 'MyRide901yr_dev'];

  List<String> kAndroidIds = dotenv.env['IS_RELEASE'] == 'true'
      ? ['2025_gp_monthly_plan', '2025_gp_yearly_plan']
      : ['dev', 'myride901_yrly'];

  LoginData? loginData;

  @override
  void dispose() {
    mainStreamController.close();
  }

  Future<void> initPurchase() async {
    await FlutterInappPurchase.instance.initialize();

    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      print('consumeAllItems: $msg');
    } catch (err) {
      debugPrint('consumeAllItems error: $err');
    }

    try {
      // Add logging for the environment
      debugPrint('Is Release: ${dotenv.env['IS_RELEASE']}');
      debugPrint(
          'Using Product IDs: ${Platform.isAndroid ? kAndroidIds : kiOSIds}');

      // Get products and log the response
      final items = await FlutterInappPurchase.instance
          .getSubscriptions(Platform.isAndroid ? kAndroidIds : kiOSIds);

      debugPrint('Retrieved products: ${items.length}');
      for (var item in items) {
        debugPrint('Product details: ${item.toString()}');
        products.add(item);

        // Store localized pricing information
        if (item.productId != null && item.localizedPrice != null) {
          _localizedPrices[item.productId!] = item.localizedPrice!;
          debugPrint(
              'Stored localized price for ${item.productId}: ${item.localizedPrice}');
        }
      }
      // await _checkiOSSubscription();
    } catch (err) {
      debugPrint('Error retrieving products: $err');
    }

    setSubscription();

    if (subscriptionState["hasProAccess"] == false) {
      final isSubscribed = await checkiOSSubscription();
      if (isSubscribed == true) {
        subscriptionState["isPurchasedRestored"] = true;
      }
    }
  }

  getUserStatus() async {
    final loginDetails = await AppComponentBase.getInstance()
        .getApiInterface()
        .getUserRepository()
        .loginDetail();

    loginData = loginDetails;

    final subDetails = loginDetails.user?.subscriptionDetail;

    final isTrial = subDetails?.isTrial == 1 ? true : false;
    subscriptionState['isTrial'] = isTrial;

    subscriptionState['isSubscribed'] =
        subDetails?.isSubscription == 1 ? true : false;

    subscriptionState['isSecondTime'] =
        subDetails?.isSecondTime == 1 ? true : false;

    subscriptionState['subscriptionName'] = subDetails?.itemId;

    final trialEndDateString = subDetails?.trialEndDate;
    subscriptionState['trialEndDate'] = trialEndDateString;

    DateTime? trialEndDate;
    if (trialEndDateString != null) {
      try {
        trialEndDate = DateTime.parse(trialEndDateString)
            .toUtc()
            .add(Duration(hours: DateTime.now().timeZoneOffset.inHours))
            .toLocal();

        subscriptionState['trialEndDate'] = trialEndDate.toString();
      } catch (e) {
        debugPrint("Error parsing trialEndDate: $e");
      }
    }

    // is user has pro access
    if (isTrial == true || subscriptionState['isSubscribed'] == true) {
      subscriptionState['hasProAccess'] = true;
    } else {
      subscriptionState['hasProAccess'] = false;
    }

    // is user start trial period
    if (isTrial == false && trialEndDate == null) {
      subscriptionState['isTrialStarted'] = false;
    } else if (isTrial == true || trialEndDate != null) {
      subscriptionState['isTrialStarted'] = true;
    }

    // Calculate the date 2 days before trialEndDate
    if (trialEndDate != null) {
      SharedPreference pref =
          AppComponentBase.getInstance().getSharedPreference();
      final shouldDisplay = await pref.getShouldReminderTrialEnd();

      if (shouldDisplay == true) {
        final now = DateTime.now();
        final twoDaysBeforeEndDate = trialEndDate.subtract(Duration(days: 2));

        subscriptionState['shouldReminderTrialEnd'] =
            now.isAfter(twoDaysBeforeEndDate) && now.isBefore(trialEndDate);

        debugPrint("""
          Now: $now
          Two days before: $twoDaysBeforeEndDate
          Trial end: $trialEndDate
          Should show: ${subscriptionState['shouldReminderTrialEnd']}
        """);
      } else {
        subscriptionState['shouldReminderTrialEnd'] = false;
      }
      debugPrint("---> pref shouldDisplay $shouldDisplay ");
    } else {
      subscriptionState['shouldReminderTrialEnd'] = false;
    }

    debugPrint(
        "---> hasProAccess ${subscriptionState['hasProAccess']} trialEndDate ${trialEndDate} isTrialStarted ${subscriptionState['isTrialStarted']}");

    initPurchase();
  }

  void setSubscription() {
    String itemId =
        subscriptionDetail == null ? '' : subscriptionDetail?.itemId ?? '';

    if (itemId == '') {
    } else if (itemId == kiOSIds[0] || itemId == kAndroidIds[0]) {
      selected = 1;
    } else if (itemId == kiOSIds[1] || itemId == kAndroidIds[1]) {
      selected = 2;
    }
    if (!mainStreamController.isClosed) {
      mainStreamController.sink.add(true);
    }
  }

  String getCurrentSubscription() {
    if (Platform.isIOS) {
      return kiOSIds.elementAt(selected == 1 ? 0 : 1);
    } else {
      // TODO: do logic
      return kAndroidIds.elementAt(selected == 1 ? 0 : 1);
    }
  }

  // Get localized price for monthly subscription
  String getMonthlyPrice() {
    if (Platform.isAndroid) {
      final productId = kAndroidIds[0]; // Monthly subscription ID
      if (_localizedPrices.containsKey(productId)) {
        return _localizedPrices[productId]! + '/month';
      }
    }
    return StringConstants.subscriptionPage_monthlyPlan_price;
  }

  // Get localized price for yearly subscription
  String getYearlyPrice() {
    if (Platform.isAndroid) {
      final productId = kAndroidIds[1]; // Yearly subscription ID
      if (_localizedPrices.containsKey(productId)) {
        return _localizedPrices[productId]! + '/year';
      }
    }
    return StringConstants.subscriptionPage_yearlyPlan_price;
  }

  Future<bool> verifyPurchase(PurchasedItem? purchaseDetails) async {
    // TODO : check [purchaseDetails.originalTransactionIdentifierIOS] and [finishTransactionIOS]
    // EasyLoading.show();
    await FlutterInappPurchase.instance
        .finishTransactionIOS(purchaseDetails?.transactionId ?? '');

    await AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .appleVerify(
            transactionId: purchaseDetails?.transactionId,
            receiptData: purchaseDetails?.transactionReceipt,
            planDuration: purchaseDetails?.productId,
            isUpgrade: isUpgrade);

    await getUserStatus();

    // EasyLoading.dismiss();
    callVerify = false;

    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  Future<bool> acknowledgeAPI(PurchasedItem? purchaseDetails) async {
    if (!(purchaseDetails?.isAcknowledgedAndroid ?? false)) {
      await FlutterInappPurchase.instance
          .acknowledgePurchaseAndroid(purchaseDetails?.purchaseToken ?? '');
    }
    await AppComponentBase.getInstance()
        .getApiInterface()
        .getUserRepository()
        .acknowledgeAPI(
            transactionId: purchaseDetails?.transactionId,
            id: purchaseDetails?.productId,
            token: purchaseDetails?.purchaseToken,
            orderId: purchaseDetails?.transactionId)
        .then((value) {
      // CommonToast.getInstance().displayToast(message: 'Success Acknowledge');
    }).catchError((onError) {
      print(onError);
      // CommonToast.getInstance().displayToast(message: 'Error Acknowledge');
    });

    getUserStatus();
    AppComponentBase.getInstance().showProgressDialog(false);
    callVerify = false;
    FlutterInappPurchase.instance
        .finishTransactionIOS(purchaseDetails?.transactionId ?? '');

    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  Future<bool> startTrialPeriod() async {
    await AppComponentBase.getInstance()
        .getApiInterface()
        .getUserRepository()
        .startTrialPeriod()
        .then((value) {
      CommonToast.getInstance().displayToast(
          message: StringConstants.subscription_trial_period_started);
      getUserStatus();
    }).catchError((onError) {
      print(onError);
      // CommonToast.getInstance().displayToast(message: 'Error Acknowledge');
    });

    return Future<bool>.value(true);
  }

  restorePurchase({required Function onPurchaseRestored}) async {
    if (productsPurchased.isNotEmpty) {
      for (var item in (productsPurchased)) {
        if (item.transactionStateIOS == TransactionState.restored) {
          bool verification = await verifyPurchase(item);
          if (verification == true) {
            onPurchaseRestored();
            break;
          } else {
            print("verify purchase = false");
          }
        }
      }

      // CommonToast.getInstance().displayToast(message: "Purchase restored");
    } else {
      // CommonToast.getInstance().displayToast(message: "No Purchase found, please subscirbe");
    }
  }

  purchaseOn() async {
    try {
      callVerify = true;
      EasyLoading.show();

      IAPItem? product;
      debugPrint(
          'Available products: ${products.map((e) => e.productId).join(", ")}');
      debugPrint('Attempting to purchase: ${getCurrentSubscription()}');

      products.forEach((e) {
        if (e.productId == getCurrentSubscription()) {
          product = e;
        }
      });

      if (product == null) {
        debugPrint('Product not found in available products list');
        EasyLoading.dismiss();
        return;
      }

      await FlutterInappPurchase.instance
          .requestSubscription(product?.productId ?? '');
    } catch (error) {
      debugPrint('Purchase error: ${error.toString()}');
      EasyLoading.dismiss();
      callVerify = false;
    }
  }

  bool btnShow() {
    if ((subscriptionDetail?.isSubscription ?? 0) == 0 &&
        (subscriptionDetail?.isTrial ?? 0) == 0) {
      return true;
    } else {
      return !(getCurrentSubscription() == (subscriptionDetail?.itemId ?? ''));
    }
  }

  Future<void> updateReminderEndTrialPopup(bool isActivated) async {
    SharedPreference pref =
        AppComponentBase.getInstance().getSharedPreference();
    subscriptionState['shouldReminderTrialEnd'] = isActivated;
    await pref.setShouldReminderTrialEnd(isActivated);
  }

  Future<void> updateTrialStatus(bool isActivated) async {
    var environment = dotenv.env['IS_RELEASE'] == 'true' ? 'prod' : 'dev';
    if (environment == 'dev') {
      debugPrint("---> updateTrialStatus");

      await AppComponentBase.getInstance()
          .getApiInterface()
          .getUserRepository()
          .updateTrialStatus(isActivated)
          .then((value) {
        CommonToast.getInstance().displayToast(message: 'User state updated');
      }).catchError((onError) {
        print(onError);
        // CommonToast.getInstance().displayToast(message: 'Error Acknowledge');
      });
    }
  }

  Future<void> resetUserSubscriptionInfos() async {
    var environment = dotenv.env['IS_RELEASE'] == 'true' ? 'prod' : 'dev';
    if (environment == 'dev') {
      debugPrint("---> updateTrialStatus");

      await updateReminderEndTrialPopup(true);
      productsPurchased = [];

      await AppComponentBase.getInstance()
          .getApiInterface()
          .getUserRepository()
          .resetUserSubscriptionInfos()
          .then((value) {
        CommonToast.getInstance()
            .displayToast(message: 'User subscription infos cleared');
      }).catchError((onError) {
        print(onError);
        // CommonToast.getInstance().displayToast(message: 'Error Acknowledge');
      });
    }
  }

  Future<bool?> checkiOSSubscription() async {
    List<PurchasedItem>? itemsPurchases =
        await FlutterInappPurchase.instance.getAvailablePurchases();

    debugPrint("---> _checkiOSSubscription called ${itemsPurchases?.length}");

    if (Platform.isIOS) {
      try {
        if (itemsPurchases != null && itemsPurchases.isNotEmpty) {
          EasyLoading.show(status: 'Checking subscription... ');
          for (var purchase in itemsPurchases) {
            // Check if this is a valid purchase
            if (purchase.transactionStateIOS == TransactionState.purchased ||
                purchase.transactionStateIOS == TransactionState.restored) {
              debugPrint("Found existing iOS purchase: ${purchase.productId}");

              // Verify the purchase
              bool valid = await verifyPurchase(purchase);
              debugPrint("---> valid $valid ");
              if (valid == true) {
                EasyLoading.dismiss();
                return true;

                break; // Exit the loop if a valid purchase is found
              }
            }
          }
          EasyLoading.dismiss();
        } else {
          debugPrint("No available purchases found");
        }
      } catch (e) {
        debugPrint("Error checking iOS subscription: $e");
      }
    } else {
      EasyLoading.dismiss();
    }
  }
}
