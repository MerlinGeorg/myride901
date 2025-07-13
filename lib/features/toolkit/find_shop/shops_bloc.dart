import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopsBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  late GoogleMapController mapController;
  LatLng? userPosition;
  Set<Marker> markers = Set<Marker>();

  Stream<bool> get mainStream => mainStreamController.stream;
  TextEditingController? latitude = TextEditingController();
  TextEditingController? longitude = TextEditingController();
  List<dynamic>? shopsList;
  List<dynamic>? authShops;
  List<dynamic>? combinedShops;

  bool isLoaded = false;
  bool isMapView = false;

  @override
  void dispose() {
    mainStreamController.close();
  }

  Future<void> getUserPosition() async {
    final position = await getCurrentLocation();
    userPosition = LatLng(position.latitude, position.longitude);
    latitude?.text = position.latitude.toString();
    longitude?.text = position.longitude.toString();
    await getAuthShops(latitude?.text, longitude?.text);
  }

  Future<void> getAuthShops(String? lat, String? long) async {
    try {
      authShops = await AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .getAuthShops(
            latitude: lat,
            longitude: long,
          );

      mainStreamController.sink.add(true);
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  Future<void> fetchShops({BuildContext? context}) async {
    try {
      await getUserPosition();

      shopsList = await AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .fetchShops(
            latitude: latitude?.text,
            longitude: longitude?.text,
            radius: "5000",
          );

      combinedShops = [];

      if (authShops != null) {
        authShops!.forEach((authShop) {
          bool exists = combinedShops!
              .any((shop) => shop['place_id'] == authShop['place_id']);
          if (!exists) {
            combinedShops!.add(authShop);
          }
        });
      }

      if (shopsList != null) {
        shopsList!.sort((a, b) {
          double distanceA = a['distance'];
          double distanceB = b['distance'];
          return distanceA.compareTo(distanceB);
        });

        shopsList!.forEach((shop) {
          bool exists = combinedShops!.any(
              (combinedShop) => combinedShop['place_id'] == shop['place_id']);
          if (!exists) {
            combinedShops!.add(shop);
          }
        });
      }

      List<Marker> shopMarkers = [];

      await Future.forEach(combinedShops!, (shop) async {
        Map<String, dynamic> shopData = shop as Map<String, dynamic>;

        BitmapDescriptor markerIcon = await _getCustomMarkerIcon(
            authShops!.any((authShop) => authShop['auth'] == shopData['auth']));

        shopMarkers.add(Marker(
          markerId: MarkerId(shopData['place_id']),
          position: LatLng(
            shopData['latitude'],
            shopData['longitude'],
          ),
          infoWindow: InfoWindow(
            title: shopData['name'],
            snippet: 'Tap for details',
            onTap: () {
              showModalBottomSheet(
                context: context!,
                builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (shopData['google_maps_url'] != null)
                          ListTile(
                            leading: Icon(Icons.directions),
                            title: Text('Directions'),
                            onTap: () {
                              Navigator.pop(context);
                              Utils.launchURL(shopData['google_maps_url']);
                            },
                          ),
                        if (shopData['phone_number'] != "N/A")
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text('Phone'),
                            onTap: () {
                              Navigator.pop(context);
                              makePhoneCall(shopData['phone_number']);
                            },
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          icon: markerIcon,
        ));
      });

      markers.addAll(shopMarkers.toSet());
      isLoaded = true;
      mainStreamController.sink.add(true);
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  Future<BitmapDescriptor> _getCustomMarkerIcon(bool isAuth) async {
    String imageName = isAuth ? 'marker_a.png' : 'marker_g.png';
    Uint8List imageData = isAuth
        ? await _getBytesFromAsset(imageName, 120)
        : await _getBytesFromAsset(imageName, 100);
    return BitmapDescriptor.fromBytes(imageData);
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load('assets/new/$path');
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(jsonEncode(mapStyle));
    if (userPosition != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLng(userPosition!),
      );
    }
    mainStreamController.sink.add(true);
  }

  final List<Map<String, dynamic>> mapStyle = [
    {
      "featureType": "administrative",
      "elementType": "all",
      "stylers": [
        {"visibility": "off"},
        {"lightness": 33}
      ]
    },
    {
      "featureType": "poi",
      "elementType": "all",
      "stylers": [
        {"visibility": "off"}
      ]
    },
    {
      "featureType": "landscape",
      "elementType": "all",
      "stylers": [
        {"color": "#f2e5d4"}
      ]
    },
    {
      "featureType": "road",
      "elementType": "all",
      "stylers": [
        {"lightness": 20}
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {"color": "#c5c6c6"}
      ]
    },
    {
      "featureType": "road.arterial",
      "elementType": "geometry",
      "stylers": [
        {"color": "#e4d7c6"}
      ]
    },
    {
      "featureType": "road.local",
      "elementType": "geometry",
      "stylers": [
        {"color": "#fbfaf7"}
      ]
    },
    {
      "featureType": "water",
      "elementType": "all",
      "stylers": [
        {"visibility": "on"},
        {"color": "#acbcc9"}
      ]
    }
  ];

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
