import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geofence_app/Providers/geofence_provider.dart';
import 'package:geofence_app/Services/location_service.dart';
import 'package:geofence_app/Services/notification_service.dart';
import 'package:geofence_app/Pages/history_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
  bool _isInsideGeofence = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    final provider = context.read<GeofenceProvider>();
    provider.loadDefaultGeofence();

    await NotificationService.init();

    if (!mounted) return;
    final position = await LocationService.getCurrentLocation(context);

    if (!mounted) return;
    if (position != null) {
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
      _checkGeofence(provider);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _checkGeofence(GeofenceProvider provider) {
    if (_currentPosition == null || provider.geofences.isEmpty) return;

    final geofence = provider.geofences.first;
    final distance = _calculateDistance(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      geofence.latitude,
      geofence.longitude,
    );

    final inside = distance <= geofence.radius;

    if (inside != _isInsideGeofence) {
      setState(() {
        _isInsideGeofence = inside;
      });
      NotificationService.show(
        title: 'Geofence Alert',
        body: inside
            ? 'You have entered the geofence zone.'
            : 'You have exited the geofence zone.',
      );
    }
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000.0; // meters
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geofence App'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'View History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<GeofenceProvider>(
              builder: (context, provider, child) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: ListTile(
                          leading: Icon(
                            _isInsideGeofence
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: _isInsideGeofence
                                ? Colors.green
                                : Colors.red,
                            size: 40,
                          ),
                          title: Text(
                            _isInsideGeofence
                                ? 'Inside Geofence'
                                : 'Outside Geofence',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_currentPosition != null) ...[
                        Text(
                          'Current Location:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                        ),
                        Text(
                          'Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (provider.geofences.isNotEmpty) ...[
                        Text(
                          'Geofence:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Center: (${provider.geofences.first.latitude}, ${provider.geofences.first.longitude})',
                        ),
                        Text('Radius: ${provider.geofences.first.radius}m'),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}
