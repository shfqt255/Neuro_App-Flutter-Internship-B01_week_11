import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/map_provider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapProvider>(context, listen: false).getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),

      body: Consumer<MapProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.currentPosition == null) {
            return Center(child: Text('Location permission denied'));
          }
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                provider.currentPosition!.latitude,
                provider.currentPosition!.longitude,
              ),
              zoom: 15,
            ),
            markers: provider.markers,
            onMapCreated: (controller) {
              provider.mapController.complete(controller);
            },
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
          );
        },
      ),
    );
  }
}
