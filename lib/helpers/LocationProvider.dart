import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider {
  int distance;

  LocationAccuracy locationAccuracy;

  LocationProvider(
      {this.locationAccuracy = LocationAccuracy.high, this.distance = 10});

  Future<Position?> provideLastKnownLocation() async {
    return await Geolocator.getLastKnownPosition();
  }

  Future<Position> provideCurrentLocation() async {
    Position _position =
        await Geolocator.getCurrentPosition(desiredAccuracy: locationAccuracy);

    if (_position == null) {
      _position = (await provideLastKnownLocation())!;
    }
    return _position;
  }

  provideLocationStream(Function listener) {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });

    /*var myResult = "";
    mySlowMethod((result) {
      myResult = result;
      print(myResult);
    });*/
  }

  Future<bool> checkForLocationPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return false;
    ;
    }
    return true;
  }

  Future<Placemark?> getLocationFromAddress(String address) async {
    List<Placemark> placemark =
        (await locationFromAddress(address)).cast<Placemark>();
    if (placemark != null && !placemark.isEmpty) return placemark.removeLast();
    return null;
  }

  Future<Placemark?> getAddressFromLocation(double lat, double lon) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lon);
    if (placemark != null && !placemark.isEmpty) return placemark.removeLast();
    return null;
  }
}
