import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myride901/core/services/analytic_services.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/toolkit/find_shop/shops_bloc.dart';
import 'package:myride901/features/toolkit/find_shop/widgets/shop_list_view.dart';

class Shops extends StatefulWidget {
  const Shops({Key? key}) : super(key: key);

  @override
  State<Shops> createState() => _ShopsState();
}

class _ShopsState extends State<Shops> {
  final _shopBloc = ShopsBloc();

  @override
  void initState() {
    super.initState();
    locator<AnalyticsService>().logScreens(name: "Shops Page");

    _shopBloc.fetchShops(context: context);
  }

  void toggleView(int index) {
    setState(() {
      _shopBloc.isMapView = index == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _appTheme = AppTheme.of(context);

    return StreamBuilder<bool>(
      initialData: null,
      stream: _shopBloc.mainStream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(AssetImages.left_arrow),
                )),
            backgroundColor: _appTheme.primaryColor,
            title: const Text(
              'Find Service Shop',
              style: TextStyle(color: Colors.white),
            ),
            elevation: 2,
            actions: [
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: Colors.white),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.list, color: Colors.black),
                      title: Text('List View',
                          style: TextStyle(color: Colors.black)),
                      onTap: () {
                        toggleView(1);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.map, color: Colors.black),
                      title: Text('Map View',
                          style: TextStyle(color: Colors.black)),
                      onTap: () {
                        toggleView(0);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: BlocProvider<ShopsBloc>(
              bloc: _shopBloc,
              child: (_shopBloc.isLoaded == false)
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Color(0xff0C1248),
                    ))
                  : _shopBloc.isMapView == true
                      ? GoogleMap(
                          onMapCreated: (controller) {
                            setState(() {
                              _shopBloc.onMapCreated(controller);
                            });
                          },
                          initialCameraPosition: CameraPosition(
                            target: _shopBloc.userPosition!,
                            zoom: 13.0,
                          ),
                          markers: _shopBloc.markers,
                          myLocationEnabled: true,
                        )
                      : ShopListView(
                          combinedShops: _shopBloc.combinedShops,
                          shopsBloc: _shopBloc,
                        )),
        );
      },
    );
  }
}
