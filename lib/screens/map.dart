import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../components/search_bar.dart';
import '../components/service_provider.dart';
import '../theme/map_style.dart';

class MapPage extends StatefulWidget {
  final LatLng? destination; // Make destination optional

  MapPage({this.destination}); // Make destination optional

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  Set<Circle> _circles = Set<Circle>();
  bool _isSearchActive = false;
  bool _initialCameraSet = false;

  final LatLng _center = const LatLng(-6.778567437130798, 39.26381723392923);

  final String _placesApiKey = 'AIzaSyB4Hz_DKceY_QL0jg4ID7Hy_653UlZb5Qg';
  final String _directionsApiKey = 'AIzaSyB4Hz_DKceY_QL0jg4ID7Hy_653UlZb5Qg';

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    //     _mapController?.animateCamera(
    //   CameraUpdate.newLatLngZoom(_currentPosition!, 16),
    // );
  }

  Future<void> _checkPermissions() async {
    final permission = await Permission.location.request();
    if (permission.isGranted) {
      _getCurrentLocation();
    } else {
      // Handle permission denied scenario
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      //developer.log('The destination details: $widget.destination');
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _updateCurrentLocation(LatLng(position.latitude, position.longitude));

      // Fetch nearby carwashes and start navigation if destination is provided
      _fetchNearbyCarWashes();
      if (widget.destination != null) {
        _startNavigation(widget.destination!);
      }

      // Continuously update current location
      Geolocator.getPositionStream(
              locationSettings:
                  LocationSettings(accuracy: LocationAccuracy.high))
          .listen((Position newPosition) {
        _updateCurrentLocation(
            LatLng(newPosition.latitude, newPosition.longitude));
        if (widget.destination != null) {
          _startNavigation(widget.destination!);
        }
      });
    } catch (e) {
      // Handle error here
    }
  }

  // void _updateCurrentLocation(LatLng newPosition) {
  //   setState(() {
  //     _currentPosition = newPosition;
  //     _circles = {
  //       Circle(
  //         circleId: CircleId('current_location'),
  //         center: _currentPosition!,
  //         radius: 20,
  //         fillColor: Colors.blue.withOpacity(0.3),
  //         strokeColor: Colors.blueAccent,
  //         strokeWidth: 2,
  //       ),
  //     };

  //     // No camera movement here, as it is done only once in `_onMapCreated`
  //   });
  // }

  void _updateCurrentLocation(LatLng newPosition) {
    setState(() {
      _currentPosition = newPosition;
      _circles = {
        Circle(
          circleId: CircleId('current_location'),
          center: _currentPosition!,
          radius: 20,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blueAccent,
          strokeWidth: 2,
        ),
      };
    });
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentPosition!, 16),
    );
  }

  Future<void> _fetchNearbyCarWashes() async {
    if (_currentPosition == null) return;

    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=5000&type=car_wash&key=$_placesApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> places = data['results'];
        print(places); // Log to check if places are fetched correctly
        _updateMarkers(places);
      } else {
        print('Error fetching carwashes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching carwashes: $e');
    }
  }

  void _updateMarkers(List<dynamic> places) {
    setState(() {
      _markers.clear();
      for (var place in places) {
        final LatLng placeLocation = LatLng(
          place['geometry']['location']['lat'],
          place['geometry']['location']['lng'],
        );
        print('Adding marker at: $placeLocation'); // Log marker position

        _markers.add(
          Marker(
            markerId: MarkerId(place['place_id']),
            position: placeLocation,
            infoWindow: InfoWindow(
              title: '${place['name']} 🟦',
              snippet: '${place['vicinity']} 🟩',
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      }
    });
  }

  Future<void> _startNavigation(LatLng destination) async {
    if (_currentPosition == null) return;

    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_directionsApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final polylinePoints = data['routes'][0]['overview_polyline']['points'];
        _drawRoute(_convertToLatLng(polylinePoints), destination);
      }
    } catch (e) {
      // Handle error here
    }
  }

  void _drawRoute(List<LatLng> routePoints, LatLng destination) {
    setState(() {
      _polylines = {
        Polyline(
          polylineId: PolylineId('route'),
          points: routePoints,
          color: Colors.blue,
          width: 5,
        ),
      };
      _markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position: destination,
          infoWindow: InfoWindow(title: 'Destination'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    });
  }

  List<LatLng> _convertToLatLng(String encodedPoints) {
    final List<LatLng> points = [];
    int index = 0;
    int len = encodedPoints.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encodedPoints.codeUnitAt(index) - 63;
        index++;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encodedPoints.codeUnitAt(index) - 63;
        index++;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(
        LatLng(
          (lat / 1E5).toDouble(),
          (lng / 1E5).toDouble(),
        ),
      );
    }

    return points;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController!.setMapStyle(MapStyle.style);
    if (_currentPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 16),
      );
    }
  }

  void _onSearchActive(bool isActive) {
    setState(() {
      _isSearchActive = isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   flexibleSpace: Stack(
      //     fit: StackFit.expand,
      //     children: [
      //       Image.asset('assets/carwash.jpg', fit: BoxFit.cover),
      //       Container(
      //         decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //             colors: [
      //               Colors.blue.withOpacity(0.7),
      //               Colors.blueAccent.withOpacity(0.7)
      //             ],
      //             begin: Alignment.topLeft,
      //             end: Alignment.bottomRight,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      //   title: Text('Hi, Arnold!', style: TextStyle(color: Colors.white)),
      //   actions: [
      //     IconButton(
      //         icon: Icon(Icons.notifications, color: Colors.white),
      //         onPressed: () {}),
      //     Container(
      //       padding: EdgeInsets.symmetric(horizontal: 18),
      //       child: CircleAvatar(
      //           backgroundImage: AssetImage('assets/images/avatar.png')),
      //     ),
      //   ],
      //   bottom: PreferredSize(
      //     preferredSize: Size.fromHeight(kToolbarHeight),
      //     child: Padding(
      //       padding: EdgeInsets.all(8.0),
      //       child: Search_Bar(
      //         onSearchActive: _onSearchActive,
      //       ),
      //     ),
      //   ),
      // ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12.0,
            ),
            markers: _markers,
            polylines: _polylines,
            circles: _circles,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),
          if (_isSearchActive)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _onSearchActive(false),
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Search_Bar(
                    onSearchActive: _onSearchActive,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
