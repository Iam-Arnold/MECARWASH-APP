import 'package:flutter/material.dart';
import '../screens/sp_detail_page.dart';

class ServiceProviderModal extends StatelessWidget {
  final List<Map<String, dynamic>> _serviceProviders = [
    {'name': 'Shiny Car Wash', 'cuisine': 'Car Services', 'distance': '2.5 km', 'lat': -6.780000, 'lng': 39.250000, 'contactNumber': '123-456-7890'},
    {'name': 'Sparkle Auto Wash', 'cuisine': 'Car Services', 'distance': '3.1 km', 'lat': -6.770000, 'lng': 39.260000, 'contactNumber': '987-654-3210'},
    {'name': 'Clean & Go Car Wash', 'cuisine': 'Car Services', 'distance': '4.2 km', 'lat': -6.760000, 'lng': 39.270000, 'contactNumber': '555-123-4567'},
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 5,
              )
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _serviceProviders.length,
                  itemBuilder: (context, index) {
                    var provider = _serviceProviders[index];
                    return ListTile(
                      leading: Icon(Icons.local_car_wash, color: Colors.blue),
                      title: Text(provider['name']),
                      subtitle: Text('Service: ${provider['cuisine']} • ${provider['distance']}'),
                      onTap: () {
                        Navigator.pop(context); // Close the modal
                        // Navigate to ServiceProviderDetailPage with provider details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceProviderDetailPage(
                              name: provider['name'],
                              cuisine: provider['cuisine'],
                              distance: provider['distance'],
                              latitude: provider['lat'],
                              longitude: provider['lng'],
                              contactNumber: provider['contactNumber'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
