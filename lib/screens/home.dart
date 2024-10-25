import 'package:DueSpot/screens/map.dart';
import 'package:DueSpot/screens/profile_page.dart';
import 'package:DueSpot/screens/wash_history.dart';
import 'package:flutter/material.dart';
import 'sp_detail_page.dart'; // Assuming this exists

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    MapPage(), // Home tab with Map
    CarWashHistoryPage(), // Due tab
    UserProfilePage(), // Account tab
  ];

  void _showServiceProviderModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search for a car wash service...",
                      prefixIcon: Icon(Icons.search, color: Colors.lightBlue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.lightBlue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.lightBlue),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildServiceProviderTile(
                          context,
                          {
                            'name': 'Shiny Car Wash',
                            'cuisine': 'Car Services',
                            'distance': '2.5 km',
                            'lat': -6.780000,
                            'lng': 39.250000,
                            'contactNumber': '123-456-7890',
                          },
                        ),
                        _buildServiceProviderTile(
                          context,
                          {
                            'name': 'Sparkle Auto Wash',
                            'cuisine': 'Car Services',
                            'distance': '3.1 km',
                            'lat': -6.770000,
                            'lng': 39.260000,
                            'contactNumber': '987-654-3210',
                          },
                        ),
                        _buildServiceProviderTile(
                          context,
                          {
                            'name': 'Clean & Go Car Wash',
                            'cuisine': 'Car Services',
                            'distance': '4.2 km',
                            'lat': -6.760000,
                            'lng': 39.270000,
                            'contactNumber': '555-123-4567',
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildServiceProviderTile(
      BuildContext context, Map<String, dynamic> providerDetails) {
    return ListTile(
      leading: Icon(Icons.local_car_wash, color: Colors.lightBlue),
      title: Text(providerDetails['name']),
      subtitle: Text(
          "${providerDetails['distance']} • ${providerDetails['cuisine']}"),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Navigate to ServiceProviderDetailPage with provider details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceProviderDetailPage(
              name: providerDetails['name'],
              cuisine: providerDetails['cuisine'],
              distance: providerDetails['distance'],
              latitude: providerDetails['lat'],
              longitude: providerDetails['lng'],
              contactNumber: providerDetails['contactNumber'],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          _showServiceProviderModal(context);
        },
        child: Icon(
          Icons.search_rounded,
          size: 20,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_car_wash_rounded),
            label: 'Due',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue,
        onTap: _onItemTapped,
      ),
    );
  }
}
