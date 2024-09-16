import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math'; // Import 'dart:math' for trigonometric and square root functions

class SearchResults extends StatelessWidget {
  final List<Map<String, dynamic>> carWashCenters;
  final LatLng? userLocation;

  SearchResults({required this.carWashCenters, required this.userLocation});

  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; // in meters
    double lat1 = start.latitude * (pi / 180); // Use 'pi' instead of hardcoded value
    double lat2 = end.latitude * (pi / 180);
    double deltaLat = (end.latitude - start.latitude) * (pi / 180);
    double deltaLng = (end.longitude - start.longitude) * (pi / 180);

    double a = (sin(deltaLat / 2) * sin(deltaLat / 2)) +
        (cos(lat1) * cos(lat2) * sin(deltaLng / 2) * sin(deltaLng / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // returns distance in meters
  }

  @override
  Widget build(BuildContext context) {
    return carWashCenters.isEmpty
        ? Center(
            child: Text("No car wash centers found",
                style: TextStyle(color: Colors.grey.withOpacity(0.6))),
          )
        : ListView.builder(
            itemCount: carWashCenters.length,
            itemBuilder: (context, index) {
              final carWash = carWashCenters[index];
              double distance = userLocation != null
                  ? _calculateDistance(
                      userLocation!, LatLng(carWash['lat'], carWash['lng']))
                  : 0;

              return ListTile(
                title: Text(carWash['name']),
                subtitle:
                    Text('${(distance / 1000).toStringAsFixed(2)} km away'),
                leading: Icon(Icons.local_car_wash, color: Colors.blueAccent),
                onTap: () {
                  // Action when car wash center is tapped
                },
              );
            },
          );
  }
}
