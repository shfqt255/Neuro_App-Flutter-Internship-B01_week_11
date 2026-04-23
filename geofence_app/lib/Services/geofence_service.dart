import 'dart:math';
import 'package:geofence_app/Models/models.dart';
import 'location_service.dart';
import 'notification_service.dart';
import 'database_service.dart';

class GeofenceService {
  final List<GeofenceModel> _geofences = [];
  final Map<String, bool> _insideStatus = {};

  void registerGeofence(GeofenceModel geofence) {
    _geofences.add(geofence);
    _insideStatus[geofence.id] = false;
  }

  void startMonitoring() {
    LocationService().streamLocation().listen((position) {
      double lat = position.latitude;
      double lng = position.longitude;

      DatabaseService.insert(lat, lng);

      for (var gf in _geofences) {
        double distance = _calculateDistance(
          lat,
          lng,
          gf.latitude,
          gf.longitude,
        );

        bool isInside = distance <= gf.radius;
        bool wasInside = _insideStatus[gf.id] ?? false;

        if (isInside && !wasInside) {
          _insideStatus[gf.id] = true;
          onEnter(gf);
        } else if (!isInside && wasInside) {
          _insideStatus[gf.id] = false;
          onExit(gf);
        }
      }
    });
  }

  void onEnter(GeofenceModel gf) {
    NotificationService.show(
      title: "Geofence Entered",
      body: "You entered ${gf.id}",
    );
  }

  void onExit(GeofenceModel gf) {
    NotificationService.show(
      title: "Geofence Exit",
      body: "You exited ${gf.id}",
    );
  }

  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371000; // meters

    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  static double _degToRad(double deg) {
    return deg * (pi / 180);
  }
}
