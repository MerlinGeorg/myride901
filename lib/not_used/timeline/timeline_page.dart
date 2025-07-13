import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/not_used/timeline/timeline_bloc.dart';
import 'package:myride901/features/tabs/share/widget/timeline_list_item.dart';

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final _timelineBloc = TimelineBloc();
  AppThemeState _appTheme = AppThemeState();
  List<TimelineData> list = [];
  int listSize = 0;

  @override
  void initState() {
    super.initState();
    list.add(TimelineData('Service Name 1', '12306', '15 APR', '80.00'));
    list.add(TimelineData('Service Name 2', '1230', '13 APR', '20.00'));
    list.add(TimelineData('Service Name 3', '12336', '5 APR', '180.00'));
    list.add(TimelineData('Service Name 4', '126', '1 APR', '90.00'));
    list.add(TimelineData('Service Name 5', '1226', '10 APR', '30.00'));
    list.add(TimelineData('Service Name 6', '306', '25 APR', '10.00'));
    listSize = list.length + 2;
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _timelineBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: _appTheme.redColor,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(AssetImages.share),
                  ),
                ),
                body: BlocProvider<TimelineBloc>(
                  bloc: _timelineBloc,
                  child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                              color: AppTheme.of(context).primaryColor,
                              height: 110,
                              width: double.infinity),
                          Expanded(
                            child: ListView.builder(
                                itemCount: listSize,
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (_, index) {
                                  print('-----$index');
                                  if (index == listSize - 2) {
                                    return PurchasedItem(
                                      date: '01 APR',
                                      purchaseDate: '17 Nov 2019',
                                    );
                                  } else if (index == listSize - 1) {
                                    return WelcomeMyRide();
                                  } else {
                                    return TimelineListItem(
                                      onCheckBoxClick: (value) {
                                        setState(() {});
                                      },
                                      isSelected: false,
                                      hasCheckBox: false,
                                      onTap: () {},
                                      serviceName: list[index].serviceName,
                                      miles: list[index].km,
                                      date: list[index].date,
                                    );
                                  }
                                }),
                          )
                        ],
                      )),
                ));
          }),
    );
  }
}

class TimelineData {
  final String serviceName;
  final String km;
  final String date;
  final String amount;

  TimelineData(this.serviceName, this.km, this.date, this.amount);
}
