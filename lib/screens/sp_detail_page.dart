// ignore_for_file: deprecated_member_use

import '../screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../components/custom_header.dart';
import 'booking/customer_info.dart';
import 'booking/service_booking.dart'; // Import the new component
import 'package:url_launcher/url_launcher.dart';

class ServiceProviderDetailPage extends StatefulWidget {
  final String name;
  final String cuisine;
  final String distance;
  final double latitude;
  final double longitude;
  final String contactNumber;

  ServiceProviderDetailPage({
    required this.name,
    required this.cuisine,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.contactNumber,
  });

  @override
  _ServiceProviderDetailPageState createState() =>
      _ServiceProviderDetailPageState();
}

class _ServiceProviderDetailPageState extends State<ServiceProviderDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _isButtonVisible = true;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isButtonVisible) {
        setState(() {
          _isButtonVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isButtonVisible) {
        setState(() {
          _isButtonVisible = true;
        });
      }
    }
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  void _launchMaps() async {
    final url = 'google.navigation:q=${widget.latitude},${widget.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Replace the AppBar and Service Provider Image with CustomHeader
                CustomAppBar(
                  title: widget.name,
                  isBookmarked: _isBookmarked,
                  onBack: () => Navigator.of(context).pop(),
                  onBookmarkToggle: _toggleBookmark,
                ),

                SizedBox(height: 16),
                Container(
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.blueAccent,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: 'About'),
                      Tab(text: 'Services'),
                      Tab(text: 'Location'),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 400, // Set a fixed height for the tab content
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // About Tab

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // About Section
                            Text(
                              'About',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900], // Dark blue for title
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[
                                    50], // Light blue background for the box
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lorem Ipsum is printing and Lorem has been the industry\'s ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type book.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueGrey[
                                          800], // Blue-grey for description text
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () {
                                      // Add logic to handle "Read more"
                                    },
                                    child: Text(
                                      'Read more',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .blue, // Blue color for Read more
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            // Service Provider Section
                            Text(
                              'Service Provider',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900], // Dark blue for title
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                // Avatar
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://example.com/profile.jpg'), // Replace with actual image
                                  radius: 28,
                                ),
                                SizedBox(width: 12),
                                // Provider Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Robert Fox',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey[
                                              900], // Dark blue-grey for the name
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Service Provider',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blueGrey[
                                              600], // Lighter blue-grey for the role
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Icons (Email and Video Call)
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.email,
                                          color: Colors.blue[700],
                                          size: 28), // Email Icon
                                      onPressed: () {
                                        // Handle email action
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.videocam,
                                          color: Colors.blue[700],
                                          size: 28), // Video Call Icon
                                      onPressed: () {
                                        // Handle video call action
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Services Tab (with rounded boxes for services)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Our Services',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1,
                              children: [
                                _buildServiceBox(
                                    'Car Wash', Icons.directions_car),
                                _buildServiceBox(
                                    'Cleaning', Icons.cleaning_services),
                                _buildServiceBox(
                                    'Full Wash', Icons.local_car_wash),
                                _buildServiceBox(
                                    'Detailing', Icons.build_circle),
                                _buildServiceBox(
                                    'Oil Change', Icons.oil_barrel),
                                _buildServiceBox('Tire Change', Icons.build),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // Location Tab (Same as before)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Location Header with Icon
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blueAccent,
                                  size: 28,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Location',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),

                            // Distance Information with a subtle box
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.blueAccent.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.directions_walk,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Distance: ${widget.distance}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            // View on Map button with gradient and shadow
                            SizedBox(
                              width: double
                                  .infinity, // Make button take full width
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapPage(
                                        destination: LatLng(
                                            widget.latitude, widget.longitude),
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 5,
                                  backgroundColor: Colors.blue,
                                  shadowColor: Colors.blue.withOpacity(0.2),
                                ).copyWith(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    LinearGradient(
                                      colors: [
                                        Colors.blueAccent,
                                        Colors.lightBlueAccent
                                      ],
                                    ).createShader(
                                        Rect.fromLTWH(0, 0, 200, 70));
                                  }),
                                ),
                                child: Text(
                                  'View on Map',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Floating "Book Service Now" Button (same as before)
          AnimatedOpacity(
            opacity: _isButtonVisible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300),
            child: Align(
              alignment: Alignment.bottomCenter,
              widthFactor: 50,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerPreBookingInfo()),
                    );
                  },
                  label: Text('Book Service Now',
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Service Box Widget (as before)
  Widget _buildServiceBox(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
