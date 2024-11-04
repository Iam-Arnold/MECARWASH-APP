import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../theme/map_style.dart';

class MapPage extends StatefulWidget {
  final LatLng? destination;

  MapPage({this.destination});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  Set<Circle> _circles = Set<Circle>();

  final LatLng _center = const LatLng(-6.778567437130798, 39.26381723392923);
  final String _placesApiKey = 'XXX';
  final String _directionsApiKey = 'XXX';

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _journeyStarted = false;
  bool _arrivalNotified =
      false; // Flag to track if arrival notification was sent
  final double _arrivalThreshold = 50.0; // Distance in meters to notify arrival

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _initializeNotifications(); // Initialize notifications
  }

  // Initialize the local notifications plugin and request permissions
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // App icon

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request notification permissions explicitly
    _requestNotificationPermission();
  }

  // Request permission for notifications
  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  // Show notification
  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
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
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _updateCurrentLocation(LatLng(position.latitude, position.longitude));

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
          _checkJourneyProgress(newPosition, widget.destination!);
        }
      });
    } catch (e) {
      // Handle error here
    }
  }

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

    if (!_journeyStarted) {
      _journeyStarted = true;
      _showNotification("Journey Started", "Heading towards the destination");
    }

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

  // Check journey progress and notify when close to destination
  void _checkJourneyProgress(Position currentPosition, LatLng destination) {
    double distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      destination.latitude,
      destination.longitude,
    );

    print('Current distance to destination: $distance meters');

    if (distance < _arrivalThreshold && !_arrivalNotified) {
      _arrivalNotified = true;
      _showNotification("Arrived", "You have arrived at your destination");
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
        b = encodedPoints.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encodedPoints.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      final LatLng point =
          LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      points.add(point);
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

  Future<void> _locateUser() async {
    if (_currentPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 16),
      );
    } else {
      await _getCurrentLocation(); // Get location if it's null
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
              zoom: 16.0,
            ),
            markers: _markers,
            polylines: _polylines,
            circles: _circles,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 80, // Adjust this value to position the button as needed
            right: 10,
            child: FloatingActionButton(
              backgroundColor:
                  Colors.lightBlue, // Set button color to light blue
              onPressed: _locateUser,
              child: Icon(Icons.my_location,
                  color: Colors.white), // Set icon color to white
            ),
          ),
        ],
      ),
    );
  }
}
