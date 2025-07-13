import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/app_component_base.dart';

class Validation {
  static final reg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static final reg2 = RegExp(r'^[0-9,]+$');
  static final reg3 = RegExp(r'^[0-9,.]+$');
  static bool checkIsEmpty({
    @required TextEditingController? textEditingController,
    @required String? msg,
  }) {
    if (textEditingController!.text.trim().isEmpty) {
      CommonToast.getInstance().displayToast(message: msg ?? '');
    }
    return textEditingController.text.trim().isEmpty;
  }

  static bool checkLength(
      {@required TextEditingController? textEditingController,
      @required int? length,
      @required String? msg}) {
    if (textEditingController!.text.length < length!) {
      CommonToast.getInstance().displayToast(message: msg ?? '');
    }
    return textEditingController.text.length < length;
  }

  static bool isNotValidEmail(
      {@required TextEditingController? textEditingController}) {
    if (!reg.hasMatch(textEditingController!.text)) {
      CommonToast.getInstance()
          .displayToast(message: StringConstants.pleaseEnterValidEmail);
    }
    return !reg.hasMatch(textEditingController.text);
  }

  static bool isNotValidNumber(
      {@required TextEditingController? textEditingController,
      @required String? msg}) {
    if (!reg2.hasMatch(textEditingController!.text)) {
      CommonToast.getInstance().displayToast(message: msg ?? '');
    }
    return !reg2.hasMatch(textEditingController.text);
  }

  static bool isNotValidPrice(
      {@required TextEditingController? textEditingController,
      @required String? msg}) {
    if (!reg3.hasMatch(textEditingController!.text)) {
      CommonToast.getInstance().displayToast(message: msg ?? '');
    }
    return !reg3.hasMatch(textEditingController.text);
  }

  static bool isNotValidPassword(
      {@required TextEditingController? textEditingController,
      @required String? msg}) {
    bool hasUppercase =
        textEditingController!.text.contains(new RegExp(r'[A-Z]'));
    bool hasLowercase =
        textEditingController.text.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters = textEditingController.text
        .contains(new RegExp(r'[`~!@#$%^&*()-+={}\[\]|\\;:,.<>/?"]'));
    bool hasMinLength = textEditingController.text.length > 7;

    if (hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength) {
    } else {
      CommonToast.getInstance().displayToast(message: msg ?? '');
    }
    return !(hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength);
  }

  static bool areDatesAcceptable({
    required String pDate,
    required String cDate,
    required String msg,
  }) {
    try {
      final dateFormatter = DateFormat(
          AppComponentBase.getInstance().getLoginData().user?.date_format);

      DateTime purchaseDate = dateFormatter.parse(pDate);
      DateTime currentDate = dateFormatter.parse(cDate);

      if (currentDate.isBefore(purchaseDate)) {
        CommonToast.getInstance().displayToast(message: msg);
        return true;
      }
      return false;
    } catch (e) {
      CommonToast.getInstance().displayToast(message: "Invalid date format");
      return false;
    }
  }

  static bool areMilagesAcceptable(
      {@required TextEditingController? pMile,
      @required TextEditingController? cMile,
      @required String? msg}) {
    double purchaseMile = double.parse(pMile!.text.split(',').join(''));
    double currentMile = double.parse(cMile!.text.split(',').join(''));
    if (purchaseMile > currentMile) {
      CommonToast.getInstance().displayToast(message: msg ?? '');
    }
    return purchaseMile > currentMile;
  }
}
