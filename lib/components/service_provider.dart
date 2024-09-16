import 'package:flutter/material.dart';
import './provider_card.dart';

class ServiceProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SProviderCard(
              name: 'The Car Studio', cuisine: 'Italian', distance: '0.5 km'),
          SProviderCard(
              name: 'Alex Car Wash Center',
              cuisine: 'American',
              distance: '1 km'),
          SProviderCard(
              name: 'Car Maintanance', cuisine: 'Japanese', distance: '2 km'),
        ],
      ),
    );
  }
}
