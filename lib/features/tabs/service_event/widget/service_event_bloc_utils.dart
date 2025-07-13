import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/validation_service/validation.dart';
import 'package:myride901/features/tabs/service_event/add_service_event/add_service_event_bloc.dart';
import 'package:myride901/features/tabs/service_event/edit_service_event/edit_service_event_bloc.dart';
import 'package:myride901/features/tabs/service_event/widget/add_event_add_provider_to_event.dart';
import 'package:myride901/features/tabs/service_event/widget/edit_event_add_provider_to_event.dart';
import 'package:myride901/features/tabs/service_event/widget/add_service_detail_bottom_sheet.dart';
import 'package:myride901/features/tabs/service_event/widget/service_detail_add.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/auth/widget/white_button.dart';
import 'package:myride901/features/tabs/service_event/service_detail/widget/add_attachment.dart';

Future checkFileSize(File value, BuildContext context) async {
  int fileSizeInBytes = await value.length();
  double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

  if (fileSizeInMB > 200) {
    CommonToast.getInstance().displayToast(message: StringConstants.file_limit);
    return false;
  }

  return true;
}

Future<void> processFile(
    File value,
    BuildContext context,
    String type,
    StreamController mainStreamController,
    List<Attachments> profilePic,
    String? extensionName) async {
  var now = DateTime.now();
  var formatter = DateFormat(
      (AppComponentBase.getInstance().getLoginData().user?.date_format ??
              'yyyy-MM-dd') +
          ' HH:mm:ss');
  String formattedDate = formatter.format(now);

  profilePic.add(Attachments(
    type: 'file',
    createdAt: formattedDate,
    attachmentUrl: value,
    docType: type,
    id: -1,
    extensionName: extensionName,
  ));

  mainStreamController.sink.add(true);
}

bool checkValidation(
  TextEditingController txtEventName,
  TextEditingController txtDate,
  TextEditingController txtMile,
) {
  // return true;
  if (Validation.checkIsEmpty(
      textEditingController: txtEventName,
      msg: StringConstants.pleaseEnterEvent)) {
    return false;
  } else if (Validation.checkIsEmpty(
      textEditingController: txtDate,
      msg: StringConstants.pleaseSelectServiceDate)) {
    return false;
  } else if (Validation.checkIsEmpty(
      textEditingController: txtMile,
      msg: StringConstants.pleaseEnterMileage)) {
    return false;
  } else if (txtMile.text != '' &&
      Validation.isNotValidNumber(
          textEditingController: txtMile,
          msg: StringConstants.Please_hint_valid_enter_mileage)) {
    return false;
  } else {
    return true;
  }
}

bool checkUserInfos(
  TextEditingController? txtName,
  TextEditingController? txtEmail,
  TextEditingController? txtPhoneNum,
) {
  // return true;
  if (Validation.checkIsEmpty(
      textEditingController: txtName,
      msg: StringConstants.pleaseEnterContact)) {
    return false;
  } else if (txtEmail!.text != '' &&
      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(txtEmail.text)) {
    CommonToast.getInstance()
        .displayToast(message: StringConstants.pleaseEnterValidEmail);
    return false;
  } else if (txtPhoneNum!.text != '' &&
      !RegExp(r"^\([0-9]{3}\) [0-9]{3}-[0-9]{4}").hasMatch(txtPhoneNum.text)) {
    CommonToast.getInstance()
        .displayToast(message: StringConstants.pleaseEnterValidPhoneNumber);
    return false;
  } else {
    return true;
  }
}

bool checkEventInfo(
  TextEditingController? txtEventName,
  TextEditingController? txtDate,
  TextEditingController? txtMile,
) {
  // return true;
  if (Validation.checkIsEmpty(
      textEditingController: txtEventName,
      msg: StringConstants.pleaseEnterEvent)) {
    return false;
  } else if (Validation.checkIsEmpty(
      textEditingController: txtDate,
      msg: StringConstants.pleaseSelectServiceDate)) {
    return false;
  } else if (Validation.checkIsEmpty(
      textEditingController: txtMile,
      msg: StringConstants.pleaseEnterMileage)) {
    return false;
  } else if (txtMile?.text != '' &&
      Validation.isNotValidNumber(
          textEditingController: txtMile,
          msg: StringConstants.Please_hint_valid_enter_mileage)) {
    return false;
  } else {
    return true;
  }
}

