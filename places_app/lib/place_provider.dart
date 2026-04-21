import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class PlaceProvider extends ChangeNotifier {
  final Completer<GoogleMapController> _mapController = Completer();
  Completer<GoogleMapController> get mapController => _mapController;

  late GooglePlace _googlePlace;

  void init(String apiKey) => _googlePlace = GooglePlace(apiKey);

  List<AutocompletePrediction> _predictions = [];
  List<AutocompletePrediction> get predictions => _predictions;

  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  List<SearchResult> _nearbyPlaces = [];
  List<SearchResult> get nearbyPlaces => _nearbyPlaces;

  CameraPosition initialPosition = const CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 14,
  );

  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      _predictions = [];
      notifyListeners();
      return;
    }
    try {
      var result = await _googlePlace.autocomplete.get(query);
      if (result?.predictions != null) {
        _predictions = result!.predictions!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Autocomplete error: $e');
    }
  }

  Future<void> selectPlace(String placeId) async {
    try {
      var details = await _googlePlace.details.get(placeId);
      final lat = details?.result?.geometry?.location?.lat;
      final lng = details?.result?.geometry?.location?.lng;
      if (lat == null || lng == null) return; // FIX 1: correct null check

      _predictions = [];
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(placeId),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: details?.result?.name),
        ),
      );

      await moveCamera(lat, lng);
      await getNearbyPlaces(lat, lng);
      notifyListeners();
    } catch (e) {
      debugPrint('Details error: $e');
    }
  }

  Future<void> getNearbyPlaces(double lat, double lng) async {
    try {
      var result = await _googlePlace.search.getNearBySearch(
        Location(lat: lat, lng: lng),
        1500,
      );
      if (result?.results != null) {
        _nearbyPlaces = result!.results!;
        for (final place in _nearbyPlaces) {
          final pLat = place.geometry?.location?.lat;
          final pLng = place.geometry?.location?.lng;
          if (pLat == null || pLng == null)
            continue; // FIX 2: each place's own coords
          _markers.add(
            Marker(
              markerId: MarkerId(place.placeId!),
              position: LatLng(pLat, pLng), // FIX 3: use pLat/pLng not lat/lng
              infoWindow: InfoWindow(title: place.name),
            ),
          );
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Nearby error: $e');
    }
  }

  Future<void> moveCamera(double lat, double lng) async {
    if (_mapController.isCompleted) {
      // FIX 4: removed wrong ! operator
      final controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15),
      );
    }
  }
}
