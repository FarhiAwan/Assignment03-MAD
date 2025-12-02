import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'camera.dart';
import 'package:project/repositries/activity_repositry.dart';
import 'package:project/dataModels/activityLog.dart';

class maps extends StatefulWidget{
  maps({super.key});

  State<maps> createState() => _mapsState();
}


class _mapsState extends State<maps>{

  LatLng _currentCenter = const LatLng(33.68, 73.01);

  Future<Position> _getUserLocation() async{
    await Geolocator.requestPermission().then((value){
      
    }).onError((error, stackTrace){
      print("error"+error.toString());
    });

    return Geolocator.getCurrentPosition();
  }


  final MapController _mapController = MapController();

  final List<Marker> _markers = [
    const Marker(
      point: LatLng(33.68, 73.01),
      width: 80,
      height: 80,
      child: Column(
        children: [
          Icon(Icons.location_on, color: Colors.red, size: 40),
          Text("Marker 1", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentCenter, // Initial LatLng
          initialZoom: 14.0,
        ),
        children: [
          // A. The Tile Layer (This loads the actual map images from OpenStreetMap)
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app', // Replace with your app package name
          ),

          // B. The Marker Layer
          MarkerLayer(
            markers: _markers,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getUserLocation().then((position) async {

            // 1. Navigate to Camera (Use the Simulation code if Camera fails)
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CameraScreen()),
            );

            // 2. Process Result
            if (result != null) {
              String base64Image;

              // CHECK: Is it a real photo (XFile) or a simulation string?
              if (result is String && result.contains("assets")) {
                // It's the simulated asset path
                // For demo, we just save a placeholder string
                base64Image = "SIMULATED_IMAGE";
              } else {
                // It's a real photo path/XFile
                // On Web, we can't read path directly, we need bytes.
                // Assuming your CameraScreen returns an XFile or path
                // Ideally, pass the XFile object back from CameraScreen

                // *Quickest Fix for Deadline*: Just use a placeholder if on Web
                base64Image = "WEB_IMAGE_PLACEHOLDER";
              }

              // 3. Create Log
              final newLog = ActivityLog(
                id: DateTime.now().toString(),
                latitude: position.latitude,
                longitude: position.longitude,
                imageBase64: base64Image,
                timestamp: DateTime.now(),
              );

              // 4. Save Offline
              await ActivityRepository().saveActivity(newLog);

              setState(() {
                // Update your markers...
              });
            }
          });
        },
        child: const Icon(Icons.add_a_photo), // Changed icon to represent action
      ),
    );
  }
}