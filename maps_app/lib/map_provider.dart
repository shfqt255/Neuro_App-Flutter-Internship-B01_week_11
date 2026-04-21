import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class MapProvider extends ChangeNotifier {
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  bool isLoading = false;
  final logger = Logger();

  final Set<Marker> _markers = {};
  Set<Marker> get markers => Set.unmodifiable(_markers);

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  Completer<GoogleMapController> get mapController => _mapController;

  // request location permission
  Future<void> requestLocationPermission() async {
    var status = Permission.location.status;
    await status.isDenied ? await Permission.location.request() : null;
  }

  // get current Location
  Future<void> getCurrentLocation() async {
    isLoading = true;
    notifyListeners();
    await requestLocationPermission();
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Current Location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: 'You are here',
          ),
        ),
      );
      await moveCameraToCurrentLocation();
    } catch (e) {
      logger.e('Failed to get current location: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // MoveCamera Movement
  Future<void> moveCameraToCurrentLocation() async {
    if (!mapController.isCompleted) {
      return;
    }
    final controller = await mapController.future;
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        15,
      ),
    );
  }

  // add markar
  void addMarker(LatLng position, String title, String snippet) {
    _markers.add(
      Marker(
        markerId: MarkerId(title),
        position: position,
        infoWindow: InfoWindow(title: title, snippet: snippet),
      ),
    );
    notifyListeners();
  }
}