void openEditSheetAddProvider(
    {BuildContext? context, EditServiceEventBloc? editServiceEventBloc}) {
  showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context!,
      builder: (context) {
        return StreamBuilder<bool>(
            initialData: null,
            stream: editServiceEventBloc?.mainStream,
            builder: (context, snapshot) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return EditEventAddProviderSheet(
                    editServiceEventBloc: editServiceEventBloc,
                  );
                },
              );
            });
      });
}

void openAddSheetAddProvider(
    {BuildContext? context, AddServiceEventBloc? addServiceEventBloc}) {
  showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context!,
      builder: (context) {
        return StreamBuilder<bool>(
            initialData: null,
            stream: addServiceEventBloc?.mainStream,
            builder: (context, snapshot) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AddEventAddProviderSheet(
                    addServiceEventBloc: addServiceEventBloc,
                  );
                },
              );
            });
      });
}

void openSheetService(
    {BuildContext? context,
    int? index,
    Details? details,
    bool? isHidePrice,
    dynamic Function(Details?)? onSave}) {
  showModalBottomSheet(
    context: context!,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: AddServiceBottomSheet(
          type: [
            StringConstants.service,
            StringConstants.parts,
            StringConstants.engine,
            StringConstants.fuel,
            StringConstants.ignition,
            StringConstants.transmission,
            StringConstants.suspension,
            StringConstants.steering,
            StringConstants.brakingSys,
            StringConstants.electricSys,
            StringConstants.bodywork,
            StringConstants.computing,
            StringConstants.tax
          ],
          details: details,
          isHidePrice: isHidePrice,
          onSave: onSave,
        ),
      );
    },
  );
}

void openSheetGallery({
  BuildContext? context,
  dynamic Function()? onDocumentClick,
  dynamic Function()? onGalleryClick,
  dynamic Function()? onTakePhotoClick,
  dynamic Function()? onVideoClick,
}) {
  showModalBottomSheet(
    context: context!,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return AddAttachment(
        onDocumentClick: onDocumentClick,
        onGalleryClick: onGalleryClick,
        onTakePhotoClick: onTakePhotoClick,
        onVideoClick: onVideoClick,
      );
    },
  );
}

void openSheetScanner({
  BuildContext? context,
  dynamic Function()? onDocumentClick,
  dynamic Function()? onGalleryClick,
  dynamic Function()? onTakePhotoClick,
}) {
  showModalBottomSheet(
    context: context!,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return AddAttachment(
        onlyScanner: true,
        onDocumentClick: onDocumentClick,
        onGalleryClick: onGalleryClick,
        onTakePhotoClick: onTakePhotoClick,
      );
    },
  );
}

void openSheetVerify(
    {BuildContext? context,
    Stream<bool>? stream,
    VehicleProfile? vehicleProfile,
    List<Details>? serviceDetail,
    Function? onServiceActionPress,
    dynamic Function()? onPress,
    List<Details>? values}) {
  showModalBottomSheet(
    context: context!,
    isDismissible: false,
    isScrollControlled: true,
    builder: (context) {
      return StreamBuilder<bool>(
        stream: stream,
        builder: (context, snapshot) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ServiceDetailAdd(
                    isScanner: true,
                    vehicleProfile: vehicleProfile,
                    serviceDetail: serviceDetail,
                    onServiceActionPress: onServiceActionPress,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                    child: Column(children: [
                      BlueButton(
                        text: StringConstants.add_service_detail,
                        onPress: () => onServiceActionPress?.call('add', -1),
                      ),
                      SizedBox(height: 10),
                      BlueButton(
                        text: StringConstants.confirm,
                        onPress: onPress,
                      ),
                      SizedBox(height: 10),
                      WhiteButton(
                        text: StringConstants.cancelSmall,
                        onPress: () {
                          values?.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ).whenComplete(() {
    values?.clear();
  });
}

void showLoading(BuildContext? context) {
  if (context != null) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
