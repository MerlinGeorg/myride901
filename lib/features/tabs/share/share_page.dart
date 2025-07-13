import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/check_box.dart';
import 'package:myride901/features/tabs/share/share_bloc.dart';
import 'package:myride901/features/tabs/share/widget/dashboard_header.dart';
import 'package:myride901/features/tabs/share/widget/timeline_list_item.dart';
import 'package:myride901/features/drawer/my_ride_drawer.dart';
import 'package:myride901/core/services/analytic_services.dart';

//TODO : temp. create this class for display service remove it after API call and pass data direct
class ServiceListData {
  final String date;
  final String serviceName;
  final String miles;

  ServiceListData(this.date, this.serviceName, this.miles);
}

class SharePage extends StatefulWidget {
  final Function(int)? changeIndex;

  SharePage({this.changeIndex});
  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final _shareBloc = ShareBloc();
  AppThemeState _appTheme = AppThemeState();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    locator<AnalyticsService>().logScreens(name: "Share Page");
    super.initState();
    _shareBloc.user = AppComponentBase.getInstance().getLoginData().user;
    _shareBloc.getVehicleList(
        context: context,
        isProgressBar:
            !AppComponentBase.getInstance().isArrVehicleProfileFetch);
    _shareBloc.setLocalData();
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return StreamBuilder<dynamic>(
      initialData: null,
      stream: AppComponentBase.getInstance().loadStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          AppComponentBase.getInstance().load(null);
          _shareBloc.setLocalData();
        }
        return StreamBuilder<dynamic>(
          initialData: null,
          stream: _shareBloc.mainStream,
          builder: (context, snapshot) {
            return StreamBuilder<dynamic>(
              initialData: null,
              stream: AppComponentBase.getInstance().loadStream,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  AppComponentBase.getInstance().load(null);
                  _shareBloc.setLocalData();
                }
                return Scaffold(
                  key: _scaffoldKey,
                  floatingActionButton: _shareBloc.arrVehicle.length != 0 &&
                          _shareBloc.arrService.length != 0 &&
                          _shareBloc.arrVehicle[_shareBloc.selectedVehicle]
                                  .isMyVehicle ==
                              1
                      ? FloatingActionButton(
                          heroTag: "btn1",
                          onPressed: () {
                            _shareBloc.btnShareClicked(context: context);
                          },
                          backgroundColor: _appTheme.primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SvgPicture.asset(AssetImages.share),
                          ),
                        )
                      : null,
                  drawer: MyRideDrawer(),
                  body: BlocProvider<ShareBloc>(
                    bloc: _shareBloc,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          if (_shareBloc.arrVehicle.length != 0)
                            DashboardHeader(
                              vehicleId: _shareBloc.arrVehicle.length == 0
                                  ? 0
                                  : _shareBloc
                                          .arrVehicle[
                                              _shareBloc.selectedVehicle]
                                          .id ??
                                      0,
                              sharedEventBloc: _shareBloc,
                              data: 'April 2021',
                              events: _shareBloc.arrVehicle.length == 0
                                  ? '0'
                                  : _shareBloc.arrService.length.toString(),
                              years: _shareBloc.arrVehicle.length == 0
                                  ? ''
                                  : Utils.getYear(_shareBloc
                                      .arrVehicle[_shareBloc.selectedVehicle]),
                              vehicleImage: _shareBloc.arrVehicle.length == 0
                                  ? ''
                                  : Utils.getProfileImage(_shareBloc
                                      .arrVehicle[_shareBloc.selectedVehicle]),
                              vehicleName: _shareBloc.arrVehicle.length == 0
                                  ? null
                                  : (_shareBloc
                                              .arrVehicle[
                                                  _shareBloc.selectedVehicle]
                                              .isMyVehicle ==
                                          0
                                      ? _shareBloc
                                              .arrVehicle[
                                                  _shareBloc.selectedVehicle]
                                              .displayName ??
                                          ''
                                      : _shareBloc
                                              .arrVehicle[
                                                  _shareBloc.selectedVehicle]
                                              .Nickname ??
                                          ''),
                              onVehicleDropDownClick: () {
                                _shareBloc.selectVehicle(context, () {
                                  widget.changeIndex!(4);
                                });
                              },
                              onDrawerClick: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                            ),
                          if (_shareBloc.arrService.length != 0 &&
                              _shareBloc.isDisplaySelectionCheckBox &&
                              _shareBloc.arrVehicle[_shareBloc.selectedVehicle]
                                      .isMyVehicle ==
                                  1) ...[
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(width: 10),
                                MyRideCheckBox(
                                  size: Size(20, 20),
                                  onCheckClick: (value) {
                                    _shareBloc.selectDisSelectAllArrService(
                                        !_shareBloc.isAllSelected());
                                    setState(() {});
                                  },
                                  isChecked: _shareBloc.isAllSelected(),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('All')
                              ],
                            ),
                          ],
                          _shareBloc.arrVehicle.length == 0
                              ? (AppComponentBase.getInstance()
                                          .isArrVehicleProfileFetch &&
                                      _shareBloc.isLoaded
                                  ? Expanded(
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                              'Thanks for choosing MyRide901. To get started, please tap "+" below to add your first vehicle.',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color:
                                                      _appTheme.primaryColor),
                                            ),
                                          )),
                                    )
                                  : Container())
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount: _shareBloc.getArrServiceLength(),
                                    padding: const EdgeInsets.all(0),
                                    itemBuilder: (_, index) {
                                      if (index ==
                                              _shareBloc.getArrServiceLength() -
                                                  2 &&
                                          _shareBloc
                                                  .arrVehicle[_shareBloc
                                                      .selectedVehicle]
                                                  .isMyVehicle ==
                                              1) {
                                        return PurchasedItem(
                                          onPress: () {
                                            _shareBloc.openCalender(
                                                context: context);
                                          },
                                          purchaseDate: _shareBloc
                                                  .arrVehicle[_shareBloc
                                                      .selectedVehicle]
                                                  .PDate ??
                                              '',
                                        );
                                      } else if (index ==
                                          _shareBloc.getArrServiceLength() -
                                              1) {
                                        return Container();
                                        // return WelcomeMyRide();
                                      } else {
                                        return TimelineListItem(
                                          price: ((_shareBloc
                                                          .arrVehicle[_shareBloc
                                                              .selectedVehicle]
                                                          .isMyVehicle ??
                                                      0) ==
                                                  0)
                                              ? ''
                                              : _shareBloc.arrService[index]
                                                      .totalPrice ??
                                                  '',
                                          currency: _shareBloc
                                              .arrVehicle[
                                                  _shareBloc.selectedVehicle]
                                              .currency,
                                          isLast: _shareBloc
                                                      .arrVehicle[_shareBloc
                                                          .selectedVehicle]
                                                      .isMyVehicle ==
                                                  0 &&
                                              (index + 1) ==
                                                  _shareBloc.arrService.length,
                                          onCheckBoxClick: (value) {
                                            setState(() {
                                              _shareBloc.arrService[index]
                                                  .isSelected = value;
                                            });
                                          },
                                          isSelected: _shareBloc
                                                  .arrService[index]
                                                  .isSelected ??
                                              false,
                                          hasCheckBox: _shareBloc
                                                  .isDisplaySelectionCheckBox &&
                                              _shareBloc
                                                      .arrVehicle[_shareBloc
                                                          .selectedVehicle]
                                                      .isMyVehicle ==
                                                  1,
                                          onTap: () {
                                            _shareBloc.arrService[index]
                                                        .serviceProviderId ==
                                                    null
                                                ? _shareBloc
                                                    .serviceEventSelected2(
                                                        context: context,
                                                        index: index)
                                                : _shareBloc
                                                    .serviceEventSelected(
                                                        context: context,
                                                        index: index);
                                          },
                                          serviceName: _shareBloc
                                                  .arrService[index].title ??
                                              '',
                                          avatar: (_shareBloc
                                                  .arrService[index].avatar ??
                                              ''),
                                          miles: (_shareBloc.arrService[index]
                                                      .mileage ??
                                                  '') +
                                              ' ' +
                                              ((_shareBloc.arrService[index]
                                                              .mileage ??
                                                          '') ==
                                                      ''
                                                  ? ''
                                                  : ((_shareBloc
                                                                  .arrVehicle[
                                                                      _shareBloc
                                                                          .selectedVehicle]
                                                                  .mileageUnit ??
                                                              '') ==
                                                          'mile'
                                                      ? 'mi'
                                                      : 'km')),
                                          date: _shareBloc.arrService[index]
                                                  .serviceDate ??
                                              '',
                                        );
                                      }
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
