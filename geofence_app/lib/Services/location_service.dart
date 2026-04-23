import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geofence_app/Pages/dialogs.dart';

class LocationService {
  static Future<Position?> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      final onLocation = await Dialogs.showLocationDisabledDialog(context);
      if (onLocation == true) {
        serviceEnabled = await Geolocator.openLocationSettings();
      }
      return null;
    }
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        Dialogs.showPermissionDeniedDialog(context);
        return null;
      }
    }
    if (locationPermission == LocationPermission.deniedForever) {
      Dialogs.showPermissionPermanentlyDeniedDialog(context);
      return null;
    }
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  Stream<Position> streamLocation() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }
}
