import 'package:flutter/material.dart';
import 'package:places_app/places_screen.dart';
import 'package:provider/provider.dart';
import 'place_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PlaceProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PlaceScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
