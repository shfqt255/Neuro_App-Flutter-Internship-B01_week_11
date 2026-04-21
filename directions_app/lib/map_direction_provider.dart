import 'dart:convert';

import 'package:directions_app/apikey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapDirectionProvider extends ChangeNotifier {
  LatLng? origin;
  LatLng? destination;

  String? duration;
  String? distance;
  List<dynamic> steps = [];
  List<LatLng> polylineCoordinates = [];

  int currentStepIndex = 0;

  void setOrigin(LatLng pos) {
    origin = pos;
    notifyListeners();
  }

  void setDestination(LatLng pos) {
    destination = pos;
    notifyListeners();
  }

  Future<void> fetchDirections() async {
    if (origin == null || destination == null) return;

    final url =
        "https://maps.googleapis.com/maps/api/directions/json?"
        "origin=${origin!.latitude},${origin!.longitude}"
        "&destination=${destination!.latitude},${destination!.longitude}"
        "&key=${ApiKey.apiKey}";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['routes'] == null || data['routes'].isEmpty) return;

      // final allRoutes = data['routes'];
      final bestRoute = data['routes'][0];
      final leg = bestRoute['legs'][0];

      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
      steps = leg['steps'];

      String encodedPolyline = bestRoute["overview_polyline"]["points"];
      List<PointLatLng> result = PolylinePoints.decodePolyline(encodedPolyline);

      polylineCoordinates = result
          .map((e) => LatLng(e.latitude, e.longitude))
          .toList();
      notifyListeners();
    }
  }

  void nextStep() {
    if (currentStepIndex < steps.length - 1) {
      currentStepIndex++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStepIndex > 0) {
      currentStepIndex--;
      notifyListeners();
    }
  }
}
