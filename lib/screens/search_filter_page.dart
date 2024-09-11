import 'package:flutter/material.dart';

class SearchFilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Search Filter'),
        actions: [
          TextButton(
            onPressed: () {
              // Apply filters
            },
            child: Text('Apply'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Applied Filters',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: [
                FilterChip(
                  label: Text('Italian'),
                  selected: true,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: Text('Hot Vine'),
                  selected: true,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: Text('< 10km'),
                  selected: true,
                  onSelected: (_) {},
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Ethnic Cuisines',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: Text('Mexican'),
                  selected: false,
                  onSelected: (_) {},
                ),
                ChoiceChip(
                  label: Text('Italian'),
                  selected: true,
                  onSelected: (_) {},
                ),
                ChoiceChip(
                  label: Text('Greek'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Popular Food', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: Text('Burgers'),
                  selected: false,
                  onSelected: (_) {},
                ),
                ChoiceChip(
                  label: Text('Hot Vine'),
                  selected: true,
                  onSelected: (_) {},
                ),
                ChoiceChip(
                  label: Text('Pasta'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Distance', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Slider(
              value: 10.0,
              min: 1.0,
              max: 50.0,
              onChanged: (double newValue) {
                // Handle distance filter
              },
              divisions: 10,
              label: '10km',
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Now Open'),
              value: true,
              onChanged: (bool value) {
                // Handle toggle
              },
            ),
            SwitchListTile(
              title: Text('Free Reservation'),
              value: false,
              onChanged: (bool value) {
                // Handle toggle
              },
            ),
          ],
        ),
      ),
    );
  }
}
