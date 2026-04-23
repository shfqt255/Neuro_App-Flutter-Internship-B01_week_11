import 'package:flutter/material.dart';
import 'package:geofence_app/Models/models.dart';

class GeofenceProvider extends ChangeNotifier {
  final List<GeofenceModel> _geofences = [];
  List<GeofenceModel> get geofences => _geofences;

  void addGeofence(GeofenceModel geofence) {
    _geofences.add(geofence);
    notifyListeners();
  }

  void loadDefaultGeofence() {
    if (_geofences.isEmpty) {
      _geofences.add(
        GeofenceModel(
          id: 'default',
          latitude: 33.684410,
          longitude: 72.903643,
          radius: 200,
        ),
      );
      notifyListeners();
    }
  }
}
