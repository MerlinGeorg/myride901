import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/reminder/reminder.dart';
import 'package:myride901/models/service_chat/service_chat.dart';
import 'package:myride901/models/service_provider/service_provider.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/service_event/service_detail/widget/add_attachment.dart';

class ServiceEventDetailBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  VehicleProfile? vehicleProfile;
  VehicleService? vehicleService;
  VehicleProvider? vehicleProvider;
  List<ServiceChat> arrServiceChat = [];
  TextEditingController txtComment = TextEditingController();
  TextEditingController txtNote = TextEditingController();
  TextEditingController? serviceProviderId = TextEditingController();
  int pageChat = 1;
  bool pageMore = true;
  bool? isReminder;
  bool? isReminderEdit;
  ScrollController chatScrollController = ScrollController();
  List<String>? reminderData;
  String? val;
  Reminder? reminder;

  @override
  void dispose() {
    mainStreamController.close();
  }

  void btnBackClicked({BuildContext? context}) {
    Navigator.pop(context!);
  }

  void openSheet({BuildContext? context}) {
    showModalBottomSheet(
        context: context!,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return AddAttachment(
            onDocumentClick: () {
              Navigator.pop(context);
              Utils.docFromGallery().then((value) {
                if (value != null) {
                  var a = value.path.split('.');
                  var b = StringConstants.arrAudio
                      .contains(a[a.length - 1].toLowerCase());
                  var now = new DateTime.now();
                  var formatter = new DateFormat((AppComponentBase.getInstance()
                              .getLoginData()
                              .user
                              ?.date_format ??
                          'yyyy-MM-dd') +
                      ' HH:mm:ss');
                  String formattedDate = formatter.format(now);
                  btnUpdateClicked(
                      context: context,
                      image: value,
                      type: b ? '2' : '4',
                      date: formattedDate,
                      isScroll: true);
                }
              });
            },
            onGalleryClick: () {
              Navigator.pop(context);
              Utils.imgFromGallery().then((value) {
                if (value != null) {
                  var now = new DateTime.now();
                  var formatter = new DateFormat((AppComponentBase.getInstance()
                              .getLoginData()
                              .user
                              ?.date_format ??
                          'yyyy-MM-dd') +
                      ' HH:mm:ss');
                  String formattedDate = formatter.format(now);
                  btnUpdateClicked(
                      context: context,
                      image: value,
                      date: formattedDate,
                      isScroll: true);
                }
              });
            },
            onTakePhotoClick: () {
              Navigator.pop(context);
              Utils.imgFromCamera().then((value) {
                if (value != null) {
                  var now = new DateTime.now();
                  var formatter = new DateFormat((AppComponentBase.getInstance()
                              .getLoginData()
                              .user
                              ?.date_format ??
                          'yyyy-MM-dd') +
                      ' HH:mm:ss');
                  String formattedDate = formatter.format(now);
                  btnUpdateClicked(
                      context: context,
                      image: value,
                      date: formattedDate,
                      isScroll: true);
                }
              });
            },
          );
        });
  }

  void btnUpdateClicked(
      {BuildContext? context,
      File? image,
      String delete_image = '',
      String date = '',
      String type = '1',
      bool isScroll = false}) {
    List<File> img = [];
    List<String> attachmentDates = [];
    List<String> attachmentTypes = [];

    if (image != null) {
      img = [image];
      attachmentDates = [date];
      attachmentTypes = [type];
    }

    List<String> category = [];
    List<String> description = [];

    for (Details a in vehicleService?.details ?? []) {
      category.add(a.category ?? '');
      description.add(a.description ?? '');
    }
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .updateServiceEvent(
          vehicle_id: vehicleProfile?.id.toString(),
          serviceProviderId: vehicleService!.serviceProviderId.toString(),
          notes: vehicleService?.notes ?? '',
          category: category,
          description: description,
          detail_1: vehicleService?.detail1 ?? '',
          detail_2: vehicleService?.detail2 ?? '',
          detail_3: vehicleService?.detail3 ?? '',
          mileage: vehicleService?.mileage ?? '',
          service_attachment: img,
          service_date: vehicleService?.serviceDate ?? '',
          attachment_dates: attachmentDates,
          attachment_type: attachmentTypes,
          title: vehicleService?.title ?? '',
          avatar: vehicleService?.avatar,
          delete_attachment: delete_image,
          eventId: vehicleService?.id,
        )
        .then((value) {
      getVehicleServiceByServiceId(context: context!, isScroll: isScroll);
    }).catchError((onError) {
      print(onError);
    });
  }

  void btnNoteSaveClicked({BuildContext? context}) {
    FocusScope.of(context!).requestFocus(FocusNode());

    List<String> category = [];
    List<String> description = [];
    List<String> price = [];

    for (Details a in vehicleService?.details ?? []) {
      category.add(a.category ?? '');
      description.add(a.description ?? '');
      price.add(a.price ?? '');
    }
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .updateServiceEvent(
          vehicle_id: vehicleProfile?.id.toString(),
          serviceProviderId: serviceProviderId!.text,
          notes: txtNote.text,
          category: category,
          description: description,
          price: price,
          detail_1: vehicleService?.detail1 ?? '',
          detail_2: vehicleService?.detail2 ?? '',
          detail_3: vehicleService?.detail3 ?? '',
          mileage: vehicleService?.mileage ?? '',
          service_attachment: [],
          service_date: vehicleService?.serviceDate ?? '',
          attachment_dates: [],
          attachment_type: [],
          title: vehicleService?.title ?? '',
          delete_attachment: '',
          avatar: vehicleService?.avatar,
          eventId: vehicleService?.id,
        )
        .then((value) {
      getVehicleServiceByServiceId(
          context: context, isScroll: true, message: value);
    }).catchError((onError) {
      print(onError);
    });
  }

  void getVehicleServiceByServiceId(
      {BuildContext? context, bool isScroll = false, String message = ''}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicleServiceByServiceId(
          serviceId: vehicleService!.id.toString(),
          vehicle_id: vehicleProfile!.id.toString(),
          id: vehicleService!.id.toString(),
        )
        .then((value) {
      if (message != '') {
        CommonToast.getInstance().displayToast(message: message);
      }
      if (value.length > 0) {
        vehicleService = value[0];
        txtNote.text = vehicleService?.notes ?? '';
      }
      if (vehicleService?.serviceProviderId != null) {
        getVehicleProviderByProviderId(context: context);
      }

      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void getVehicleProviderByProviderId(
      {BuildContext? context, bool isScroll = false, String message = ''}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicleProviderByProviderId(
            providerId: vehicleService?.serviceProviderId.toString(),
            id: vehicleService?.serviceProviderId.toString())
        .then((value) {
      if (value.length > 0) {
        if (message != '') {
          CommonToast.getInstance().displayToast(message: message);
        }
        vehicleProvider = value[0];
      }
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void getServiceChatByServiceId({BuildContext? context, isFirst = true}) {
    if (pageMore) {
      pageMore = false;
      if (isFirst) {
        pageChat = 1;
        arrServiceChat = [];
      } else {
        pageChat = pageChat + 1;
      }
      mainStreamController.sink.add(true);
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .getServiceChatByServiceId(
              serviceId: vehicleService?.id.toString(), page: pageChat)
          .then((value) {
        if ((value['data'] ?? []).length != 0) {
          pageMore = value["current_page"] != value["last_page"];
          List<ServiceChat> vp = [];
          for (var a in value["data"] ?? []) {
            vp.add(ServiceChat.fromJson(a));
          }
          arrServiceChat.addAll(vp);
          List<ServiceChat> resArr = [];
          arrServiceChat.forEach((item) {
            var i = resArr.indexWhere((x) => x.id == item.id);
            if (i <= -1) {
              resArr.add(item);
            }
          });
          arrServiceChat = resArr;
        }
        mainStreamController.sink.add(true);
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  void addServiceChat({BuildContext? context}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .addServiceChat(
            serviceId: vehicleService?.id.toString(), message: txtComment.text)
        .then((value) {
      arrServiceChat.insert(0, value);
      txtComment.text = '';
      chatScrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void deleteServiceChat({BuildContext? context, int? index}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .deleteServiceChat(arrServiceChat[index!].id.toString())
        .then((value) {
      CommonToast.getInstance().displayToast(message: value);
      arrServiceChat.removeAt(index);
      mainStreamController.sink.add(true);
    }).catchError((onError) {
      print(onError);
    });
  }

  void btnEditClicked({BuildContext? context}) {
    Navigator.of(context!, rootNavigator: false)
        .pushNamed(RouteName.editEvent,
            arguments: ItemArgument(data: {
              'isEdit': true,
              'vehicleService': vehicleService,
              'vehicleProfile': vehicleProfile,
              'vehicleProvider': vehicleProvider,
              'isReminder': isReminder,
              'isReminderEdit': isReminderEdit,
              'value': val,
              'reminderData': reminderData,
              'reminder': reminder
            }))
        .then((value) {
      getVehicleServiceByServiceId(context: context);
    });
  }

  Future<void> btnDeleteClicked({BuildContext? context}) async {
    Utils.showAlertDialogCallBack1(
        context: context,
        message:
            'You are about to delete all data and attachments for the ${vehicleService?.title ?? ''} service. Please click Cancel or Confirm, below.',
        isConfirmationDialog: false,
        isOnlyOK: false,
        navBtnName: 'Cancel',
        posBtnName: 'Confirm',
        onNavClick: () {},
        onPosClick: () async {
          await deleteService(context: context!);
        });
  }

  Future<void> deleteService({BuildContext? context}) async {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .deleteServiceEvent(vehicleService!)
        .then((value) {
      Utils.getDetail();
      CommonToast.getInstance().displayToast(message: value);
      AppComponentBase.getInstance().load(true);
      Navigator.pushNamed(context!, RouteName.dashboard);
    }).catchError((onError) {
      print(onError);
    });
  }

  void btnShareClicked({BuildContext? context}) {
    Navigator.pushNamed(context!, RouteName.serviceShareOption,
        arguments: ItemArgument(data: {
          'vehicleProfile': vehicleProfile,
          'serviceIds': vehicleService?.id.toString()
        }));
  }
}
