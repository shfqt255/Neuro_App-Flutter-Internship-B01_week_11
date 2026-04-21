import 'package:directions_app/map_direction_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MapDirectionProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Map Screen"), centerTitle: true),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(33.6844, 73.0479),
              zoom: 14,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },

            onTap: (pos) {
              if (provider.origin == null) {
                provider.setOrigin(pos);
              } else {
                provider.setDestination(pos);
                provider.fetchDirections();
              }
            },
            markers: {
              if (provider.origin != null)
                Marker(
                  markerId: MarkerId("origin"),
                  position: provider.origin!,
                ),

              if (provider.destination != null)
                Marker(
                  markerId: MarkerId("destination"),
                  position: provider.destination!,
                ),
            },
            polylines: {
              if (provider.polylineCoordinates.isNotEmpty)
                Polyline(
                  polylineId: PolylineId("route"),
                  points: provider.polylineCoordinates,
                  width: 5,
                ),
            },
          ),
          if (provider.distance != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(12),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Distance: ${provider.distance}"),
                    Text("Duration: ${provider.duration}"),

                    SizedBox(height: 10),

                    /// Step Instructions
                    if (provider.steps.isNotEmpty)
                      Column(
                        children: [
                          Text(
                            _removeHtml(
                              provider.steps[provider
                                  .currentStepIndex]["html_instructions"],
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: provider.previousStep,
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: provider.nextStep,
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

String _removeHtml(String htmlText) {
  return htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
}
