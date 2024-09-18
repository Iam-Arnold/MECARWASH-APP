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
  Set<Polyline> _polylines = Set<Polyline>(); // Store polylines for the route
  Set<Circle> _circles = Set<Circle>(); // Store circle for current location
  bool _isSearchActive = false;

  final LatLng _center = const LatLng(-6.778567437130798, 39.26381723392923);

  final String _placesApiKey = 'AIzaSyB4Hz_DKceY_QL0jg4ID7Hy_653UlZb5Qg';
  final String _directionsApiKey = 'AIzaSyB4Hz_DKceY_QL0jg4ID7Hy_653UlZb5Qg';

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
        // Add a blue circle to indicate current location with fading radius
        _circles.add(
          Circle(
            circleId: CircleId('current_location'),
            center: _currentPosition!,
            radius: 10000, // 100 meter radius
            fillColor: Colors.blue.withOpacity(0.3),
            strokeColor: Colors.blueAccent,
            strokeWidth: 10,
          ),
        );
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_currentPosition!, 22),
        );
      });

      _fetchNearbyPlaces();

      // Start navigation only if destination is provided
      if (widget.destination != null) {
        _startNavigation(widget.destination!);
      }

      // Continuously update current location and camera position
      Geolocator.getPositionStream(
              locationSettings:
                  LocationSettings(accuracy: LocationAccuracy.high))
          .listen((Position newPosition) {
        _currentPosition = LatLng(newPosition.latitude, newPosition.longitude);
        setState(() {
          // Update the blue circle to follow the new current location
          _circles = {
            Circle(
              circleId: CircleId('current_location'),
              center: _currentPosition!,
              radius: 10000,
              fillColor: Colors.blue.withOpacity(0.3),
              strokeColor: Colors.blueAccent,
              strokeWidth: 2,
            ),
          };
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(_currentPosition!),
          );
        });
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _fetchNearbyPlaces() async {
    if (_currentPosition == null) return;

    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    final String location =
        '${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final String radius = '5000'; // 5 km search radius
    final String type = 'car_wash|car_repair'; // Specify the type of places
    final String url =
        '$baseUrl?location=$location&radius=$radius&type=$type&key=$_placesApiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> places = data['results'];

        setState(() {
          for (var place in places) {
            final LatLng placeLocation = LatLng(
              place['geometry']['location']['lat'],
              place['geometry']['location']['lng'],
            );
            _markers.add(
              Marker(
                markerId: MarkerId(place['place_id']),
                position: placeLocation,
                infoWindow: InfoWindow(
                  title:
                      '${place['name']} 🟦', // Add blue square as a visual aid
                  snippet: '${place['vicinity']} 🟩', // Add green square emoji
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              ),
            );
          }
        });
      } else {
        print('Failed to load nearby places: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching nearby places: $e');
    }
  }

  Future<void> _startNavigation(LatLng destination) async {
    if (_currentPosition == null) return;

    final String baseUrl =
        'https://maps.googleapis.com/maps/api/directions/json';
    final String origin =
        '${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final String dest = '${destination.latitude},${destination.longitude}';
    final String url =
        '$baseUrl?origin=$origin&destination=$dest&key=$_directionsApiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> routes = data['routes'];

        if (routes.isNotEmpty) {
          final polylinePoints = routes[0]['overview_polyline']['points'];
          final polyline = _convertToLatLng(polylinePoints);

          setState(() {
            _polylines.add(
              Polyline(
                polylineId: PolylineId('route'),
                points: polyline,
                color: Colors.blue,
                width: 5,
              ),
            );
            _markers.add(
              Marker(
                markerId: MarkerId('destination'),
                position: destination,
                infoWindow: InfoWindow(
                  title: 'Destination',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
            );
          });

          _mapController?.animateCamera(
            CameraUpdate.newLatLngBounds(
              LatLngBounds(
                southwest: LatLng(
                  _currentPosition!.latitude < destination.latitude
                      ? _currentPosition!.latitude
                      : destination.latitude,
                  _currentPosition!.longitude < destination.longitude
                      ? _currentPosition!.longitude
                      : destination.longitude,
                ),
                northeast: LatLng(
                  _currentPosition!.latitude > destination.latitude
                      ? _currentPosition!.latitude
                      : destination.latitude,
                  _currentPosition!.longitude > destination.longitude
                      ? _currentPosition!.longitude
                      : destination.longitude,
                ),
              ),
              50, // Padding
            ),
          );
        }
      } else {
       // print('Failed to get directions: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error getting directions: $e');
    }
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
    setState(() {
      _mapController = controller;
    });
    _mapController?.setMapStyle(MapStyle.style);
  }

  void _onSearchActive(bool isActive) {
    setState(() {
      _isSearchActive = isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/carwash.jpg',
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.7),
                      Colors.blueAccent.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ],
          ),
          title: Text('Hi, Arnold!', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Search_Bar(
                onSearchActive: _onSearchActive,
              ),
            ),
          ),
        ),
        body: Stack(children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 16.0), // Add padding for spacing
              child:
                  ServiceProvider(), // The horizontal list of service providers
            ),
          ),
        ]));
  }
}
