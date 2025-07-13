import 'package:flutter/material.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/toolkit/find_shop/shops_bloc.dart';
import 'build_star_rating.dart';

class ShopListView extends StatelessWidget {
  final List<dynamic>? combinedShops;
  final ShopsBloc shopsBloc;

  ShopListView({required this.combinedShops, required this.shopsBloc});

  @override
  Widget build(BuildContext context) {
    var _appTheme = AppTheme.of(context);

    return ListView.builder(
      itemCount: combinedShops?.length ?? 0,
      itemBuilder: (context, index) {
        final shopData = combinedShops?[index];
        if (shopData == null) {
          return Container();
        }

        return Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (shopData['auth'] == 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.asset(
                    AssetImages.logo_l,
                    width: 100,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      shopData['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _appTheme.primaryColor,
                      ),
                    ),
                  ),
                  if (shopData['auth'] == 1)
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        shopData['address'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '${shopData['distance'].toStringAsFixed(2)} km',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStarRating(shopData['rating'].toDouble(), context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.directions),
                        iconSize: 32,
                        color: _appTheme.primaryColor,
                        onPressed: () {
                          Utils.launchURL(shopData['google_maps_url']);
                        },
                      ),
                      if (shopData['phone_number'] != "N/A")
                        IconButton(
                          icon: Icon(Icons.phone),
                          color: _appTheme.primaryColor,
                          iconSize: 32,
                          onPressed: () {
                            shopsBloc.makePhoneCall(shopData['phone_number']);
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
