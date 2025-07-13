import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/analytic_services.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/user_picture.dart';
import 'package:myride901/features/tabs/service_event/service_detail/service_event_detail_bloc.dart';
import 'package:myride901/features/tabs/service_event/service_detail/widget/commet_tab_view.dart';
import 'package:myride901/features/tabs/service_event/service_detail/widget/event_service_tab_bar.dart';
import 'package:myride901/features/tabs/service_event/service_detail/widget/event_tab_view.dart';
import 'package:myride901/features/tabs/service_event/service_detail/widget/note_tab_view.dart';

class ServiceEventDetailPage extends StatefulWidget {
  @override
  _ServiceEventDetailPageState createState() => _ServiceEventDetailPageState();
}

class _ServiceEventDetailPageState extends State<ServiceEventDetailPage>
    with SingleTickerProviderStateMixin {
  final _serviceEventDetailBloc = ServiceEventDetailBloc();
  AppThemeState _appTheme = AppThemeState();
  var _arguments;

  int headerSize = 170;
  bool isProfilePictureVisible = true;
  TabController? tabController;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _arguments =
          (ModalRoute.of(context)!.settings.arguments as ItemArgument).data;
      if (_arguments['vehicleService'] != null) {
        _serviceEventDetailBloc.vehicleService = _arguments['vehicleService'];
        _serviceEventDetailBloc.txtNote.text =
            _serviceEventDetailBloc.vehicleService?.notes ?? '';
      }
      if (_arguments['vehicleProfile'] != null) {
        _serviceEventDetailBloc.vehicleProfile = _arguments['vehicleProfile'];
      }
      if (_arguments['vehicleProvider'] != null) {
        _serviceEventDetailBloc.vehicleProvider = _arguments['vehicleProvider'];
        _serviceEventDetailBloc.serviceProviderId?.text =
            _serviceEventDetailBloc.vehicleProvider?.id.toString() ?? '';
        _serviceEventDetailBloc.getVehicleProviderByProviderId(
            context: context);
      }
      if (_arguments['isReminder'] != null) {
        _serviceEventDetailBloc.isReminder = _arguments['isReminder'];
      }
      if (_arguments['isReminderEdit'] != null) {
        _serviceEventDetailBloc.isReminderEdit = _arguments['isReminderEdit'];
      }
      if (_arguments['value'] != null) {
        _serviceEventDetailBloc.val = _arguments['value'];
      }
      if (_arguments['reminderData'] != null) {
        _serviceEventDetailBloc.reminderData = _arguments['reminderData'];
      }
      if (_arguments['reminder'] != null) {
        _serviceEventDetailBloc.reminder = _arguments['reminder'];
      }
      _serviceEventDetailBloc.getVehicleServiceByServiceId(context: context);

      _serviceEventDetailBloc.getServiceChatByServiceId(context: context);
      setState(() {});
    });

    tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController(keepScrollOffset: true);

    var keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardVisibilityController.onChange.listen((bool isVisible) {
      if (tabController!.index == 2) {
        setState(() {
          headerSize = isVisible ? 0 : 170;
          isProfilePictureVisible = isVisible ? false : true;
        });
      }
    });
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
      if (!tabController!.indexIsChanging) {
        if (tabController!.index == 2) {
          locator<AnalyticsService>().logScreens(name: "Instant Messaging");
          print("Event for messaging");
        }
      }
    });
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
        stream: _serviceEventDetailBloc.mainStream,
        builder: (context, snapshot) {
          if (_serviceEventDetailBloc.vehicleProfile == null)
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: _appTheme.primaryColor,
              actions: ((_serviceEventDetailBloc.vehicleProfile!.isMyVehicle ==
                          1) ||
                      (_serviceEventDetailBloc.vehicleProfile!.isMyVehicle ==
                              0 &&
                          (((_serviceEventDetailBloc
                                          .vehicleService?.vehicleEdit ??
                                      "0") ==
                                  "1") ||
                              ((_serviceEventDetailBloc
                                          .vehicleService?.serviceEdit ??
                                      "0") ==
                                  "1"))))
                  ? [
                      SizedBox(width: 10),
                      if (_serviceEventDetailBloc.vehicleProfile!.isMyVehicle ==
                          1)
                        InkWell(
                            onTap: () async {
                              await _serviceEventDetailBloc.btnDeleteClicked(
                                  context: context);
                              setState(() {});
                            },
                            child: SvgPicture.asset(AssetImages.delete)),
                      if (_serviceEventDetailBloc.vehicleProfile!.isMyVehicle ==
                          1)
                        SizedBox(width: 25),
                      InkWell(
                          onTap: () {
                            _serviceEventDetailBloc.btnEditClicked(
                                context: context);
                          },
                          child: SvgPicture.asset(AssetImages.edit)),
                      SizedBox(width: 20)
                    ]
                  : null,
              elevation: 0,
              title: Text(
                StringConstants.app_service_event,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white),
              ),
              leading: InkWell(
                  onTap: () {
                    _serviceEventDetailBloc.btnBackClicked(context: context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(AssetImages.left_arrow),
                  )),
            ),
            floatingActionButton:
                (_serviceEventDetailBloc.vehicleProfile!.isMyVehicle == 1 &&
                        tabController?.index == 0)
                    ? FloatingActionButton(
                        onPressed: () {
                          _serviceEventDetailBloc.btnShareClicked(
                              context: context);
                        },
                        backgroundColor: _appTheme.primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(AssetImages.share),
                        ),
                      )
                    : null,
            body: BlocProvider<ServiceEventDetailBloc>(
              bloc: _serviceEventDetailBloc,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: DefaultTabController(
                  length: 3,
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (context, value) {
                      return [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          backgroundColor: Colors.white,
                          floating: true,
                          pinned: true,
                          leading: null,
                          bottom: TabBar(
                            unselectedLabelColor: Colors.black.withOpacity(0.5),
                            labelPadding: EdgeInsets.symmetric(horizontal: 3),
                            labelColor: AppTheme.of(context).primaryColor,
                            indicatorColor: AppTheme.of(context).primaryColor,
                            labelStyle: GoogleFonts.roboto(
                                fontSize: 12, fontWeight: FontWeight.bold),
                            controller: tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            onTap: (index) {
                              //To hide keyboard when user tap on tab
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              setState(() {});
                            },
                            tabs: [
                              EventServiceTabBar(
                                icon: AssetImages.service,
                                isServiceTab: true,
                                text: StringConstants.event_c,
                              ),
                              if (_serviceEventDetailBloc
                                      .vehicleProfile!.isMyVehicle ==
                                  1)
                                EventServiceTabBar(
                                  icon: AssetImages.note_1,
                                  text: StringConstants.note.toUpperCase(),
                                ),
                              EventServiceTabBar(
                                // isNum: true,
                                icon: AssetImages.icon_message,
                                text:
                                    StringConstants.Conversations.toUpperCase(),
                              ),
                            ],
                          ),
                          expandedHeight: headerSize.toDouble(),
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 25),
                                  Visibility(
                                    visible: isProfilePictureVisible,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 25),
                                        UserPicture(
                                          fontSize: 28,
                                          size: Size(74, 74),
                                          text: _serviceEventDetailBloc
                                                  .vehicleProfile!.Nickname ??
                                              '',
                                          userPicture: Utils.getProfileImage(
                                              _serviceEventDetailBloc
                                                  .vehicleProfile!),
                                        ),
                                        SizedBox(width: 25),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              StringConstants.vehicle,
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: _appTheme.primaryColor
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              _serviceEventDetailBloc
                                                      .vehicleProfile!
                                                      .Nickname ??
                                                  '',
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                color: _appTheme.primaryColor,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: tabController,
                      children: [
                        EventTabView(
                          vehicleProfile:
                              _serviceEventDetailBloc.vehicleProfile!,
                          vehicleService:
                              _serviceEventDetailBloc.vehicleService!,
                          name: _serviceEventDetailBloc.vehicleProvider?.name ??
                              '',
                          email:
                              _serviceEventDetailBloc.vehicleProvider?.email ??
                                  '',
                          phone:
                              _serviceEventDetailBloc.vehicleProvider?.phone ??
                                  '',
                          onActionPress: (String action, int index) {
                            if (action == 'delete') {
                              _serviceEventDetailBloc.btnUpdateClicked(
                                  context: context,
                                  image: null,
                                  delete_image: _serviceEventDetailBloc
                                      .vehicleService!.attachments![index].id
                                      .toString());
                            } else if (action == 'add') {
                              _serviceEventDetailBloc.openSheet(
                                  context: context);
                            } else if (action == 'main') {
                              if ((_serviceEventDetailBloc.vehicleService!
                                          .attachments![index].docType ??
                                      '1') ==
                                  '1') {
                                Utils.showImageDialogCallBack(
                                    context: context,
                                    image: _serviceEventDetailBloc
                                            .vehicleService!
                                            .attachments![index]
                                            .attachmentUrl ??
                                        '');
                              } else {
                                Utils.launchURL(
                                    _serviceEventDetailBloc
                                            .vehicleService!
                                            .attachments![index]
                                            .attachmentUrl ??
                                        '',
                                    isForce: false);
                              }
                            }
                          },
                        ),
                        if (_serviceEventDetailBloc
                                .vehicleProfile!.isMyVehicle ==
                            1)
                          NoteTabView(
                            value: _serviceEventDetailBloc
                                        .vehicleService!.createdBy ==
                                    AppComponentBase.getInstance()
                                        .getLoginData()
                                        .user!
                                        .id
                                        .toString()
                                ? false
                                : true,
                            textEditingController:
                                _serviceEventDetailBloc.txtNote,
                            isEdit: ((_serviceEventDetailBloc
                                        .vehicleProfile?.isMyVehicle ==
                                    1) ||
                                (_serviceEventDetailBloc
                                            .vehicleProfile?.isMyVehicle ==
                                        0 &&
                                    (((_serviceEventDetailBloc.vehicleService!
                                                    .vehicleEdit ??
                                                "0") ==
                                            "1") ||
                                        ((_serviceEventDetailBloc
                                                    .vehicleService!
                                                    .serviceEdit ??
                                                "0") ==
                                            "1")))),
                            onSave: () {
                              _serviceEventDetailBloc.btnNoteSaveClicked(
                                  context: context);
                            },
                          ),
                        CommentTabView(
                          comments: _serviceEventDetailBloc.arrServiceChat,
                          vehicleProfile:
                              _serviceEventDetailBloc.vehicleProfile!,
                          txtComment: _serviceEventDetailBloc.txtComment,
                          chatScrollController:
                              _serviceEventDetailBloc.chatScrollController,
                          onLoad: () {
                            _serviceEventDetailBloc.getServiceChatByServiceId(
                                context: context, isFirst: false);
                          },
                          onSuffixIconClick: () {
                            if (_serviceEventDetailBloc.txtComment.text
                                    .trim() !=
                                '') {
                              _serviceEventDetailBloc.addServiceChat(
                                  context: context);
                            }
                          },
                          onDelete: (index) {
                            int reverseIndex =
                                _serviceEventDetailBloc.arrServiceChat.length -
                                    1 -
                                    int.parse(index.toString());
                            _serviceEventDetailBloc.deleteServiceChat(
                                context: context, index: reverseIndex);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
