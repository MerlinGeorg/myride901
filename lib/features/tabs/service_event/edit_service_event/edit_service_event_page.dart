import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/features/subscription/subscription_bloc.dart';
import 'package:myride901/features/subscription/widgets/subscription_info_popup.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/custom_icon_tab.dart';
import 'package:myride901/features/tabs/service_event/edit_service_event/edit_service_event_bloc.dart';
import 'package:myride901/features/tabs/service_event/widget/edit_event_tab_view.dart';
import 'package:myride901/features/tabs/service_event/widget/header.dart';
import 'package:myride901/features/tabs/service_event/widget/add_note_tab_view.dart';
import 'package:myride901/features/tabs/service_event/widget/provider_selection_bottom_sheet.dart';
import 'package:myride901/features/tabs/service_event/widget/service_event_bloc_utils.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:open_file/open_file.dart';

class EditServiceEventPage extends StatefulWidget {
  @override
  _EditServiceEventPageState createState() => _EditServiceEventPageState();
}

class _EditServiceEventPageState extends State<EditServiceEventPage>
    with SingleTickerProviderStateMixin {
  EditServiceEventBloc _editServiceEventBloc = EditServiceEventBloc();
  final _subscriptionBloc = SubscriptionBloc();
  AppThemeState _appTheme = AppThemeState();
  bool isActive = false;

  int headerSize = 170;
  bool isProfilePictureVisible = true;
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _editServiceEventBloc.arguments =
          (ModalRoute.of(context)!.settings.arguments as ItemArgument).data;
      if (_editServiceEventBloc.arguments['vehicleProvider'] != null) {
        _editServiceEventBloc.vehicleProvider =
            _editServiceEventBloc.arguments['vehicleProvider'];
        _editServiceEventBloc.txtProvId?.text =
            _editServiceEventBloc.vehicleProvider?.id.toString() ?? '';
        _editServiceEventBloc.getVehicleProviderByProviderId(context: context);
      }

      if (_editServiceEventBloc.arguments['isEdit'] != null) {
        _editServiceEventBloc.vehicleService =
            _editServiceEventBloc.arguments['vehicleService'];
      }
      if (_editServiceEventBloc.arguments['isReminder'] != null) {
        _editServiceEventBloc.isReminder =
            _editServiceEventBloc.arguments['isReminder'];
      }
      if (_editServiceEventBloc.arguments['reminder'] != null) {
        _editServiceEventBloc.reminder =
            _editServiceEventBloc.arguments['reminder'];
      }
      if (_editServiceEventBloc.arguments['isReminderEdit'] != null) {
        _editServiceEventBloc.isReminderEdit =
            _editServiceEventBloc.arguments['isReminderEdit'];
      }
      if (_editServiceEventBloc.arguments['value'] != null) {
        _editServiceEventBloc.val = _editServiceEventBloc.arguments['value'];
      }
      if (_editServiceEventBloc.arguments['reminderData'] != null) {
        _editServiceEventBloc.reminderData =
            _editServiceEventBloc.arguments['reminderData'];
      }
      if (_editServiceEventBloc.arguments['data'] != null &&
          _editServiceEventBloc.arguments['data']['service_events'] != null) {
        RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
        _editServiceEventBloc.txtMile.text =
            (_editServiceEventBloc.arguments['data']['next_mileage'] ?? 0)
                .toString()
                .replaceAllMapped(reg, (Match match) => '${match[1]},');
        _editServiceEventBloc.data =
            _editServiceEventBloc.arguments['data']['service_events'];
        (_editServiceEventBloc.data ?? []).forEach((element) {
          _editServiceEventBloc.arrServiceList.add(Details(
              category: '1',
              categoryName: 'Service',
              description: element,
              price: '0'));
        });
      }
      _editServiceEventBloc.getVehicleList(context: context);
      _subscriptionBloc.getUserStatus();
    });

    tabController = TabController(length: 2, vsync: this);

    tabController!.addListener(() {
      if (tabController!.index == 1) {
        setState(() {
          headerSize = 0;
          isProfilePictureVisible = false;
        });
      } else if (tabController!.index != 1) {
        setState(() {
          headerSize = 170;
          isProfilePictureVisible = true;
        });
      }
    });
    _editServiceEventBloc.getProviderList(
      context: context,
    );
    _editServiceEventBloc.txtNote.addListener(onTextChange);
  }

  @override
  void dispose() {
    _editServiceEventBloc.txtNote.dispose();
    super.dispose();
  }

  void onTextChange() {
    if (_editServiceEventBloc.vehicleService?.notes !=
        _editServiceEventBloc.txtNote.text) {
      setState(() {
        isActive = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    _editServiceEventBloc.arguments =
        (ModalRoute.of(context)!.settings.arguments as ItemArgument).data;

    if (_editServiceEventBloc.arguments['isEdit'] &&
        _editServiceEventBloc.vehicleService == null) {
      _editServiceEventBloc.vehicleService =
          _editServiceEventBloc.arguments['vehicleService'];
      _editServiceEventBloc.txtProvId?.text =
          _editServiceEventBloc.vehicleProvider?.id.toString() ?? '';
      _editServiceEventBloc.txtEventName.text =
          _editServiceEventBloc.vehicleService?.title ?? '';
      _editServiceEventBloc.selectedAvatar =
          _editServiceEventBloc.vehicleService?.avatar ?? '';
      _editServiceEventBloc.txtDate.text =
          _editServiceEventBloc.vehicleService?.serviceDate ?? '';
      _editServiceEventBloc.txtMile.text =
          _editServiceEventBloc.vehicleService?.mileage ?? '';
      _editServiceEventBloc.txtNote.text =
          _editServiceEventBloc.vehicleService?.notes ?? '';
      _editServiceEventBloc.arrServiceList =
          _editServiceEventBloc.vehicleService?.details ?? [];
      for (int i = 0;
          i < (_editServiceEventBloc.vehicleService?.attachments ?? []).length;
          i++) {
        Attachments attachments =
            (_editServiceEventBloc.vehicleService?.attachments ?? [])[i];
        attachments.type = 'url';
        _editServiceEventBloc.profilePic.add(attachments);
      }

      setState(() {});
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
        initialData: null,
        stream: _editServiceEventBloc.mainStream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: _appTheme.primaryColor,
              elevation: 0,
              title: Text(
                StringConstants.Update_Service_Event,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white),
              ),
              leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(AssetImages.left_arrow),
                ),
              ),
            ),
            body: BlocProvider<EditServiceEventBloc>(
              bloc: _editServiceEventBloc,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: _editServiceEventBloc.arrVehicle == null
                    ? Container()
                    : Scaffold(
                        backgroundColor: Colors.white,
                        body: Column(
                          children: [
                            Expanded(
                              child: DefaultTabController(
                                length: 2,
                                child: NestedScrollView(
                                  headerSliverBuilder: (context, value) {
                                    return [sliverBar()];
                                  },
                                  body: tabBarComponent(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: tabController!.index != 1
                                  ? BlueButton(
                                      text: StringConstants.save,
                                      onPress: () async {
                                        _editServiceEventBloc.btnUpdateClicked(
                                            context: context);
                                      })
                                  : BlueButton(
                                      text: "DONE",
                                      onPress: () async {
                                        setState(() {
                                          isActive = false;
                                          _editServiceEventBloc
                                                  .vehicleService?.notes =
                                              _editServiceEventBloc
                                                  .txtNote.text;
                                        });
                                        _editServiceEventBloc.btnUpdateClicked2(
                                            context: context);
                                      },
                                      enable: isActive,
                                    ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  sliverBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      floating: true,
      pinned: true,
      leading: null,
      bottom: TabBar(
        unselectedLabelColor: Colors.black.withOpacity(0.5),
        onTap: (int i) {
          _editServiceEventBloc.selectedIndex = i;
        },
        labelColor: AppTheme.of(context).primaryColor,
        indicatorColor: AppTheme.of(context).primaryColor,
        controller: tabController,
        labelStyle:
            GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold),
        tabs: [
          SizedBox(
            height: 40,
            child: Tab(
              iconMargin: const EdgeInsets.only(bottom: 0),
              text: '',
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIcon(AssetImages.service, size: 17),
                  SizedBox(width: 5),
                  Text(
                    StringConstants.event_c,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500, fontSize: 14),
                  )
                ],
              ),
            ),
          ),
          if (_editServiceEventBloc
                  .arrVehicle?[_editServiceEventBloc.selectedVehicle]
                  .isMyVehicle !=
              0)
            SizedBox(
              height: 40,
              child: Tab(
                text: '',
                iconMargin: const EdgeInsets.only(bottom: 0),
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIcon(AssetImages.note_1, size: 24),
                    SizedBox(width: 5),
                    Text(
                      StringConstants.note.toUpperCase(),
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
      expandedHeight: headerSize.toDouble(),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Visibility(
          visible: isProfilePictureVisible,
          child: Header(
            textEditingController: TextEditingController(),
            onVehicleSelect: (value) {
              setState(() {
                _editServiceEventBloc.selectedVehicle = value;
              });
            },
            isEdit: _editServiceEventBloc.arguments['isEdit'],
            vehicleList: _editServiceEventBloc.arrVehicle ?? [],
            selectedVehicle: _editServiceEventBloc.selectedVehicle,
          ),
        ),
      ),
    );
  }

  tabBarComponent() {
    return TabBarView(
      controller: tabController,
      children: [
        EditEventTabView(
          vehicleProfile: _editServiceEventBloc
              .arrVehicle?[_editServiceEventBloc.selectedVehicle],
          selectedAvatar: _editServiceEventBloc.selectedAvatar,
          onAvatarClick: (str) {
            _editServiceEventBloc.selectedAvatar = str;
            setState(() {});
          },
          value: _editServiceEventBloc
                      .arrVehicle?[_editServiceEventBloc.selectedVehicle]
                      .isMyVehicle ==
                  0
              ? true
              : false,
          textEditingControllerMile: _editServiceEventBloc.txtMile,
          textEditingControllerDate: _editServiceEventBloc.txtDate,
          textEditingControllerEventName: _editServiceEventBloc.txtEventName,
          textEditingControllerProvId: _editServiceEventBloc.txtProvId,
          name: _editServiceEventBloc.vehicleProvider?.name ?? '',
          email: _editServiceEventBloc.vehicleProvider?.email ?? '',
          phone: _editServiceEventBloc.vehicleProvider?.phone ?? '',
          openModal: () {
            showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              ),
              context: context,
              builder: (context) {
                return ProviderSelectionBottomSheet(
                  providers: _editServiceEventBloc.arrProvider,
                  onTap: (selectedProvider) {
                    _editServiceEventBloc.vehicleProvider = selectedProvider;
                    _editServiceEventBloc.txtProvId?.text =
                        _editServiceEventBloc.vehicleProvider?.id.toString() ??
                            '';
                    _editServiceEventBloc.getVehicleProviderByProviderId(
                        context: context);
                    print(_editServiceEventBloc.vehicleProvider?.id.toString());
                    _editServiceEventBloc.mainStreamController.sink.add(true);
                  },
                );
              },
            );
          },
          addProd: () {
            openEditSheetAddProvider(
              context: context,
              editServiceEventBloc: _editServiceEventBloc,
            );
          },
          deleteProd: () {
            setState(() {
              _editServiceEventBloc.txtProvId?.text = '';
            });
          },
          attachmentList: _editServiceEventBloc.profilePic,
          serviceDetailList: _editServiceEventBloc.arrServiceList,
          onServiceActionPress: (action, index) {
            if (action == 'add') {
              openSheetService(
                context: context,
                details: index < 0
                    ? null
                    : _editServiceEventBloc.arrServiceList[index],
                isHidePrice: ((_editServiceEventBloc.arrVehicle ??
                                [])[_editServiceEventBloc.selectedVehicle]
                            .isMyVehicle ??
                        0) ==
                    0,
                onSave: (value) {
                  if (index >= 0) {
                    _editServiceEventBloc.arrServiceList[index] = value!;
                  } else {
                    _editServiceEventBloc.arrServiceList.add(value!);
                  }
                  _editServiceEventBloc.mainStreamController.sink.add(true);
                },
              );
            } else if (action == 'edit') {
              openSheetService(
                context: context,
                index: index,
                details: index == null
                    ? null
                    : _editServiceEventBloc.arrServiceList[index],
                isHidePrice: ((_editServiceEventBloc.arrVehicle ??
                                [])[_editServiceEventBloc.selectedVehicle]
                            .isMyVehicle ??
                        0) ==
                    0,
                onSave: (value) {
                  if (index != null) {
                    _editServiceEventBloc.arrServiceList[index] = value!;
                  } else {
                    _editServiceEventBloc.arrServiceList.add(value!);
                  }
                  _editServiceEventBloc.mainStreamController.sink.add(true);
                },
              );
            } else if (action == 'delete') {
              Utils.showAlertDialogCallBack1(
                  context: context,
                  message: 'Are you sure you want to delete the service list',
                  isConfirmationDialog: false,
                  isOnlyOK: false,
                  navBtnName: 'Cancel',
                  posBtnName: 'Confirm',
                  onNavClick: () {},
                  onPosClick: () {
                    _editServiceEventBloc.arrServiceList.removeAt(index);
                    setState(() {});
                  });
            }
          },
          scanPress: (action, index) {
            if (_subscriptionBloc.subscriptionState['hasProAccess'] == true) {
              if (action == 'scan') {
                openSheetScanner(
                  context: context,
                  onDocumentClick: () async {
                    var value = await Utils.docFromGallery();
                    if (value != null) {
                      String extension =
                          value.path.split('.').last.toLowerCase();
                      if (extension != 'pdf') {
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName(RouteName.editEvent));

                        CommonToast.getInstance()
                            .displayToast(message: "Please select a PDF file.");
                        return;
                      }
                    }
                    handleFile(value, '4', context);
                  },
                  onGalleryClick: () async {
                    var value = await Utils.imgFromGallery();
                    handleFile(value, '1', context);
                  },
                  onTakePhotoClick: () async {
                    var value = await Utils.imgFromCamera();
                    handleFile(value, '1', context);
                  },
                );
                setState(() {});
              }
            } else {
              Utils.displaySubscriptionPopup(
                context,
                SubscriptionFeature.serviceReceipt,
                _subscriptionBloc.subscriptionState,
                RouteName.editEvent,
              );
            }
          },
          onActionPress: (action, index) {
            if (action == 'main') {
              if ((_editServiceEventBloc.profilePic[index].docType ?? '1') ==
                  '1') {
                Utils.showImageDialogCallBack(
                    context: context,
                    image:
                        _editServiceEventBloc.profilePic[index].attachmentUrl);
              } else {
                if (_editServiceEventBloc.profilePic[index].attachmentUrl
                    is String) {
                  Utils.launchURL(
                      _editServiceEventBloc.profilePic[index].attachmentUrl ??
                          '');
                } else {
                  OpenFile.open(
                      (_editServiceEventBloc.profilePic[index].attachmentUrl)
                          .path
                          .toString());
                }
              }
            } else if (action == 'add') {
              openSheetGallery(
                context: context,
                onDocumentClick: () async {
                  showLoading(context);
                  var value = await Utils.docFromGallery();
                  if (value != null) {
                    if (!await checkFileSize(value, context)) {
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName(RouteName.editEvent));
                      return;
                    }

                    var a = value.path.split('.');
                    var b = StringConstants.arrAudio
                        .contains(a[a.length - 1].toLowerCase());

                    await processFile(
                        value,
                        context,
                        b ? '2' : '4',
                        _editServiceEventBloc.mainStreamController,
                        _editServiceEventBloc.profilePic,
                        value.path.split('/').last);
                  }
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(RouteName.editEvent));
                },
                onGalleryClick: () async {
                  showLoading(context);
                  var value = await Utils.imgFromGallery();
                  if (value != null) {
                    if (!await checkFileSize(value, context)) {
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName(RouteName.editEvent));
                      return;
                    }

                    await processFile(
                        value,
                        context,
                        '1',
                        _editServiceEventBloc.mainStreamController,
                        _editServiceEventBloc.profilePic,
                        value.path.split('/').last);
                  }
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(RouteName.editEvent));
                },
                onTakePhotoClick: () async {
                  showLoading(context);
                  var value = await Utils.imgFromCamera();
                  if (value != null) {
                    if (!await checkFileSize(value, context)) {
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName(RouteName.editEvent));
                      return;
                    }
                    await processFile(
                        value,
                        context,
                        '1',
                        _editServiceEventBloc.mainStreamController,
                        _editServiceEventBloc.profilePic,
                        '${DateTime.now().millisecondsSinceEpoch}.png');
                  }
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(RouteName.editEvent));
                },
                onVideoClick: () async {
                  showLoading(context);
                  var value = await Utils.videoFromGallery();
                  if (value != null) {
                    if (!await checkFileSize(value, context)) {
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName(RouteName.editEvent));
                      return;
                    }

                    await processFile(
                        value,
                        context,
                        '3',
                        _editServiceEventBloc.mainStreamController,
                        _editServiceEventBloc.profilePic,
                        value.path.split('/').last);
                  }
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(RouteName.editEvent));
                },
              );
            } else if (action == 'delete') {
              if (_editServiceEventBloc.profilePic[index].type != 'file') {
                _editServiceEventBloc.delete_image =
                    _editServiceEventBloc.delete_image +
                        ',${_editServiceEventBloc.profilePic[index].id}';
              }
              _editServiceEventBloc.profilePic.removeAt(index);
              setState(() {});
            }
          },
        ),
        if (_editServiceEventBloc
                .arrVehicle?[_editServiceEventBloc.selectedVehicle]
                .isMyVehicle !=
            0)
          AddNoteTabView(
            textEditingController: _editServiceEventBloc.txtNote,
            value: _editServiceEventBloc
                        .arrVehicle?[_editServiceEventBloc.selectedVehicle]
                        .isMyVehicle ==
                    0
                ? true
                : false,
          ),
      ],
    );
  }

  void handleFile(File? value, String type, BuildContext context) async {
    if (value != null) {
      showLoading(context);

      if (!await checkFileSize(value, context)) {
        Navigator.of(context)
            .popUntil(ModalRoute.withName(RouteName.editEvent));

        return;
      }

      List<int> imageBytes = await value.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      var now = DateTime.now();
      var formatter = DateFormat(
          (AppComponentBase.getInstance().getLoginData().user?.date_format ??
                  'yyyy-MM-dd') +
              ' HH:mm:ss');
      String formattedDate = formatter.format(now);

      _editServiceEventBloc.formDate = formattedDate;
      _editServiceEventBloc.attachUrl = value;
      _editServiceEventBloc.type = type;
      _editServiceEventBloc.extensionT = value.path.split('/').last;
      await _editServiceEventBloc.scanImage(
          context: context, base64image: base64Image);

      _editServiceEventBloc.mainStreamController.sink.add(true);
      Navigator.of(context).popUntil(ModalRoute.withName(RouteName.editEvent));

      if (_editServiceEventBloc.arrServiceListVerify.isNotEmpty) {
        openSheetVerify(
            context: context,
            stream: _editServiceEventBloc.mainStream,
            vehicleProfile: _editServiceEventBloc
                .arrVehicle?[_editServiceEventBloc.selectedVehicle],
            serviceDetail: _editServiceEventBloc.arrServiceListVerify,
            onServiceActionPress: (action, index) {
              if (action == 'add') {
                openSheetService(
                  context: context,
                  details: index < 0
                      ? null
                      : _editServiceEventBloc.arrServiceListVerify[index],
                  isHidePrice: ((_editServiceEventBloc.arrVehicle ??
                                  [])[_editServiceEventBloc.selectedVehicle]
                              .isMyVehicle ??
                          0) ==
                      0,
                  onSave: (value) {
                    if (index >= 0) {
                      _editServiceEventBloc.arrServiceListVerify[index] =
                          value!;
                    } else {
                      _editServiceEventBloc.arrServiceListVerify.add(value!);
                    }
                    _editServiceEventBloc.mainStreamController.sink.add(true);
                  },
                );
              } else if (action == 'edit') {
                openSheetService(
                  context: context,
                  index: index,
                  details: index == null
                      ? null
                      : _editServiceEventBloc.arrServiceListVerify[index],
                  isHidePrice: ((_editServiceEventBloc.arrVehicle ??
                                  [])[_editServiceEventBloc.selectedVehicle]
                              .isMyVehicle ??
                          0) ==
                      0,
                  onSave: (value) {
                    if (index != null) {
                      _editServiceEventBloc.arrServiceListVerify[index] =
                          value!;
                    } else {
                      _editServiceEventBloc.arrServiceListVerify.add(value!);
                    }
                    _editServiceEventBloc.mainStreamController.sink.add(true);
                  },
                );
              } else if (action == 'delete') {
                Utils.showAlertDialogCallBack1(
                  context: context,
                  message: 'Are you sure you want to delete the service list',
                  isConfirmationDialog: false,
                  isOnlyOK: false,
                  navBtnName: 'Cancel',
                  posBtnName: 'Confirm',
                  onNavClick: () {},
                  onPosClick: () {
                    _editServiceEventBloc.deleteServiceAtIndex(index);
                  },
                );
              }
            },
            onPress: () {
              _editServiceEventBloc.profilePic.add(Attachments(
                type: 'file',
                createdAt: _editServiceEventBloc.formDate,
                attachmentUrl: _editServiceEventBloc.attachUrl,
                docType: _editServiceEventBloc.type,
                id: -1,
                extensionName: _editServiceEventBloc.extensionT,
              ));
              _editServiceEventBloc.arrServiceList
                  .addAll(_editServiceEventBloc.arrServiceListVerify);
              _editServiceEventBloc.arrServiceListVerify = [];
              CommonToast.getInstance()
                  .displayToast(message: StringConstants.details_scanned);
              Navigator.of(context)
                  .popUntil(ModalRoute.withName(RouteName.editEvent));
            },
            values: _editServiceEventBloc.arrServiceListVerify);
      }
    }
  }
}
