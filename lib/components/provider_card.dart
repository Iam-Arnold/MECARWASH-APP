import 'package:flutter/material.dart';
import '../screens/sp_detail_page.dart';

class SProviderCard extends StatelessWidget {
  final String name;
  final String cuisine;
  final String distance;

  SProviderCard(
      {required this.name, required this.cuisine, required this.distance});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceProviderDetailPage(
              name: name,
              cuisine: cuisine,
              distance: distance,
              latitude: -6.69007810,
              longitude: 39.09190870,
              contactNumber: "+255747113021",
            ),
          ),
        );
      },
      child: Container(
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
              Text('$cuisine • $distance',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
