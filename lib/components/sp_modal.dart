import 'package:flutter/material.dart';

class ServiceProviderModal extends StatelessWidget {
  final List<Map<String, dynamic>> _serviceProviders = [
    {'name': 'Shiny Car Wash', 'lat': -6.780000, 'lng': 39.250000},
    {'name': 'Sparkle Auto Wash', 'lat': -6.770000, 'lng': 39.260000},
    {'name': 'Clean & Go Car Wash', 'lat': -6.760000, 'lng': 39.270000},
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
                      subtitle: Text(
                          'Lat: ${provider['lat']}, Lng: ${provider['lng']}'),
                      onTap: () {
                        Navigator.pop(context);
                        // Implement logic to navigate to the provider or highlight on map
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
