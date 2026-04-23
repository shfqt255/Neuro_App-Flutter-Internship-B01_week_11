import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geofence_app/Providers/geofence_provider.dart';
import 'package:geofence_app/Pages/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GeofenceProvider(),
      child: MaterialApp(
        title: 'Geofence App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
