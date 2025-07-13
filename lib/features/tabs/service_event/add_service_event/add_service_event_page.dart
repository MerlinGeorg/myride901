import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/features/subscription/subscription_bloc.dart';
import 'package:myride901/features/subscription/widgets/subscription_info_popup.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/common/common_toast.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/custom_icon_tab.dart';
import 'package:myride901/widgets/my_ride_dialog.dart';
import 'package:myride901/features/tabs/service_event/add_service_event/add_service_event_bloc.dart';
import 'package:myride901/features/tabs/service_event/widget/add_event_tab_view.dart';
import 'package:myride901/features/tabs/service_event/widget/header.dart';
import 'package:myride901/features/tabs/service_event/widget/add_note_tab_view.dart';
import 'package:myride901/features/tabs/service_event/widget/provider_selection_bottom_sheet.dart';
import 'package:myride901/features/tabs/service_event/widget/service_event_bloc_utils.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:open_file/open_file.dart';

class AddServiceEventPage extends StatefulWidget {
  @override
  _AddServiceEventPageState createState() => _AddServiceEventPageState();
}

class _AddServiceEventPageState extends State<AddServiceEventPage>
    with SingleTickerProviderStateMixin {
  AddServiceEventBloc _addServiceEventBloc = AddServiceEventBloc();
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
      _addServiceEventBloc.arguments =
          (ModalRoute.of(context)!.settings.arguments as ItemArgument).data;
      _addServiceEventBloc.getProviderList(context: context);
      if (_addServiceEventBloc.arguments['value'] != null) {
        String? receivedValue =
            ((ModalRoute.of(context)!.settings.arguments as ItemArgument).data
                as dynamic)['value'];

        _addServiceEventBloc.val = receivedValue;
      }

      if (_addServiceEventBloc.arguments['reminderData'] != null) {
        _addServiceEventBloc.reminderData =
            _addServiceEventBloc.arguments['reminderData'];
      }
      if (_addServiceEventBloc.arguments['reminder'] != null) {
        _addServiceEventBloc.reminder =
            _addServiceEventBloc.arguments['reminder'];
        print("Irina " + _addServiceEventBloc.reminder!.id.toString());
      }

      if (_addServiceEventBloc.arguments['vehicleProvider'] != null) {
        _addServiceEventBloc.vehicleProvider =
            _addServiceEventBloc.arguments['vehicleProvider'];
        _addServiceEventBloc.getVehicleProviderByProviderId(context: context);
      }
      if (_addServiceEventBloc.arguments['data'] != null &&
          _addServiceEventBloc.arguments['data']['service_events'] != null) {
        RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
        _addServiceEventBloc.txtMile.text =
            (_addServiceEventBloc.arguments['data']['next_mileage'] ?? 0)
                .toString()
                .replaceAllMapped(reg, (Match match) => '${match[1]},');
        _addServiceEventBloc.data =
            _addServiceEventBloc.arguments['data']['service_events'];
        (_addServiceEventBloc.data ?? []).forEach((element) {
          _addServiceEventBloc.arrServiceList.add(Details(
              category: '1',
              categoryName: 'Service',
              description: element,
              price: '0'));
        });
      }
      _addServiceEventBloc.getVehicleList(context: context);
      _subscriptionBloc.getUserStatus();
    });
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      if (tabController!.index == 1) {
        setState(() {
          headerSize = 0;
          isProfilePictureVisible = false;
          isActive = true;
        });
      } else if (tabController!.index != 1) {
        setState(() {
          headerSize = 170;
          isProfilePictureVisible = true;
        });
      }
    });

    _addServiceEventBloc.txtNote.addListener(onTextChange);
    _addServiceEventBloc.txtMile.addListener(requiredData);
    _addServiceEventBloc.txtEventName.addListener(requiredData);
    _addServiceEventBloc.txtDate.addListener(requiredData);
  }

  @override
  void dispose() {
    _addServiceEventBloc.txtNote.dispose();
    super.dispose();
  }

  void onTextChange() {
    if (_addServiceEventBloc.vehicleService?.notes !=
        _addServiceEventBloc.txtNote.text) {
      setState(() {
        isActive = true;
      });
    }
  }

  void requiredData() {
    if (_addServiceEventBloc.txtEventName.text.isNotEmpty &&
        _addServiceEventBloc.txtDate.text.isNotEmpty &&
        _addServiceEventBloc.txtMile.text.isNotEmpty) {
      setState(() {
        isActive = true;
      });
    } else {
      setState(() {
        isActive = false;
      });
    }
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
        stream: _addServiceEventBloc.mainStream,
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: _appTheme.primaryColor,
              elevation: 0,
              title: Text(
                StringConstants.app_add_service_event,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white),
              ),
              leading: InkWell(
                onTap: () => Navigator.pushNamed(context, RouteName.dashboard),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(AssetImages.left_arrow),
                ),
              ),
            ),
            body: BlocProvider<AddServiceEventBloc>(
              bloc: _addServiceEventBloc,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: _addServiceEventBloc.arrVehicle == null
                    ? Container()
                    : Scaffold(
                        resizeToAvoidBottomInset: false,
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
                                  body: Column(
                                    children: [
                                      tabBarComponent(),
                                      _buildButtons(),
                                    ],
                                  ),
                                ),
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
          _addServiceEventBloc.selectedIndex = i;
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
                _addServiceEventBloc.selectedVehicle = value;
              });
            },
            vehicleList: _addServiceEventBloc.arrVehicle ?? [],
            selectedVehicle: _addServiceEventBloc.selectedVehicle,
          ),
        ),
      ),
    );
  }

  tabBarComponent() {
    return Flexible(
      child: TabBarView(
        controller: tabController,
        children: [
          AddEventTabView(
            vehicleProfile: _addServiceEventBloc
                .arrVehicle?[_addServiceEventBloc.selectedVehicle],
            selectedAvatar: _addServiceEventBloc.selectedAvatar,
            onAvatarClick: (str) {
              _addServiceEventBloc.selectedAvatar = str;
              setState(() {});
            },
            textEditingControllerMile: _addServiceEventBloc.txtMile,
            textEditingControllerDate: _addServiceEventBloc.txtDate,
            textEditingControllerEventName: _addServiceEventBloc.txtEventName,
            textEditingControllerProvId: _addServiceEventBloc.txtProvId,
            addServiceEventBloc: _addServiceEventBloc,
            name: _addServiceEventBloc.vehicleProvider?.name ?? '',
            email: _addServiceEventBloc.vehicleProvider?.email ?? '',
            phone: _addServiceEventBloc.vehicleProvider?.phone ?? '',
            openModal: () {
              showModalBottomSheet(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15.0)),
                ),
                context: context,
                builder: (context) {
                  return ProviderSelectionBottomSheet(
                    providers: _addServiceEventBloc.arrProvider,
                    onTap: (selectedProvider) {
                      _addServiceEventBloc.vehicleProvider = selectedProvider;
                      _addServiceEventBloc.txtProvId?.text =
                          _addServiceEventBloc.vehicleProvider?.id.toString() ??
                              '';
                      _addServiceEventBloc.mainStreamController.sink.add(true);
                    },
                  );
                },
              );
            },
            addProd: () {
              openAddSheetAddProvider(
                  context: context, addServiceEventBloc: _addServiceEventBloc);
            },
            deleteProd: () {
              setState(() {
                _addServiceEventBloc.txtProvId?.text = '';
              });
            },
            attachmentList: _addServiceEventBloc.profilePic,
            serviceDetailList: _addServiceEventBloc.arrServiceList,
            onServiceActionPress: (action, index) {
              if (action == 'add') {
                openSheetService(
                  context: context,
                  details: index < 0
                      ? null
                      : _addServiceEventBloc.arrServiceList[index],
                  isHidePrice: ((_addServiceEventBloc.arrVehicle ??
                                  [])[_addServiceEventBloc.selectedVehicle]
                              .isMyVehicle ??
                          0) ==
                      0,
                  onSave: (value) {
                    if (index >= 0) {
                      _addServiceEventBloc.arrServiceList[index] = value!;
                    } else {
                      _addServiceEventBloc.arrServiceList.add(value!);
                    }
                    _addServiceEventBloc.mainStreamController.sink.add(true);
                  },
                );
              } else if (action == 'edit') {
                openSheetService(
                  context: context,
                  index: index,
                  details: _addServiceEventBloc.arrServiceList[index],
                  isHidePrice: ((_addServiceEventBloc.arrVehicle ??
                                  [])[_addServiceEventBloc.selectedVehicle]
                              .isMyVehicle ??
                          0) ==
                      0,
                  onSave: (value) {
                    _addServiceEventBloc.arrServiceList[index] = value!;
                    _addServiceEventBloc.mainStreamController.sink.add(true);
                  },
                );
              } else if (action == 'delete') {
                Utils.showAlertDialogCallBack1(
                    context: context,
                    message: StringConstants.confirm_service_list_deletion,
                    isConfirmationDialog: false,
                    isOnlyOK: false,
                    navBtnName: StringConstants.cancelSmall,
                    posBtnName: StringConstants.confirm,
                    onNavClick: () {},
                    onPosClick: () {
                      _addServiceEventBloc.arrServiceList.removeAt(index);
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
                          Navigator.of(context).popUntil(
                              ModalRoute.withName(RouteName.addEvent));
                          CommonToast.getInstance().displayToast(
                              message: StringConstants.select_pdf);
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
                  RouteName.addEvent,
                );
              }
            },
            onActionPress: (action, index) {
              if (action == 'main') {
                if ((_addServiceEventBloc.profilePic[index].docType ?? '1') ==
                    '1') {
                  Utils.showImageDialogCallBack(
                      context: context,
                      image:
                          _addServiceEventBloc.profilePic[index].attachmentUrl);
                } else {
                  if (_addServiceEventBloc.profilePic[index].attachmentUrl
                      is String) {
                    Utils.launchURL(
                        _addServiceEventBloc.profilePic[index].attachmentUrl ??
                            '');
                  } else {
                    OpenFile.open(
                        (_addServiceEventBloc.profilePic[index].attachmentUrl)
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
                            .popUntil(ModalRoute.withName(RouteName.addEvent));
                        return;
                      }
                      var a = value.path.split('.');
                      var b = StringConstants.arrAudio
                          .contains(a[a.length - 1].toLowerCase());
                      await processFile(
                          value,
                          context,
                          b ? '2' : '4',
                          _addServiceEventBloc.mainStreamController,
                          _addServiceEventBloc.profilePic,
                          value.path.split('/').last);
                    }
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName(RouteName.addEvent));
                  },
                  onGalleryClick: () async {
                    showLoading(context);
                    var value = await Utils.imgFromGallery();
                    if (value != null) {
                      if (!await checkFileSize(value, context)) {
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName(RouteName.addEvent));
                        return;
                      }
                      await processFile(
                        value,
                        context,
                        '1',
                        _addServiceEventBloc.mainStreamController,
                        _addServiceEventBloc.profilePic,
                        value.path.split('/').last,
                      );
                    }
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName(RouteName.addEvent));
                  },
                  onTakePhotoClick: () async {
                    showLoading(context);
                    var value = await Utils.imgFromCamera();
                    if (value != null) {
                      if (!await checkFileSize(value, context)) {
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName(RouteName.addEvent));
                        return;
                      }
                      await processFile(
                          value,
                          context,
                          '1',
                          _addServiceEventBloc.mainStreamController,
                          _addServiceEventBloc.profilePic,
                          '${DateTime.now().millisecondsSinceEpoch}.png');
                    }
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName(RouteName.addEvent));
                  },
                  onVideoClick: () async {
                    showLoading(context);
                    var value = await Utils.videoFromGallery();
                    if (value != null) {
                      if (!await checkFileSize(value, context)) {
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName(RouteName.addEvent));
                        return;
                      }
                      await processFile(
                          value,
                          context,
                          '3',
                          _addServiceEventBloc.mainStreamController,
                          _addServiceEventBloc.profilePic,
                          value.path.split('/').last);
                    }
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName(RouteName.addEvent));
                  },
                );
              } else if (action == 'delete') {
                if (_addServiceEventBloc.profilePic[index].type != 'file') {
                  _addServiceEventBloc.delete_image =
                      _addServiceEventBloc.delete_image +
                          ',${_addServiceEventBloc.profilePic[index].id}';
                }
                _addServiceEventBloc.profilePic.removeAt(index);
                setState(() {});
              }
            },
          ),
          AddNoteTabView(
              textEditingController: _addServiceEventBloc.txtNote,
              value: false),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: tabController!.index != 1
          ? BlueButton(
              text: StringConstants.save,
              onPress: () async {
                _addServiceEventBloc.addServiceEvent(
                  context: context,
                  showDialogCallback: () => _showDialog(context),
                );
              },
            )
          : BlueButton(
              text: StringConstants.done,
              onPress: () {
                setState(() {
                  _addServiceEventBloc.vehicleService?.notes =
                      _addServiceEventBloc.txtNote.text;
                  isActive = false;
                });
                _addServiceEventBloc.successMessage();
              },
              enable: isActive,
            ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialogBox.anotherService(
          onPress: () {
            AppComponentBase.getInstance().load(true);
            Navigator.pushNamed(context, RouteName.dashboard);
          },
        );
      },
    );
  }

  void handleFile(File? value, String type, BuildContext context) async {
    if (value != null) {
      showLoading(context);

      if (!await checkFileSize(value, context)) {
        Navigator.pop(context);
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

      _addServiceEventBloc.formDate = formattedDate;
      _addServiceEventBloc.attachUrl = value;
      _addServiceEventBloc.type = type;
      _addServiceEventBloc.extensionT = value.path.split('/').last;
      await _addServiceEventBloc.scanImage(
          context: context, base64image: base64Image);

      _addServiceEventBloc.mainStreamController.sink.add(true);
      Navigator.of(context).popUntil(ModalRoute.withName(RouteName.addEvent));

      if (_addServiceEventBloc.arrServiceListVerify.isNotEmpty) {
        openSheetVerify(
          context: context,
          stream: _addServiceEventBloc.mainStream,
          onServiceActionPress: (action, index) {
            if (action == 'add') {
              openSheetService(
                context: context,
                details: index < 0
                    ? null
                    : _addServiceEventBloc.arrServiceListVerify[index],
                isHidePrice: ((_addServiceEventBloc.arrVehicle ??
                                [])[_addServiceEventBloc.selectedVehicle]
                            .isMyVehicle ??
                        0) ==
                    0,
                onSave: (value) {
                  if (index >= 0) {
                    _addServiceEventBloc.arrServiceListVerify[index] = value!;
                  } else {
                    _addServiceEventBloc.arrServiceListVerify.add(value!);
                  }
                  _addServiceEventBloc.mainStreamController.sink.add(true);
                },
              );
            } else if (action == 'edit') {
              openSheetService(
                context: context,
                index: index,
                details: index == null
                    ? null
                    : _addServiceEventBloc.arrServiceListVerify[index],
                isHidePrice: ((_addServiceEventBloc.arrVehicle ??
                                [])[_addServiceEventBloc.selectedVehicle]
                            .isMyVehicle ??
                        0) ==
                    0,
                onSave: (value) {
                  if (index != null) {
                    _addServiceEventBloc.arrServiceListVerify[index] = value!;
                  } else {
                    _addServiceEventBloc.arrServiceListVerify.add(value!);
                  }
                  _addServiceEventBloc.mainStreamController.sink.add(true);
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
                  _addServiceEventBloc.arrServiceListVerify.removeAt(index);
                  _addServiceEventBloc.mainStreamController.sink.add(true);
                },
              );
            }
          },
          vehicleProfile: _addServiceEventBloc
              .arrVehicle?[_addServiceEventBloc.selectedVehicle],
          serviceDetail: _addServiceEventBloc.arrServiceListVerify,
          onPress: () {
            _addServiceEventBloc.profilePic.add(Attachments(
              type: 'file',
              createdAt: _addServiceEventBloc.formDate,
              attachmentUrl: _addServiceEventBloc.attachUrl,
              docType: _addServiceEventBloc.type,
              id: -1,
              extensionName: _addServiceEventBloc.extensionT,
            ));
            _addServiceEventBloc.arrServiceList
                .addAll(_addServiceEventBloc.arrServiceListVerify);
            _addServiceEventBloc.arrServiceListVerify = [];
            CommonToast.getInstance()
                .displayToast(message: StringConstants.details_scanned);
            Navigator.of(context)
                .popUntil(ModalRoute.withName(RouteName.addEvent));
          },
          values: _addServiceEventBloc.arrServiceListVerify,
        );
      }
    }
  }
}
