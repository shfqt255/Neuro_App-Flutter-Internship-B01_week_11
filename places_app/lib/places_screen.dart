import 'package:flutter/material.dart';
import 'package:places_app/apikey.dart';
import 'package:places_app/place_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceScreen extends StatefulWidget {
  const PlaceScreen({super.key});

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<PlaceProvider>().init(Apikey.apiKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlaceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Places App"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          //search
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search place...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                provider.searchPlaces(value);
              },
            ),
          ),

          //autocomplete list
          if (provider.predictions.isNotEmpty)
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: provider.predictions.length,
                itemBuilder: (context, index) {
                  final item = provider.predictions[index];

                  return ListTile(
                    title: Text(item.description ?? ""),
                    onTap: () {
                      provider.selectPlace(item.placeId!);
                      searchController.clear();
                    },
                  );
                },
              ),
            ),

          // map
          Expanded(
            child: GoogleMap(
              initialCameraPosition: provider.initialPosition,
              markers: provider.markers,

              onMapCreated: (controller) {
                provider.mapController.complete(controller);
              },
            ),
          ),

          //  nearby places
          if (provider.nearbyPlaces.isNotEmpty)
            SizedBox(
              height: 120,
              child: ListView.builder(
                itemCount: provider.nearbyPlaces.length,
                itemBuilder: (context, index) {
                  final place = provider.nearbyPlaces[index];

                  return ListTile(title: Text(place.name ?? ""));
                },
              ),
            ),
        ],
      ),
    );
  }
}
