import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/features/toolkit/safety_recalls/output/output_bloc.dart';
import 'package:myride901/features/toolkit/safety_recalls/output/widgets/expansion_tile.dart';

class OutputPage extends StatefulWidget {
  const OutputPage({Key? key}) : super(key: key);

  @override
  _OutputPageState createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  final _outputBloc = OutputBloc();
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _outputBloc.vehicle = VehicleProfile.fromJson(
          ((ModalRoute.of(context)!.settings.arguments as ItemArgument).data
              as dynamic)['vehicle']);
      setState(() {});
    });

    super.initState();
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
          stream: _outputBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              backgroundColor: Colors.white,
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
                  _outputBloc.vehicle?.recalls![0].vinNumber ?? '',
                  //StringConstants.recalls,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              body: BlocProvider<OutputBloc>(
                bloc: _outputBloc,
                child: ListView(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (_outputBloc.vehicle?.recalls! ?? []).length,
                      itemBuilder: (_, index) {
                        return ExpansionTileWidget(
                          recallsList: _outputBloc.vehicle?.recalls!,
                          i: index,
                          ind: index + 1,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
