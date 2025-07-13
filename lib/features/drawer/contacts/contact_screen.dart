import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/service_provider/service_provider.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/drawer/contacts/contact_bloc.dart';
import 'package:myride901/features/drawer/contacts/widgets/contact_list.dart';

class ContactSreen extends StatefulWidget {
  const ContactSreen({Key? key}) : super(key: key);

  @override
  State<ContactSreen> createState() => _ContactSreenState();
}

class _ContactSreenState extends State<ContactSreen> {
  final _serviceProviderBloc = ServiceProviderBloc();
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    super.initState();

    _serviceProviderBloc.getProviderList(
        context: context,
        isProgressBar:
            !AppComponentBase.getInstance().isArrVehicleProviderFetch);
  }

  @override
  void dispose() {
    super.dispose();
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
        stream: _serviceProviderBloc.mainStream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: _appTheme.primaryColor,
              elevation: 0,
              title: Text(
                StringConstants.app_service_provider,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white),
              ),
              leading: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.dashboard);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(AssetImages.left_arrow),
                ),
              ),
              actions: [
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RouteName.addProvider);
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
            body: BlocProvider<ServiceProviderBloc>(
              bloc: _serviceProviderBloc,
              child: StreamBuilder<dynamic>(
                  initialData: null,
                  stream: _serviceProviderBloc.mainStream,
                  builder: (context, snapshot) {
                    return StreamBuilder<dynamic>(
                        initialData: null,
                        stream: AppComponentBase.getInstance().loadStream,
                        builder: (context, snapshot) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: (_serviceProviderBloc.arrProvider.length ==
                                          0 &&
                                      _serviceProviderBloc.isLoaded)
                                  ? Center(
                                      child: Text(
                                        'You do not have any contacts yet',
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Color(0xff121212)
                                                .withOpacity(0.4)),
                                      ),
                                    )
                                  : ListView(
                                      physics: ClampingScrollPhysics(),
                                      padding: const EdgeInsets.all(0),
                                      children: [
                                        SizedBox(
                                            height: (((_serviceProviderBloc
                                                        .arrProvider.length) *
                                                    120.0) +
                                                110),
                                            child: ProviderListView(
                                              list: _serviceProviderBloc
                                                  .arrProvider,
                                              vehicleProvider:
                                                  VehicleProvider.fromJson({}),
                                              btnDeleteClicked: (index) {
                                                _serviceProviderBloc
                                                    .deleteProvider(
                                                        context: context,
                                                        index: index);
                                              },
                                              btnEditClicked: (index) {
                                                _serviceProviderBloc.btnClicked(
                                                    context: context,
                                                    index: index);
                                              },
                                            )),
                                      ],
                                    ));
                        });
                  }),
            ),
          );
        },
      ),
    );
  }
}
