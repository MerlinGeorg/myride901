import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/drawer/setting/setting_bloc.dart';
import 'package:myride901/core/services/analytic_services.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _settingBloc = SettingBloc();
  AppThemeState _appTheme = AppThemeState();
  bool? isReceiveImpEmail,
      isCarRecallNotification,
      isSpecialOfferEmail,
      isDueDateEmail;

  @override
  void initState() {
    locator<AnalyticsService>().logScreens(name: "Settings Page");
    isReceiveImpEmail = false;
    isCarRecallNotification = false;
    isSpecialOfferEmail = false;
    isDueDateEmail = false;
    super.initState();
    _settingBloc.getVehicleList();
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, RouteName.dashboard);
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: StreamBuilder<bool>(
            initialData: null,
            stream: _settingBloc.mainStream,
            builder: (context, snapshot) {
              return (_settingBloc.isLoaded == true)
                  ? Scaffold(
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor: _appTheme.primaryColor,
                        leading: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, RouteName.dashboard);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(AssetImages.left_arrow),
                            )),
                        title: Text(
                          StringConstants.setting,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      body: BlocProvider<SettingBloc>(
                          bloc: _settingBloc,
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(20),
                            child: ListView(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                AccountSection(
                                  arrVehicle: _settingBloc.arrVehicle.length,
                                  changeCurrency: (Currency currency) async {
                                    await _settingBloc.updateVehicleCurrency(
                                        currency: currency.symbol,
                                        context: context);
                                    setState(() {});
                                  },
                                  changeDateFormat: (String format) async {
                                    await _settingBloc.changeDateFormat(
                                        context: context, date_format: format);
                                    setState(() {});
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          )),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }),
      ),
    );
  }
}

class AccountSection extends StatelessWidget {
  final Function(Currency)? changeCurrency;
  final Function(String)? changeDateFormat;
  final int? arrVehicle;

  const AccountSection({
    Key? key,
    this.changeCurrency,
    this.changeDateFormat,
    this.arrVehicle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          title: StringConstants.account,
          icon: AssetImages.user_bold,
        ),
        const SizedBox(height: 10),
        const Divider(),
        AccountItem(
          text: StringConstants.edit_profile,
          onPress: () {
            Navigator.pushNamed(context, RouteName.editProfile);
          },
        ),
        AccountItem(
          text: StringConstants.change_password,
          onPress: () {
            Navigator.pushNamed(context, RouteName.changePassword);
          },
        ),
        if ((arrVehicle ?? 0) > 0)
          AccountItem(
            text: StringConstants.select_currency,
            onPress: () {
              showCurrencyPicker(
                context: context,
                showFlag: true,
                showSearchField: true,
                showCurrencyName: true,
                showCurrencyCode: true,
                onSelect: (Currency currency) {
                  changeCurrency?.call(currency);
                },
              );
            },
          ),
        AccountItem(
          text: 'Select date formatting',
          onPress: () {
            _showDateFormatPicker(context);
          },
        ),
      ],
    );
  }

  void _showDateFormatPicker(BuildContext context) {
    final Map<String, String> dateFormatMapping = {
      'MM/DD/YYYY': 'MM/dd/yyyy',
      'DD/MM/YYYY': 'dd/MM/yyyy',
      'YYYY/MM/DD': 'yyyy/MM/dd',
      'MM-DD-YYYY': 'MM-dd-yyyy',
      'DD-MM-YYYY': 'dd-MM-yyyy',
      'YYYY.MM.DD': 'yyyy.MM.dd',
      'YYYY-MM-DD': 'yyyy-MM-dd',
    };
    final List<String> dateFormats = dateFormatMapping.keys.toList();

    final String? userDateFormat =
        AppComponentBase.getInstance().getLoginData().user?.date_format;

    String currentFormat = userDateFormat ?? dateFormatMapping.values.first;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Date Format',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dateFormats.length,
                  itemBuilder: (context, index) {
                    final displayFormat = dateFormats[index];
                    final actualFormat = dateFormatMapping[displayFormat]!;
                    final bool isSelected = actualFormat == currentFormat;

                    return ListTile(
                      title: Text(displayFormat),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        if (changeDateFormat != null) {
                          changeDateFormat!(actualFormat);

                          AppComponentBase.getInstance()
                              .getLoginData()
                              .user
                              ?.date_format = actualFormat;
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Header extends StatelessWidget {
  final String title;
  final String icon;

  const Header({Key? key, this.title = '', this.icon = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          height: 25,
          width: 25,
          color: AppTheme.of(context).primaryColor,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          title,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: AppTheme.of(context).primaryColor,
              letterSpacing: 0.5),
        )
      ],
    );
  }
}

class AccountItem extends StatelessWidget {
  const AccountItem({Key? key, this.text = '', this.onPress}) : super(key: key);
  final String text;
  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress?.call();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Text(
              text,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: AppTheme.of(context).primaryColor),
            ),
            Spacer(),
            RotatedBox(
              quarterTurns: 90,
              child: SvgPicture.asset(
                AssetImages.left_arrow,
                color: AppTheme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NotificationSection extends StatelessWidget {
  const NotificationSection(
      {Key? key,
      this.receiveImpEmail,
      this.carRecallNotification,
      this.specialOfferEmail,
      this.dueDateEmail,
      this.isReceiveImpEmail,
      this.isCarRecallNotification,
      this.isSpecialOfferEmail,
      this.isDueDateEmail})
      : super(key: key);
  final Function(bool)? receiveImpEmail;
  final Function(bool)? carRecallNotification;
  final Function(bool)? specialOfferEmail;
  final Function(bool)? dueDateEmail;
  final bool? isReceiveImpEmail;
  final bool? isCarRecallNotification;
  final bool? isSpecialOfferEmail;
  final bool? isDueDateEmail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          title: StringConstants.notification,
          icon: AssetImages.notification_bell,
        ),
        SizedBox(
          height: 10,
        ),
        Divider(),
        NotificationItem(
          isSelected: isReceiveImpEmail,
          text: StringConstants.receive_imp_email,
          onChange: receiveImpEmail!,
        ),
        NotificationItem(
          isSelected: isCarRecallNotification,
          text: StringConstants.receive_car_recall_notification,
          onChange: carRecallNotification!,
        ),
        NotificationItem(
          isSelected: isSpecialOfferEmail,
          text: StringConstants.receiver_sp_offers_email,
          onChange: specialOfferEmail!,
        ),
        NotificationItem(
          isSelected: isDueDateEmail,
          text: StringConstants.receiver_due_date,
          onChange: dueDateEmail!,
        ),
      ],
    );
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem(
      {Key? key, this.text = '', this.onChange, this.isSelected})
      : super(key: key);
  final String text;
  final Function(bool)? onChange;
  final isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            text,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: AppTheme.of(context).primaryColor),
          ),
          Spacer(),
          CupertinoSwitch(
            value: isSelected,
            onChanged: onChange,
            activeColor: AppTheme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
