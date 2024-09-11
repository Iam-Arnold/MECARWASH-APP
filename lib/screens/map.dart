import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../theme/map_style.dart';
import 'package:permission_handler/permission_handler.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  Set<Marker> _markers = Set<Marker>();

  final LatLng _center = const LatLng(-6.778567437130798, 39.26381723392923);

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (await Permission.location.request().isGranted) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _markers.add(
          Marker(
            markerId: MarkerId('current_location'),
            position: _currentPosition!,
            infoWindow: InfoWindow(
              title: 'Current Location',
              snippet: 'You are here',
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
        _mapController
            ?.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 16));
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
    _mapController?.setMapStyle(MapStyle.style);
    if (_currentPosition != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('current_location'),
            position: _currentPosition!,
            infoWindow: InfoWindow(
              title: 'Current Location',
              snippet: 'You are here',
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12.0,
            ),
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            markers: _markers,
          ),
          // Positioned(
          //   top: 50,
          //   left: 15,
          //   right: 15,
          //   child: SearchBar(), // Custom search bar at the top
          // ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: VenueList(), // Add the horizontal list at the bottom
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search places, food...',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VenueList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          VenueCard(name: 'The Palm', cuisine: 'Italian', distance: '0.5 km'),
          VenueCard(
              name: 'Burger Joint', cuisine: 'American', distance: '1 km'),
          VenueCard(name: 'Sushi Place', cuisine: 'Japanese', distance: '2 km'),
        ],
      ),
    );
  }
}

class VenueCard extends StatelessWidget {
  final String name;
  final String cuisine;
  final String distance;

  VenueCard(
      {required this.name, required this.cuisine, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('https://via.placeholder.com/150',
                height: 80, fit: BoxFit.cover),
            SizedBox(height: 5),
            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            Text('$cuisine • $distance', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
