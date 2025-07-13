import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/drawer/my_ride_drawer.dart';
import 'package:myride901/features/tabs/reminders/reminders_bloc.dart';

class RemindersPage extends StatefulWidget {
  final Function(int)? changeIndex;

  RemindersPage({this.changeIndex});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  AppThemeState _appTheme = AppThemeState();
  final _remindersBloc = RemindersBloc();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _remindersBloc.setLocalData();

    _remindersBloc.getReminderList(
        context: context,
        isProgressBar: !AppComponentBase.getInstance().isArrReminderFetch);
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MyRideDrawer(),
        appBar: AppBar(
          backgroundColor: _appTheme.primaryColor,
          elevation: 0,
          title: Text(
            StringConstants.app_reminders,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteName.dashboard);
            },
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: InkWell(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: RotatedBox(
                      quarterTurns: 90,
                      child: SvgPicture.asset(AssetImages.drawer))),
            ),
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.addReminder);
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )),
          ],
        ),
        body: BlocProvider<RemindersBloc>(
          bloc: _remindersBloc,
          child: StreamBuilder<dynamic>(
            initialData: null,
            stream: _remindersBloc.mainStream,
            builder: (context, snapshot) {
              return StreamBuilder<dynamic>(
                initialData: null,
                stream: AppComponentBase.getInstance().loadStream,
                builder: (context, snapshot) {
                  if (!_remindersBloc.isLoaded) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (_remindersBloc.arrReminder.isEmpty) {
                    // Show popup for adding the first reminder
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20), // Adjust the value as needed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Let's set up your first reminder.",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 20),
                            BlueButton(
                              onPress: () {
                                Navigator.pushNamed(
                                    context, RouteName.addReminder);
                              },
                              text: 'Add Reminder',
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: SlidableAutoCloseBehavior(
                          child: ListView.builder(
                            itemCount: _remindersBloc.arrReminder.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              DateTime eventDate = DateFormat(
                                      AppComponentBase.getInstance()
                                          .getLoginData()
                                          .user
                                          ?.date_format)
                                  .parse(
                                _remindersBloc.arrReminder[index].reminderDate!,
                              );

                              String status = getStatus(eventDate);

                              return Slidable(
                                key: Key(_remindersBloc.arrReminder[index].id
                                    .toString()),
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  extentRatio: 0.5,
                                  children: [
                                    SlidableAction(
                                      label: 'Snooze',
                                      backgroundColor: Colors.green,
                                      icon: Icons.alarm,
                                      onPressed: (context) async {
                                        await _remindersBloc.updateReminder(
                                            context: context, index: index);
                                        setState(() {
                                          _remindersBloc.getReminderList(
                                              context: context);
                                        });
                                      },
                                    ),
                                    SlidableAction(
                                      label: 'Delete',
                                      backgroundColor: Colors.red,
                                      icon: Icons.delete,
                                      onPressed: (context) {
                                        _remindersBloc.deleteReminder(
                                            context: context, index: index);
                                      },
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    _remindersBloc.btnClicked(
                                        context: context, index: index);
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      side: BorderSide(
                                        color: _appTheme.dividerColor,
                                        width: 1,
                                      ),
                                    ),
                                    margin: EdgeInsets.zero,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: ListTile(
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildStatusIndicator(status),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    _remindersBloc
                                                            .arrReminder[index]
                                                            .reminderName ??
                                                        '',
                                                    style:
                                                        TextStyle(fontSize: 24),
                                                  ),
                                                  SizedBox(height: 8),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          'Date: ${_remindersBloc.arrReminder[index].reminderDate ?? ""}',
                                        ),
                                        trailing: Container(
                                          padding: EdgeInsets.all(2),
                                          child: IconButton(
                                            icon: Icon(Icons.arrow_forward_ios,
                                                color: _appTheme.lightGrey,
                                                size: 16),
                                            onPressed: () {
                                              _remindersBloc.btnClicked(
                                                  context: context,
                                                  index: index);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String getStatus(DateTime eventDate) {
    DateTime currentDate = DateTime.now();
    if (eventDate.isAfter(currentDate)) {
      return 'Future';
    } else if (isSameDay(eventDate, currentDate)) {
      return 'Today';
    } else {
      return 'Expired';
    }
  }

  Widget _buildStatusIndicator(String status) {
    String label;
    Color backgroundColor;

    switch (status) {
      case 'Expired':
        label = 'Expired';
        backgroundColor = Colors.red;
        break;
      case 'Future':
        label = 'Future';
        backgroundColor = Colors.green;
        break;
      case 'Today':
        label = 'Today';
        backgroundColor = Colors.orange.withOpacity(0.8);
        break;
      default:
        label = '';
        backgroundColor = Colors.transparent;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
